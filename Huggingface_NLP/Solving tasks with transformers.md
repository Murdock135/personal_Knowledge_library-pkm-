- Two approaches to training transformers
	- Masked language modelling (MLM)- as in encoders (BERT)
	- Causal language modelling- as in decoders (GPT)

# Text generation
- **Output of decoder is passed to a 'language modelling head',** which performs a linear transformation to convert the hidden states to logits. The label is the next token in the sequence, which are created by shifting the logits to the right by one. The cross entropy loss is calculated between the shifting the logits and the labels to output the next most likely token. 
# Text classification
