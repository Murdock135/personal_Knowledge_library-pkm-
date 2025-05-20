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
# Nodes
- Nodes are functions (sync or async) with two arguments:
	- `state`
	-  `config`
- Behind the scenes, nodes are converted into *runnable lambdas*, which add **batch and async support**. 
# Edges
Note: There's nothing special about edges so there's no notes. However, I took notes on **Conditional Edges** below
## Conditional edge
The following call signature is used- 
```python
graph.add_conditional_edges("node_a", routing_function) # routing_function should return the name of a node
```
- A dictionary can be used to delineate when there are multiple possible *next* nodes.
```python
graph.add_conditional_edges("node_a", routing_function, {output_b: "node_b", output_c : "node_c"})
```
**Tip: Use [`Command`](https://langchain-ai.github.io/langgraph/concepts/low_level/#command) instead of conditional edges if you want to combine state updates and routing in a single function.**
# Send
![[Screenshot from 2025-05-19 21-12-02.png]]
We can use the `Send(recieving_node, state_object)` method to send *different versions*(not different states) of a `state` object to the receiving node. 
# Command
This is used to explicitly define the update of the state and where to send the update to, unlike a *node*, where the update is decided by the runnable lambda and the node to send to is not defined and instead, the preset edge direction is used for that.
```python
def my_node(state: State) -> Command[Literal["my_other_node"]]:
    return Command(
        # state update
        update={"foo": "bar"},
        # control flow
        goto="my_other_node"
    )
```
**Note**: When returning `Command` in your node functions, you must add return type annotations with the list of node names the node is routing to, e.g. `Command[Literal["my_other_node"]]`. This is necessary for the graph rendering and tells LangGraph that `my_node` can navigate to `my_other_node`.
# Where to go next
Read [How to use the graph API](https://langchain-ai.github.io/langgraph/how-tos/graph-api/). I will make notes on it soon.
