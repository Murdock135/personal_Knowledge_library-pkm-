REPO: https://github.com/ddangelov/Top2Vec
# Introduction
- Proposed method: Contextual Top2Vec. An evolution of Top2Vec
- Segments a document into topic spans
- Produces per topic relevance score.
- Topics are labelled with phrases (previous methods used ranked list of words)
- Evaluation method: BERTScore (Zhang et a. 2020)
## Contextual Token Embeddings
- Contextual embeddings have different vectors depending on *context*.
- How to create contextual embeddings:
	1. Use embedding model to create token embeddings for each document. (Take away the embeddings before letting them go through pooling layer.)
		- The embedding model must produce *contextual tokens*, uses average pooling and was trained for semantic similarity.
	2. 
