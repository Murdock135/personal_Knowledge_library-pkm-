This will be problematic because it doesnt restrict aliasting. 
```c++
foo(int *x, int *y, int *z)
	...

int a[] = {1,2,3}
int b[] = {3, 2, 1}
int c[] = {3, 4, 1}

```
Here, all pointers point to `a`
Instead use,
```c++
foo(int* restrict x, int* restrict y, int* restrict z)
	...

// rest of the code
```
