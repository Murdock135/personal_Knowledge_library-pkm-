The following are for the agentic system built for health science, directly related to 400_projects/420_professional_projects/what_causes_salmonella
- How to evaluate the system
	- Create a dataset like that in [AgentRewardBench](https://arxiv.org/pdf/2504.08942)
	- We then let the system run again such that it follows the expert annotations. Then we use semantic similarity or some other measure to check how different the initial generation is (from the regeneration)
	- We can then use RLHF to make the system more like an epidemiologist.
	- What if we use Alvey's protoforms and then use Dempster Shafer Theory to study assumptions (read below)
- Ask the system to produce a list of possible assumptions, rank ordered. We should probe the system to obtain a quantified 'amount' of belief in those assumptions.
---
The following is inspired by Dr. Anderson's idea of using Dempster Shafer theory to find evidence from multiple sources.
- We can let multiple LLMs respond to the same query and use DST to combine.