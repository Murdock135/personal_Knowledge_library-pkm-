---
title: A framework for human evaluation of large language models in healthcare derived from literature review
Subject:
  - artificial intelligence
  - language models
---
# Introduction
- “Awasthi et al.16 provided a review of key LLMs and key evaluation metrics and have proposed a human evaluation method with five factors, however, the method is not specifically designed for healthcare” (Tam et al., 2024, p. 2)
- Several reporting guidelines for use of AI in healthcare:
	- CLAIM (Checklist for AI in Medical Imaging)
	- STARD-AI (Standards for reporting Diagnostic accuracy studies-AI)
	- CONSORTAI (Consolidated Standards of Reporting Trials-AI)
	- MI-CLAIM (Minimum Information about Clinical Artificial Intelligence Modeling)
> **Deficiency**
> None of the above standards specifically address the reporting of human evaluation of LLMs in healthcare.
# Contributions
- Systematic review of existing literature on **human evaluation methods for LLMs in healthcare**
- Identify and analyze such studies within different medical domains, tasks, and specialties.
- Explore the **dimensions and variability** of human evaluation approaches employed for assessing LLMs in complex healthcare contexts.
- Propose best practices based on the literature
- Propose guidelines for developing an evaluation framework.
# Results
> Note:
> Only the interesting ones are being noted for.

- Tang et al. employed a t-test to counterbalance the correctness of medical evidence compiled by chatGPT against that of healthcare practitioners.
- Bernstein et al. enlisted the McNemar test to track down precision and dependability in diagnostic suggestions from LLMs and ophthalmologists.
- Hirosawa et al. carried out a comparison between LLM diagnoses and gold-standard doctor diagnoses, targeting differential diagnosis accuracy.
# Evaluation principles and dimensions: QUEST- five principles of evaluation dimensions
- Categorized the evaluation methods into 17 dimensions, under 5 principles
- The 5 principles
	- Quality of Information
	- Understanding and Reasoning
	- Expression Style
	- Personal, Safety and Harm
	- Trust and Confidence
# Evaluation samples
The section emphasizes that the **sample size and variability** of LLM outputs are critical for reliable human evaluation.

- **Sample size**: Most studies used ≤100 LLM outputs, constrained by evaluation complexity, number of dimensions, evaluator availability, and funding. A notable outlier was **Moramarco et al.**, who evaluated **2,995 sentences** using Amazon Mechanical Turk (MTurk). Due to annotator variability in literacy and language skills, they required a larger dataset, with each sentence evaluated by **seven different raters**.
    
- **Sample variability**: While many studies used generic patient-agnostic prompts (e.g., “why am I experiencing sudden blurred vision?”), some incorporated **patient-specific information** (from EHRs or clinical vignettes). This variability enabled testing across subpopulations (e.g., different symptoms, demographics, diagnoses), thereby enhancing generalizability of evaluation results.

👉 In short: The section highlights the **trade-off between scale and validity**, stressing that larger, more diverse samples improve robustness, but practical constraints often limit studies to small datasets.

# Selection and Recruitment of human evaluators
- In clinician facing tasks, evaluators should be clinicians.
- In patient facing tasks, evaluators should be both clinicians and misc.
“Generally, in studies with non-expert evaluation, we observe a decrease in the number of dimensions but an increase in the number of evaluators when comparing expert evaluation, showing a potential tradeoff between the depth and breadth of human evaluation.” (Tam et al., 2024, p. 6)
# Evaluation tools


---
# Critique
- The evaluation criteria is very general. Not specific enough such that one could quantify any of it. My alternate evaluation criteria
	- Accuracy
	- Brevity
	- Safety
	- Readability
	- Soundness
	- Honesty
- The evaluation method does not take into account the proficiency of the evaluator itself (not based on item response theory)
- The evaluation method does not take into account the variability of the text outputs themselves.