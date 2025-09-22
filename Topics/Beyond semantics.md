My rebuttal:
The claim that semantically unrelated or incorrect intermediate traces can improve model performance—despite their lack of alignment with ground-truth reasoning procedures—is not surprising when viewed through the lens of first principles in deep learning. Transformers are fundamentally statistical sequence models; they do not execute reasoning procedures but rather learn to map input patterns to output patterns via optimization over large token spaces. What matters to the model is not the semantic correctness of intermediate tokens in the human or algorithmic sense, but their structural and statistical regularities.

From this perspective, any consistent token structure—such as well-formed but problem-irrelevant traces—can serve as a form of **inductive bias** that regularizes training, enhances gradient flow, or guides attention patterns in ways that improve generalization. That these benefits occur even when the traces are semantically disconnected from the problem instance is a natural consequence of the model exploiting superficial correlations in the training data to approximate a useful function.

Therefore, while the authors’ empirical control study is carefully constructed and does provide a formal falsification of a specific hypothesis—that trace correctness causally drives solution correctness—it largely reaffirms what should be expected: that LLMs extract utility from _form_, not _meaning_, and that human- or algorithm-aligned semantics are not required for intermediate representations to be useful.

This calls into question the broader field’s anthropomorphic framing of Chain-of-Thought reasoning as "internal computation" or "thinking," and highlights the need for theoretical clarity rather than empirical surprise. The result is valid but ultimately predictable, and its novelty is overstated.


---

### **Rebuttal (Semantic Internalism Argument):**

The paper claims that models trained on semantically incorrect traces (e.g., swapped A* traces) can still achieve high solution accuracy, and thus concludes that _trace correctness is loosely connected to solution correctness_. However, this inference presumes a **fixed external notion of correctness**, rooted in A* semantics or human-understandable logic.

This presumption fails to account for how **transformers acquire semantics internally** through the training process. Once a model is trained on a set of traces—even if those traces are _exogenous noise_ from the perspective of A*—they are no longer semantically meaningless to the model. Instead, the model **constructs its own latent representation** of those token sequences and integrates them into its predictive function.

Thus, the supposed “incorrect” or “unrelated” traces gain **semantic content relative to the model’s internal representation**. These traces are not truly semantically invalid in the model’s learned space $Hθ\mathcal{H}_\theta$, because the model's behavior is shaped by them. Semantics is **endogenous** to the trained system.

From this perspective, the conclusion that “trace accuracy is loosely connected to solution accuracy” is ill-posed. The _external_ trace accuracy (as defined by A*) is irrelevant once training begins; what matters is the **internal function** the model learns from the full input distribution. The model may find structure or utility in these traces that is not accessible to an external verifier.

### **Conclusion:**

What appears as a semantically invalid trace to an external observer may be **functionally valid** for the model. Therefore, the paper does not demonstrate that trace accuracy is loosely connected to solution accuracy — only that **external symbolic correctness is not required** for learning. In fact, through training, even "incorrect" traces become **internally semantically integrated** into the model’s computation, thereby invalidating the premise that they are “unrelated.”