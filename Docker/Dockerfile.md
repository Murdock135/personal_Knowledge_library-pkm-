Primary reference: https://docs.docker.com/reference/dockerfile/#parser-directives
The dockerfile is the script that defines, in a sense, the spec sheet of an application. A proper definition would be the following:
**Definition**: A Dockerfile is a _formal specification document_ that enumerates a finite, ordered sequence of build instructions. Each instruction defines a deterministic transformation applied to a base state, and the sequential application of all instructions produces a target artifact.
# Beginning of a Dockerfile
- Dockerfiles must begin with the `FROM` **instruction.** This may be after [parser directives](https://docs.docker.com/reference/dockerfile/#parser-directives), [comments](https://docs.docker.com/reference/dockerfile/#format), and globally scoped [ARGs](https://docs.docker.com/reference/dockerfile/#arg). The `FROM` instruction specifies the [base image](https://docs.docker.com/glossary/#base-image) from which you are building. `FROM` may only be preceded by one or more `ARG` instructions, which declare arguments that are used in `FROM` lines in the Dockerfile.
# Comments
- BuildKit treats lines that begin with `#` as a comment, unless the line is a valid [parser directive](https://docs.docker.com/reference/dockerfile/#parser-directives). A `#` marker anywhere else in a line is treated as an argument. This allows statements like
```Dockerfile
# Comment
RUN echo 'we are running some # of cool things'
```
- Comment lines are removed before the Dockerfile instructions are executed. The comment in the following example is removed before the shell executes the `echo` command.
```Dockerfile
RUN echo hello \
# comment
world
```
# Leading whitespaces
- Leading whitespaces are removed. The following examples are therefore, equivalent.
```Dockerfile
        # this is a comment-line
    RUN echo hello
RUN echo world
```
```Dockerfile
# this is a comment-line
RUN echo hello
RUN echo world
```
- Whitespace in instruction arguments, however, isn't ignored. The following example prints `hello world` with leading whitespaces as specified:
```
RUN echo "\
     hello\
     world"
```
# Parser directives
Parser directives are optional, and affect the way in which subsequent lines in a Dockerfile are handled. They are written as a special type of comment in the form `# directive=value`, need to be at the very top of the Dockerfile. Once a comment, empty line or builder instruction has been processed, BuildKit no longer looks for parser directives. Instead it treats anything formatted as a parser directive as a comment and doesn't attempt to validate if it might be a parser directive. 
The following parser directives are supported:
- `syntax`
- `escape`
- `check`

- Use a blank line after a parser directive.
- The keys aren't case sensitive but values are.
## `syntax`
Use the `syntax` parser directive to declare the Dockerfile syntax version to use for the build. Most users will want to set this parser directive to `docker/dockerfile:1`, which causes BuildKit to pull the latest stable version of the Dockerfile syntax before the build.
```Dockerfile
# syntax=docker/dockerfile:1
```
## `escape`
- Use this to define the escape character. By default it is `\`. The escape character is used both to escape a character or to a new line.
- Note that regardless of whether the `escape` parser directive is included in a Dockerfile, escaping is not performed in a `RUN` command, except at the end of a line.
Consider the following example which would fail in a non-obvious way on Windows. The second `\` at the end of the second line would be interpreted as an escape for the newline, instead of a target of the escape from the first `\`. Similarly, the `\` at the end of the third line would, assuming it was actually handled as an instruction, cause it be treated as a line continuation. The result of this Dockerfile is that second and third lines are considered a single instruction:
```dockerfile
FROM microsoft/nanoserver
COPY testfile.txt c:\\
RUN dir c:\
```
Tip: if on windows, use "\`" as the escape character.
## `check`
- The `check` directive is used to configure how [build checks](https://docs.docker.com/build/checks/) are evaluated. By default, all checks are run, and failures are treated as warnings.
- You can disable specific checks using `#check=skip=<check-name>`. To specify multiple checks to skip, separate them with a comma:
```dockerfile
# check=skip=JSONArgsRecommended,StageNameCasing
  ```
- To disable all cheks, use `# check=skip=all`
- To *not* ignore warnings and fail on warnings , use `# check=error=true` (pin the dockerfile syntax if using this, otherwise, build may fail when new checks are added in future versions.)
- To combine both the `skip` and `error` options, use a semi-colon like `# check=skip=JsonArgsRecommended;error=true`

To see all available checks, see the [build checks reference](https://docs.docker.com/reference/build-checks/). Note that the checks available depend on the Dockerfile syntax version. To make sure you're getting the most up-to-date checks, use the [`syntax`](https://docs.docker.com/reference/dockerfile/#syntax) directive to specify the Dockerfile syntax version to the latest stable version.
# Environment replacement
- In certain instructions, *environment variables* (declared with the `ENV` statement) will be interpreted as variables. Those instructions are the following-
	- `ADD`
	- `COPY`
	- `ENV`
	- `EXPOSE`
	- `FROM`
	- `LABEL`
	- `STOPSIGNAL`
	- `USER`
	- `VOLUME`
	- `WORKDIR`
	- `ONBUILD` (when combined with one of the supported instructions above)
In the following instructions, *variable substitution* will be handled by the command shell-
	- `RUN`
	- `CMD`
	- `ENTRYPOINT`
> Note
> 
