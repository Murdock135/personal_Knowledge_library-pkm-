These are my notes on [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)

---
- Use API directly instead of frameworks like langchain or crewai.
- Agentic system patterns
	- Augmented LLM: LLM with retrieval, tools and memory.
- When using the Augmented LLM, use a well-documented interface (idk what this means) e.g. [MCP](https://modelcontextprotocol.io/docs/develop/build-client#building-mcp-clients)