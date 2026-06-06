Source: https://arxiv.org/pdf/2604.14228v1
- Just one `while loop`
- The authors identify **five *human values*** and **thirteen design principles** that motivate the architecture. 
	- Human decision authority
	- Safety, security, and privacy
	- Reliable Execution
	- Capability amplification
	- Contextual adaptability
- The paper contributions:
	1. Design-space analysis (where reasoning happens, how the loop is made, what safety conditions, extension surface)
	2. Architectural contrast with OpenClaw
	3. Open Directions for future agent systems

# Important note about what the system does not do
**It does not impose explicit planning graphs on the model’s reasoning**, does not provide a single unified extension mechanism, and does not restore all session-scoped trust-related state across resumes.

# Design principles
![[Pasted image 20260526212446.png]]
# Design questions and running example
5 distinct context-reduction strategies:
1. budget reductions target individual tool outputs
2. Snip handles temporal depth
3. Microcompact reacts to cache overhead
4. Context collapse manages very long historie
5. Autocompact performs semantic compression as a last resort.