
[`multiprocessing`](https://docs.python.org/3/library/multiprocessing.html#module-multiprocessing "multiprocessing: Process-based parallelism.") is a package that supports spawning processes using an API similar to the [`threading`](https://docs.python.org/3/library/threading.html#module-threading "threading: Thread-based parallelism.") module. The [`multiprocessing`](https://docs.python.org/3/library/multiprocessing.html#module-multiprocessing "multiprocessing: Process-based parallelism.") package offers both local and remote concurrency, effectively side-stepping the [Global Interpreter Lock](https://docs.python.org/3/glossary.html#term-global-interpreter-lock) by using subprocesses instead of threads. Due to this, the [`multiprocessing`](https://docs.python.org/3/library/multiprocessing.html#module-multiprocessing "multiprocessing: Process-based parallelism.") module allows the programmer to fully leverage multiple processors on a given machine. It runs on both POSIX and Windows.

# The `Process` class
## Starting a process (spawning)
[Processes](https://web.archive.org/web/20201004050736/http://pages.cs.wisc.edu/~remzi/OSTEP/cpu-intro.pdf) can be started by instantiating an object of type [`Process`](https://docs.python.org/3/library/multiprocessing.html#multiprocessing.Process) and then using the `start()` or `run()` method.
```python
from multiprocessing import Process

p = Process(target=print, args=[1]) # can use list of args
q = Process(target=print, args(1,)) # can use tuple of args
p.run() # invokes the callable (print())
1
q.run()
1
```
## Stopping a process (joining)
The way to 'stop' a process is by using the `join(timeout=None)` method with an optional `timeout` parameter
```python
timeout = 20 # 20s
p.join(20)
```

> [Note!]
> The naming of `join()` in Python's `multiprocessing` (and similarly in `threading`) comes from a **concurrency concept** in computer science — it's named after the idea of **"joining" threads or processes back together**.

