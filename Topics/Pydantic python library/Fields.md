# `pydantic.Field()`
This is used to create fields for a[ pydantic model](https://docs.pydantic.dev/latest/concepts/models/) (basically a struct, if you're familiar with C) and is analogous to python's native `field()` function. 
```python
from pydantic import BaseModel, Field


class Model(BaseModel):
    name: str = Field()
    
m1 = Model() # This will throw an error that name is missing
m2 = Model(name='foo') # Correct

# Print correct model's name field
print(m2.name)
```