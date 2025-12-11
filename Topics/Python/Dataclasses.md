# @dataclass.dataclass()
This function is a decorator that is used to generate *special methods*. It attempts to find 'fields', which is a class variable that simply has a type annotation. 
```python
@dataclass
class C:
    a: int       # 'a' has no default value
    b: int = 0   # assign a default value for 'b'
```
In the above example the fields are `a` and `b`.  The above code is equivalent to,
```python
class C:
	def __init__(self, a: int, b: int = 0):
		...
```
Fields can also be defined by using `dataclasses.field()` function. Read the comment
```python
@dataclass
class C:
	# mylist will be instantiated as an empty list every time an object of type C is instantiated
    mylist: list[int] = field(default_factory=list)
```

This is equivalent to 
```python
class C:
	def __init__(self):
		self.mylist: list[int] = []
```

## Difference between using `field()` and not using it:
`field` forces the instance variable to have an initial value (empty in the above case) 