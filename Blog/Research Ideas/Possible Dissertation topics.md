1. A control model for token simulators.
	- This asks the question - "What do transformers produce in relation to the input?"
		- How does the training set's distribution impact the output?
		- How does the training set's encoding vectors impact the output?
	- Can we come up with stability conditions that prevent hallucination?
2. How much diversity in the training data does a transformer need before it can 'reason properly'?
3. Transformers are autoregressive models. Then why do conflicting predictions, for example, in mixture of experts, produce more satisfactory final predictions? And how different/similar are the particular predictions of each expert? How does the difference/similarity affect the final prediction? 
4. What makes transformers different from other autoregressive models? I ask this because training transformers on its own 'correct' answers improves its 'performance' (STaR training method), notwithstanding generalization, whereas other autoregressive 'overfit'. 
5. In beyondsemantics (2025), they train the model on execution traces. We don't know whether simply training on a constrained grammar lets the model understand the meaning of words in general. So the model doesn't even need to understand the semantics to make a good plan.