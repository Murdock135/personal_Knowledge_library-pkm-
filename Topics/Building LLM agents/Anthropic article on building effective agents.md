These are my notes on [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)

---
- Use API directly instead of frameworks like langchain or crewai.
- Distinguish between **workflow** and **agents**-
	- Workflow: LLMs and tools are instructed to use *predefined* code paths.
	- Agents: LLMs act independently.
- Design patterns
	- Augmented LLM (Building block): LLM with retrieval, tools and memory.
	- Prompt chaining (Workflow): Decomposing a task into a sequence of steps
	- Routing (Workflow): Classifying an input and directing to specialized processors (LLM/tool/subroutine)
	- Parallelization (Workflow)
	- Orchestrator-workers
	- Evaluator-optimizer
- When using the Augmented LLM, use a well-documented interface (idk what this means) e.g. [MCP](https://modelcontextprotocol.io/docs/develop/build-client#building-mcp-clients)
- 

# Appendix
## Figures
### Prompt Chaining
![[Pasted image 20251029140028.png]]

### Routing
![[Pasted image 20251029135936.png]]

### Parallelization
![[Pasted image 20251029140009.png]]

### Orchestrator-workers
![[Pasted image 20251029140103.png]]

### Evaluator-optimizer
![[Pasted image 20251029140124.png]]

