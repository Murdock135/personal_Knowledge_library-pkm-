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
> Instructions using the exec form don't invoke the command shell automatically.
# .dockerignore file
Use the `.dockerignore` file to exclude files and directories from the build context. For more information, see [.dockerignore file](https://docs.docker.com/build/building/context/#dockerignore-files).
# Shell and exec form
The `RUN`, `CMD`, and `ENTRYPOINT` instructions all have two possible forms:
- `INSTRUCTION ["executable","param1","param2"]` (exec form) <- This is JSON array syntax.
- `INSTRUCTION command param1 param2` (shell form)
The exec form makes it possible to avoid shell string munging, and to invoke commands using a specific command shell, or any other executable. It uses a JSON array syntax, where each element in the array is a command, flag, or argument.

The shell form is more relaxed, and emphasizes ease of use, flexibility, and readability. The shell form automatically uses a command shell, whereas the exec form does not.
## Exec form
- The exec form doesn't automatically invoke a command shell. So `RUN ["echo", "$HOME"]` won't substitute `$HOME`. 
- You must escape backslashes like so, `RUN ["c:\\windows\\system32\\tasklist.exe"]`
## Shell form
- The shell form always invokes a command shell.
- This lets you escape new lines using the [[#`escape`]] character to continue a single instruction onto the next line
```dockerfile
RUN source $HOME/.bashrc && \
echo $HOME
```
- You can use Heredocs with the shell form as well. Like so,
```dockerfile
RUN <<EOF
source $HOME/.bashrc && \
echo $HOME
EOF
```
### Use a different shell
You can specify the shell using the `SHELL` command. Like so,
```
SHELL ["/bin/bash", "-c"]
RUN echo hello
```
> Note:
> The base image needs to have the shell to use the declared shell. If it doesn't have it at inception, simply install it with the package manager.

# `FROM`
```dockerfile
FROM [--platform=<platform>] <image> [AS <name>]
```
or,
```dockerfile
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
```
or,
```dockerfile
FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
```
- `FROM` sets the base image.
> Note
> `ARG` is the only command that may precede `FROM`.
- `FROM` can be used multiple times within a single dockerfile to use multiple images or use one build stage as a dependency for another.
> Warning!
> Each `FROM` instruction clears any state created by previous instructions.
- Optionally a name can be given to a new build stage by adding `AS name` to the `FROM` instruction. The name can be used in subsequent `FROM <name>`, [`COPY --from=<name>`](https://docs.docker.com/reference/dockerfile/#copy---from), and [`RUN --mount=type=bind,from=<name>`](https://docs.docker.com/reference/dockerfile/#run---mounttypebind) instructions to refer to the image built in this stage.
- The `tag` or `digest` values are optional. If you omit either of them, the builder assumes a `latest` tag by default. The builder returns an error if it can't find the `tag` value.
- The optional `--platform` flag can be used to specify the platform of the image in case `FROM` references a multi-platform image. For example, `linux/amd64`, `linux/arm64`, or `windows/amd64`. By default, the target platform of the build request is used. Global build arguments can be used in the value of this flag, for example [automatic platform ARGs](https://docs.docker.com/reference/dockerfile/#automatic-platform-args-in-the-global-scope) allow you to force a stage to native build platform (`--platform=$BUILDPLATFORM`), and use it to cross-compile to the target platform inside the stage.
## Understand how `ARG` and `FROM` interact
- `FROM` instructions support `ARG`s declared earlier.
```dockerfile
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}
CMD  /code/run-app

FROM extras:${CODE_VERSION}
CMD  /code/run-extras
```
# `RUN`
- `RUN` will execute any command to create a new layer.
```dockerfile
# Shell form:
RUN [OPTIONS] <command> ...
# Exec form:
RUN [OPTIONS] [ "<command>", ... ]
```
Example:
```dockerfile
# shell form
RUN <<EOF
apt-get update
apt-get install -y curl
EOF
```
Options can be any of the following-
- `--device` (1.14-labs >=)
- [[#`RUN --mount`]] (1.2 >=)
- `--network` (1.3 >=)
- `--security` (1.1.2-labs >=)
## Cache invalidation for RUN instructions
The cache for `RUN` instructions isn't invalidated automatically during the next build. The cache for an instruction like `RUN apt-get dist-upgrade -y` will be reused during the *next build*(when `docker build` is used again later). The cache for `RUN` instructions can be invalidated by using the `--no-cache` flag, for example `docker build --no-cache`.

See the [Dockerfile Best Practices guide](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) for more information.

The cache for `RUN` instructions can be invalidated by [`ADD`](https://docs.docker.com/reference/dockerfile/#add) and [`COPY`](https://docs.docker.com/reference/dockerfile/#copy) instructions.
## `RUN --device`
`RUN --device=name,[required]`
## `RUN --mount`
`RUN --mount=[type=<TYPE>][,option=<value>[,option=<value>]...]`
Supported mount types:

|[`bind`](https://docs.docker.com/reference/dockerfile/#run---mounttypebind) (default)|Bind-mount context directories (read-only).|
|[`cache`](https://docs.docker.com/reference/dockerfile/#run---mounttypecache)|Mount a temporary directory to cache directories for compilers and package managers.|
|[`tmpfs`](https://docs.docker.com/reference/dockerfile/#run---mounttypetmpfs)|Mount a `tmpfs` in the build container.|
|[`secret`](https://docs.docker.com/reference/dockerfile/#run---mounttypesecret)|Allow the build container to access secure files such as private keys without baking them into the image or build cache.|
|[`ssh`](https://docs.docker.com/reference/dockerfile/#run---mounttypessh)|Allow the build container to access SSH keys via SSH agents, with support for passphrases.|

Contents of the cache directories persists between builder invocations without invalidating the instruction cache. Cache mounts should only be used for better performance. Your build should work with any contents of the cache directory as another build may overwrite the files or GC may clean it if more storage space is needed.
- In certain instructions, *environment variables* (declared with the `ENV` statement) will be interpreted as variables.
> Note:
> There's some information on **variable substitution** in this section. You can just look it up when you need to. 
