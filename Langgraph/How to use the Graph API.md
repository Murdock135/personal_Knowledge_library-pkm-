This guide demonstrates the basics of LangGraph's Graph API. It walks through [state](https://langchain-ai.github.io/langgraph/how-tos/graph-api/#define-and-update-state), as well as composing common graph structures such as [sequences](https://langchain-ai.github.io/langgraph/how-tos/graph-api/#create-a-sequence-of-steps), [branches](https://langchain-ai.github.io/langgraph/how-tos/graph-api/#create-branches), and [loops](https://langchain-ai.github.io/langgraph/how-tos/graph-api/#create-and-control-loops). It also covers LangGraph's control features, including the [Send API](https://langchain-ai.github.io/langgraph/how-tos/graph-api/#map-reduce-and-the-send-api) for map-reduce workflows and the [Command API](https://langchain-ai.github.io/langgraph/how-tos/graph-api/#combine-control-flow-and-state-updates-with-command) for combining state updates with "hops" across nodes.
```bash
pip install -qU langgraph
```
# Building a graph
```python
from langgraph.graph import StateGraph

# 'graph_init' = 'graph initializer'
graph_init = StateGraph(State)
graph_init.add_node(node)
graph_init.set_entry_point("node")
graph = graph_init.compile()
```
# Visualizing a graph
```python
from IPython.display import Image, display

display(Image(graph.get_graph().draw_mermaid_png()))
```
output:
![[Pasted image 20250520134914.png]]
# Executing/Invoking a graph
```python
from langchain_core.messages import HumanMessage

result = graph.invoke({"messages": [HumanMessage("Hi")]})
result
```
output:
```
{'messages': [HumanMessage(content='Hi', additional_kwargs={}, response_metadata={}),
  AIMessage(content='Hello!', additional_kwargs={}, response_metadata={})],
 'extra_field': 10}
```
Iterate over the result messages:
```python
for message in result["messages"]:
    message.pretty_print()
```

```
================================ Human Message =================================

Hi
================================== Ai Message ==================================

Hello!
```
