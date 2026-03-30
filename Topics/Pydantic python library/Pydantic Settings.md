# Prerequisites
1. Object oriented programming
	1. Classes
	2. Constructors
	3. Basic use cases
2. Environment variables
3. Configuration files e.g. TOML files
4. [Python Fields](https://peps.python.org/pep-0557/#field-objects) (originally intended to be used with dataclasses)
5. Dataclasses (optional)
	1. Decorators 
6. [Pydantic basics](https://docs.pydantic.dev/latest/concepts/models/#basic-model-usage) (what is a model and how to use)
7. [Pydantic field](https://docs.pydantic.dev/latest/concepts/fields/#field-aliases).

# Intro: Pydantic uses ideas from `dataclasses`
This is a module implemented by pydantic's authors that provides features that make it easy to configure applications e.g. environment variable loading, configuration file loading, etc. Before going into the module, it important to note that this library uses python's 'notion' of `dataclasses` and `Field`s. A dataclass is decorator for class (wrapper for a class) which basically **implements a feature that automatically creates 'special functions' (`init(), __repr__(), etc.)` for a class.** A `Field` is just a name for a type-annotated attribute (agh, more abstraction). Developers usually take advantage of the automatic creation of `init()` only. This makes it possible to use python classes as structs (a datatype used in c). 
> [!info] `Field` vs `field()` vs `pydantic.Field()`
> In python, there's the `Field` object and the `field()` function. The `field()` function is the one that's used while `Field` is never used (almost). `field()` simply creates a Field object (why do this when we could've just used `Field()` right? Don't ask me. Ask the Python authors.)
> And then there's `pydantic.Field()`, which is used to create fields for 'pydantic models'.


For example,
```python
from dataclasses import dataclass

@dataclass
class InventoryItem:
    """Class for keeping track of an item in inventory."""
    name: str
    unit_price: float
    quantity_on_hand: int = 0
```
This will automatically create the following `__init__()`
```python
def __init__(self, name: str, unit_price: float, quantity_on_hand: int = 0):
    self.name = name
    self.unit_price = unit_price
    self.quantity_on_hand = quantity_on_hand
```
# `BaseSettings`
This is the main object that is used in this library. This object is subclassed so that the features can be used, which just enables the **class to fill its attributes from environment variables** by simply searching for an environment variable that has a matching name. The other thing that differentiates `BaseSettings` from `BaseModel` is the *default values* of base settings is validated by default ('Default values validated by default'. Quite a tongue twister eh).

Example:
Say, you have the following `.env` file,
```
AUTH_KEY=AUTH123
API_KEY=API123
DEBUG=True
```
And you have the following python code
```python
from pydantic_settings import BaseSettings
from pydantic import Field

class Settings(BaseSettings):
	auth_key: str
	api_key: str
	debug: bool = False
	
settings = Settings()
```
Your application will see and use the variable `debug` as `debug=True`. Notice that **the variable names are case-insensitive**.
## Customizing behavior
It is possible to customize the behavior of the `BaseSettings` object via a function called `SettingsConfigDict()`. For example, turning on or off the validation of default values, specifying a prefix to look for in the environment variable This is helpful when you use a single prefix that specifies some aspect of your program in your environment variable names e.g. `MYAPP_AUTH_KEY`. 
For example,
```
MYAPP_AUTH_KEY=AUTH123
MYAPP_API_KEY=API123
DEBUG=True
```
and you have the following python code
```python
from pydantic_settings import BaseSettings
from pydantic import Field

class Settings(BaseSettings):
	model_config = SettingsConfigDict(env_prefix='myapp') # Btw, you HAVE TO use the variable name 'model_config'. Otherwise, it won't work. What a bother!

	auth_key: str
	api_key: str
	debug: bool = False
	
settings = Settings()
```
Then your application will
- Use `auth_key=AUTH123`
- Use `api_key=API123`
- *NOT* use `debug=True`
## What else can you customize?
Now, the documentation is very lazily written when it comes to this. I had to search and find out where they listed all the possible customizations. It's here https://docs.pydantic.dev/latest/api/pydantic_settings/#pydantic_settings.BaseSettings. They say 'All the below attributes can be set via `model_config.` But what is this `model_config`? is it it a variable, an object? Read [[Model Configuration]] to find out (it's ill-framed design by the authors in my opinion).

> [!info] Case sensitivity on Windows