
- Start with your idea of 'the best model'. That way you know the upper limits of what the system is capable of. Then, swap out for a smaller model. Some pointers
- OpenAI's general recommendation is to max out a single agent's capabilities first. "*More agents can provide intuitive separation of concepts, but can introduce additional complexity and overhead,   so often a single agent with tools is sufficient.*"
- Muti-agent system architectures
	- Manager (agents as tools)
	- Decentralized (agents handing off to agents)
- Declarative vs Non-declarative graphs
	- Agents SDK adopts a more flexible, code-first approach. Developers can   directly express workflow logic using familiar programming constructs **without needing to pre-define the entire graph** upfront, enabling more dynamic and adaptable agent orchestration.
