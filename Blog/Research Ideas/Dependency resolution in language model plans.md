# Dependency resolution in language model plans

Created: 2026-11-05
Status: Research idea; experiments not started

## Motivation

While using SPARQ, I found that Sonnet 4.5 produced more reasonable dependency lists than Sonnet 5. This is an observation from my workflow, not yet a controlled comparison or an established general regression.

A model can generate sensible steps and valid structured output while connecting the steps incorrectly. General agent performance may not tell us how well a model handles this particular component of planning. Analytical workflows introduce a further requirement: understanding the supplied data context. The model needs to know what data exist, what the columns mean, and what information each operation requires before it can infer the dependencies.

The idea is to compare dependency-resolution accuracy across frontier and open-weight models, examine its association with performance on other tasks, and study how it varies with model scale and structured-data context. A descriptive empirical study is a valid initial scope. Explaining the internal mechanism or measuring execution consequences is an optional extension, not a prerequisite.

## Research questions

1. **Model comparison:** How accurately do the evaluated language models infer dependencies between steps in analytical workflows?
2. **Capability associations:** How is dependency accuracy associated with instruction following, tool calling, structured output, Q&A, reasoning, and structured-data understanding? Does a combination predict accuracy better than an individual measure?
3. **Scale:** How does dependency accuracy vary with model size within open-weight families? Does the association persist after accounting for other measured capabilities and family?
4. **Data context:** How do the availability, completeness, and representation of structured-data context affect dependency accuracy? Can models adapt their dependency graphs when the available inputs change?

These questions concern measured behavior and statistical associations. They do not assume that one capability controls dependency accuracy or that a larger/newer model will perform better.

## What dependency resolution means here

A plan is a graph whose nodes are steps and whose directed edges specify prerequisites. Distinguish:

- Selecting appropriate steps.
- Identifying the prerequisite relations between those steps.
- Encoding those relations using valid IDs and the required schema.
- Selecting/configuring tools and actually executing them.

Data prerequisites and temporal ordering are related but different. Retrieving case counts and retrieving population counts may be independent; calculating incidence requires both. The order in which steps are written does not automatically imply execution dependence.

Specify whether the dependency field should contain direct prerequisites or all ancestors. Different edge lists can express the same prerequisite ordering. Define executor information-access rules: can a step access the original supplied datasets, only outputs from declared prerequisites, or retrieve missing information itself? Correct dependencies depend on these rules.

## Model selection

Include a handful of proprietary frontier models and open-weight models. For scaling, select several sizes within each of multiple open-weight families rather than relying only on unrelated models. Match training generation and tuning variant where possible and document remaining differences.

Use proprietary models as performance references; do not infer undisclosed parameter counts. Distinguish total and active parameters for mixture-of-experts models. Treat inference/reasoning budget separately from parameter scale. Record exact model versions, provider, settings, prompts, date, and output interface.

## Core experiments

### 1. Dependency prediction with fixed steps

Give every model the same task, context, and step descriptions; ask it to supply the dependencies. This isolates edge prediction from variation in decomposition. Include chains, independent branches, forks, joins, and tasks with several input producers.

### 2. Joint step and dependency generation

Let models generate the full plan. This is closer to SPARQ use, but evaluating it requires accommodating multiple valid decompositions rather than matching one reference graph literally. Compare with the fixed-step condition to identify where errors enter.

### 3. Other capability measurements

Measure capabilities on separate tasks to avoid building the desired correlation into the scoring:

| Capability | Candidate measurement |
| --- | --- |
| Instruction following | Satisfaction of explicit constraints |
| Tool calling | Appropriate tool selection and correct arguments |
| Structured output | Schema compliance; semantic field accuracy reported separately |
| Q&A | Factual or domain-question accuracy |
| Reasoning | Logical/compositional problem-solving accuracy |
| Structured-data understanding | Table grain, column meanings, join keys, available inputs, and valid operations |

Prefer consistent measurements of the exact evaluated configurations. Published benchmark scores can be an initial screen, but versions, settings, and harness differences must be documented. Test individual associations before fitting a small, prespecified composite model. Validate prediction on held-out models/families if the model sample supports it.

### 4. Structured-data context

Use two distinct experiments:

**Change the representation while holding the underlying task/data fixed:** compare minimal descriptions, table schemas, schemas with column meanings and units, and explicit relationships/input-output requirements. Consider sample rows as a separate condition because they add information. An underspecified condition may not admit a unique answer; allow ambiguity or abstention where appropriate.

**Change what information is actually available:** construct matched variants where an input is already supplied, must be retrieved, or is unavailable. The valid dependency graph changes across these variants, so each needs its own reference constraints.

Example: county incidence may require case counts and population from separate sources. If a supplied table already contains both, separate retrieval steps may be unnecessary. A statewide population denominator cannot simply substitute for county population. The model must adapt to these distinctions.

Treat the data-understanding score and the context manipulation as different evidence: one supports cross-model association analysis; the other tests the effect of a specific supplied-context change under the experiment's conditions.

## Evaluation and analysis

- Report missing prerequisites and unnecessary ordering constraints separately, alongside edge precision/recall/F1 and whole-plan validity.
- Check invalid references, self-dependencies and cycles separately from semantic correctness. Valid JSON is not a valid dependency graph.
- Accommodate equivalent graphs through prerequisite reachability and permitted execution orders. Decide explicitly how redundant transitive edges are scored.
- Use independently reviewed reference constraints with documented annotation/adjudication rules. Do not rely exclusively on an LLM judge or on unreviewed model-generated ground truth.
- Repeat generations and report uncertainty. Preserve invalid responses and distinguish format/interface failures from dependency mistakes.
- Use paired task comparisons. Separate model-level capability correlations from task-level context effects.
- For model-level correlations, the number of models is the effective number of model observations; thousands of tasks do not provide thousands of independent models. Related versions and sizes share family characteristics.
- Account for family and scale where feasible, assess collinearity, limit the number of predictors, and address multiple exploratory comparisons. With only a handful of models, adjusted analyses will be exploratory.
- A remaining adjusted size association does not establish a causal effect of scale. A disappearing association does not establish mediation by the measured capabilities.

## Optional execution extension

To study consequences, keep the steps, tools, executor, inputs and scheduling policy fixed, and vary only the dependency graph. Compare reference graphs, model-generated graphs, and controlled missing/extra-edge variants. Measure task correctness, attempts to execute without required inputs, completion, and lost parallelism. This is additional scope if useful, not necessary for the initial model/correlation study.

## Related work and novelty checks

The contribution cannot simply be that models struggle with dependencies: prior work already evaluates this. The potential contribution is the combination of current-model comparison, separate capability measurements, within-family scaling, and controlled structured-data context experiments. Novelty remains unverified until the closest papers' full methods and experiments are reviewed.

- [TaskLAMA: Probing the Complex Task Understanding of Language Models](https://research.google/pubs/tasklama-probing-the-complex-task-understanding-of-language-models/): task decomposition into graphs with temporal dependencies; its abstract reports stronger step decomposition than pairwise temporal-dependency prediction. Temporal relations are not identical to every SPARQ data prerequisite. Abstract reviewed in this discussion; full experimental detail not established.
- [TaskBench: Benchmarking Large Language Models for Task Automation](https://arxiv.org/html/2311.18760v4): tool graphs, dependency-edge evaluation, and analysis discussing reasoning and instruction following. Introduction, dependency definitions, and evaluation/analysis sections inspected. These do not establish a validated causal decomposition or capability composite for dependency accuracy.
- [Tool-Aware Planning in Contact Center AI](https://arxiv.org/abs/2602.14955): analytical plans with explicit depends_on fields and comparisons across models. Abstract reviewed; full methods require inspection for overlap with the proposed study.
- [Agent Planning Benchmark](https://arxiv.org/abs/2606.04874): separates planning diagnostics from execution evaluation. Abstract reviewed; specific overlap remains to be checked.
- [OmniBench](https://omni-bench.github.io/): evaluates dependency identification among several agent capability dimensions. Author project page reviewed; defining dimensions does not prove independent underlying skills.
- [Let Me Speak Freely?](https://arxiv.org/abs/2408.02442) and [Structure Tax](https://arxiv.org/abs/2610.12056): format restrictions/schema design can affect reasoning in their tested settings. Abstracts reviewed. They do not establish why the two Sonnet models differed in SPARQ.
- [LLMCompiler](https://arxiv.org/abs/2312.04511): relevant planner/executor architecture for dependent and parallel function calls; not evidence that a particular model characteristic causes dependency accuracy.

## Paper framing

The introduction can begin with a concrete analytical workflow where reasonable steps are connected incorrectly, then distinguish step generation, dependency reasoning, and format compliance. Explain why data context changes prerequisite requirements. Position existing graph-planning evaluations before introducing the capability-association, scaling, and context questions.

Background should define graph semantics, executor access rules, capability measurements, structured-data context, and scale. Methods should contain task curation, reference annotation, model settings, scoring, and statistical analysis. Avoid presenting a proposed explanation or the motivating Sonnet observation as an established result.

Possible working title: **Dependency Resolution in LLM Plans: Capability Associations, Model Scale, and Structured-Data Context**.

## Starting point

A pilot can compare Sonnet 4.5 and Sonnet 5 plus several other models on fixed-step tasks, first with identical explicit context and then with controlled context variants. Use it to check reproducibility, reference-answer ambiguity, score variation and evaluation cost before choosing the larger study's size. No experiment or model ranking has been adopted as a result here.

## Source

Source chat: [Compare SPARQ model compatibility — this Codex chat](codex://threads/01a1ad57-ef58-7fb2-bda9-3f359dae813e)

Developed in the Codex discussion continuing [Best Planning Models](chatgpt-conversation://6aece1bf-7a9c-83ea-b7b0-6d5af264131f), 2026-11-05. The user proposed the model comparison, cross-capability correlations, scale analysis and structured-data context dimension. Experimental details and framing above are proposals. Earlier dummy figures contain invented data and provide no empirical evidence.
