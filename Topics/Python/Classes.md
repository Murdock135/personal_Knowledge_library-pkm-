
These are my non-beginner friendly notes on classes. These notes are simply to fill the gaps in my own understanding. The notes are taken from https://docs.python.org/3/tutorial/classes.html

---
Firstly, In C++ jargon, the following 2 things need to be kept in mind about python classes-
- Normally class members are public.
- All member functions are *virtual*. 

## Explanation of "A Word About Names and Objects"

This section explains a fundamental aspect of Python's design: how variables relate to objects in memory.

**Understanding "Objects have individuality, and multiple names can be bound to the same object"**

In Python, when you create an object, it exists once in memory with a unique identity. Variables are merely names that reference these objects. Multiple variables can reference the same object:

```python
a = [1, 2, 3]  # Create one list object
b = a          # 'b' references the same object as 'a'

print(id(a))   # 140234567890123 (example)
print(id(b))   # 140234567890123 (identical - same object)
```

This is aliasing: `a` and `b` are different names for the same object.

---

**Why aliasing "can be safely ignored when dealing with immutable basic types"**

For immutable types (numbers, strings, tuples), you cannot modify the object itself. When you appear to change the value, you're actually rebinding the name to a new object:

```python
x = 5
y = x  # y references the same integer object

y = 10  # Creates new integer object; rebinds y to it
print(x)  # 5 (unchanged)
```

Since you cannot modify immutables, aliasing produces no observable effects. Beginners can ignore this concept when working with these types.

---

**Why aliasing has "a possibly surprising effect" with mutable objects**

With mutable objects (lists, dictionaries), modifications through one alias affect what all aliases see:

```python
a = [1, 2, 3]
b = a  # b is an alias for the same list

b.append(4)  # Modify through 'b'
print(a)     # [1, 2, 3, 4] - 'a' reflects the change
```

This surprises newcomers who expect `b = a` to create an independent copy.

---

**How "aliases behave like pointers" benefits programs**

The author states this design is beneficial. First, "passing an object is cheap since only a pointer is passed":

```python
huge_list = [1, 2, 3] * 1000000  # 1 million elements

def process(lst):
    # 'lst' is just a reference to huge_list
    # No copying of 1 million elements occurred
    pass

process(huge_list)  # Fast and memory-efficient
```

Second, "if a function modifies an object passed as an argument, the caller will see the change":

```python
def modify(lst):
    lst.append(99)  # Modifies the object

my_list = [1, 2, 3]
modify(my_list)     # Passes reference to my_list
print(my_list)      # [1, 2, 3, 99] - modification visible to caller
```

---

**What "eliminates the need for two different argument passing mechanisms as in Pascal" means**

Pascal requires explicit syntax to distinguish between:

- Pass-by-value (copies the data)
- Pass-by-reference (allows modification via `var` parameters)

Python achieves both behaviors with a single mechanism: always pass references to objects, but let mutability determine the observable outcome.

```python
# Immutable → appears like pass-by-value:
def change_number(n):
    n = 999  # Rebinds local name; doesn't affect caller

x = 5
change_number(x)
print(x)  # 5 (unchanged)

# Mutable → appears like pass-by-reference:
def change_list(lst):
    lst.append(999)  # Modifies object; caller sees change

y = [5]
change_list(y)
print(y)  # [5, 999] (changed)
```

---

**Important distinction: rebinding versus mutation**

Assignment (`=`) rebinds the name to a different object; it does not modify the original object:

```python
def rebind(lst):
    lst = [999]  # Rebinds LOCAL 'lst' to new object
                 # Original object unchanged

my_list = [1, 2, 3]
rebind(my_list)
print(my_list)  # [1, 2, 3] (unchanged)
```

To modify the object and make changes visible to the caller, use mutation operations:

```python
def mutate(lst):
    lst.append(999)  # Modifies the object itself

my_list = [1, 2, 3]
mutate(my_list)
print(my_list)  # [1, 2, 3, 999] (changed)
```

---

**Summary**

Python always passes references to objects. With immutable objects, this is invisible because you cannot modify them. With mutable objects, modifications through one reference are visible through all references. This single mechanism provides the benefits of both pass-by-value and pass-by-reference without requiring different syntax.

# Python scopes and Namespaces

### Namespaces
Namespaces are created at different moments and have different lifetimes. The namespace containing the built-in names is created when the Python interpreter starts up, and is never deleted. The global namespace for a module is created when the module definition is read in; normally, module namespaces also last until the interpreter quits. The statements executed by the top-level invocation of the interpreter, either read from a script file or interactively, are considered part of a module called [`__main__`](https://docs.python.org/3/library/__main__.html#module-__main__ "__main__: The environment where top-level code is run. Covers command-line interfaces, import-time behavior, and ``__name__ == '__main__'``."), so they have their own global namespace. (The built-in names actually also live in a module; this is called [`builtins`](https://docs.python.org/3/library/builtins.html#module-builtins "builtins: The module that provides the built-in namespace.").)

The local namespace for a function is created when the function is called, and deleted when the function returns or raises an exception that is not handled within the function. (Actually, forgetting would be a better way to describe what actually happens.) Of course, recursive invocations each have their own local namespace.

### Scope
A _scope_ is a textual region of a Python program where a namespace is directly accessible. “Directly accessible” here means that an unqualified reference to a name attempts to find the name in the namespace.