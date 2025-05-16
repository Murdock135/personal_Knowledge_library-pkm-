# Building a graph
- **State object**, which defines the object to be read in by a graph and the reducer function, which is used to tell the graph how to deal with new outputs/transformations.
- **Nodes (takes in the State as input)** and **Edges**: Define the language model in the node.
- `Stategraph` `(method)`: Takes the **State object** as the first input.
- `invoke/stream`: to invoke the language model.
# Memory
- `checkpointer and thread_id`: A `checkpointer` object (usually an object that can save a graph's state to a DB) uses a `thread_id` to inform an invocation of a graph's historical states.
- `compile(checkpointer=_checkpointer_object)`: use this to add a checkpointer object.
- `dict{"configurable":{"thread_id": <int>}}` is used to define the thread id.
Example:
```python
user_input = "Hi there! My name is Will."

# The config is the **second positional argument** to stream() or invoke()!
events = graph.stream(
    {"messages": [{"role": "user", "content": user_input}]},
    config,
    stream_mode="values",
)
for event in events:
    event["messages"][-1].pretty_print()
```
# StateGraph
- `langgraph.Graph.StateGraph` takes 4 arguments.
	- `state_schema`
	- `config_schema`
	- `input`
	- `output`
	Note: Neither the documentation, nor the docstring in the source mention the last two arguments. I don't know why.  
- The keys in the *State schema* are called *channels.*
# Handling messages
- The *State Schema* defines how to handle new messages.
![[Screenshot from 2025-05-16 15-17-10.png]]
- `langgraph.graph.message.add_message()` will deserialize messages into Langchain `Message` objects.
- There are two ways of defining messages. See the example below:
```python
# this is supported
{"messages": [HumanMessage(content="message")]}

# and this is also supported
{"messages": [{"type": "human", "content": "message"}]}

```
This relates to how the `add_messages()` function deserializes messages. Read more [here](https://python.langchain.com/docs/how_to/serialization/).
- `laggraph.graph.MessagesState` is a prebuilt object which already uses the `add_messages()` as its reducer. It is common to subclass this like so,
```python
from langgraph.graph import MessagesState

class State(MessagesState):
    documents: list[str]
```
