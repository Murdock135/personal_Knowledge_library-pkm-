This note contains some things from https://developers.openai.com/tracks/building-agents/
# Function calling
This diagram illustrates the tool calling workflow in LLM agent systems, showing the interaction between a developer's implementation and an LLM model.
**Flow breakdown:**

1. **Initial Setup (Step 1)**: The developer provides the model with tool definitions (function schema for `get_weather(location)`) and the user's query ("What's the weather in Paris?").
    
2. **Tool Call Generation (Step 2)**: The model analyzes the query and responds with a structured tool call request: `get_weather("paris")`.
    
3. **Function Execution (Step 3)**: The developer's code executes the actual function with the specified parameter, which returns the result: `{"temperature": 14}`.
    
4. **Context Update (Step 4)**: The tool execution result is appended to the conversation history and sent back to the model for "Completion 1", maintaining the full message context.
    
5. **Final Response (Step 5)**: The model synthesizes the raw tool output into a natural language response: "It's currently 14°C in Paris."
    

**Key concept**: The model doesn't execute functions directly—it generates structured requests that the developer's code executes. The results are then fed back to the model for interpretation and natural language generation. This enables LLMs to interact with external systems and real-time data sources. [Building agents (OpenAI)](https://developers.openai.com/tracks/building-agents/)
![[Pasted image 20251031172016.png]]