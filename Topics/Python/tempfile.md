This module creates temporary files and directories. It works on all platforms.
# `tempfile.TemporaryFile()`
signature:
```python
tempfile.TemporaryFile(
	mode='w+b',
	buffering=1,
	encoding=None,
	newline=None,
	suffix=None,
	prefix=None,
	dir=None,
	*,
	errors=None
	)
```
Returns a file-like object that can be used as a temporary storage area. File will be destroyed as soon as it is closed. Under Unix, the directory entry for the file is either not created at all or is removed immediately after the file is created. Other platforms do not support this; your code should not rely on a temporary file created using this function having or not having a visible name in the file system.