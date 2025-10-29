> Note: You need to tune this to your own understanding and needs later.

## 0) When to Actually Use an Agent

**Use an agent when you need:**

- Multi-step reasoning over tools/data (e.g., "analyze patient history → retrieve guidelines → synthesize recommendation")
- Dynamic decision-making based on intermediate results
- Tool selection that depends on context

**Don't use an agent when:**

- Single LLM call + retrieval suffices (90% of use cases)
- You need <1s response time
- The workflow is fixed (use a deterministic pipeline instead)

**Example for health DSS:** If you're just retrieving relevant guidelines and asking the LLM to summarize → **no agent needed**. If you need to iteratively query patient records, cross-reference drug interactions, check insurance coverage, then synthesize → **agent makes sense**.

---

## 1) Problem Definition (The 80/20 of Success)

**Start with a crisp problem statement:**

```
For: [user type]
Who needs: [specific task]
The system should: [measurable outcome]
Currently: [baseline/manual process performance]
Success means: [1-2 key metrics]
```

**Example (Health DSS):**

```
For: Emergency department physicians
Who needs: Quick assessment of stroke treatment eligibility
The system should: Determine tPA eligibility in <30 seconds
Currently: Manual checklist takes 3-5 minutes, 12% error rate
Success means: <5% error rate, <30s response time
```

**Critical: Define what "correct" means**

- Gold standard dataset (n≥100 cases with expert labels)
- Inter-rater agreement on your domain (if <80%, your problem isn't well-defined)
- Edge cases that matter vs. don't matter

---

## 2) Minimal Viable Architecture

```
your_app/
  main.py              # Entry point (CLI, API, or UI)
  
  config/
    settings.yaml      # Models, prompts, tools, thresholds
    secrets.env        # API keys (gitignored)
  
  agent/
    core.py            # Agent loop (keep this <200 lines)
    prompts.py         # All prompts in one place, versioned
    tools.py           # Tool definitions and implementations
  
  domain/
    patient.py         # Your domain models (Pydantic)
    guidelines.py      # Domain-specific logic
    validation.py      # Safety checks, constraints
  
  data/
    retrieval.py       # RAG setup if needed
    embeddings/        # Pre-computed vectors
    guidelines/        # Static reference data
  
  eval/
    test_cases.json    # Your gold standard dataset
    metrics.py         # Domain-specific metrics
    run_eval.py        # Batch evaluation script
  
  tests/
    test_tools.py      # Unit tests for deterministic parts
    test_safety.py     # Critical safety checks
```

**Key principle: Separate domain logic from agent logic**

- Domain code should work without LLMs (pure Python functions)
- Agent code orchestrates domain functions and LLM calls
- This lets you test domain logic independently

---

## 3) Practical Agent Implementation

### Simple agent loop (90% of use cases)

```python
from anthropic import Anthropic
from pydantic import BaseModel

class StrokeDSS:
    def __init__(self):
        self.client = Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))
        self.tools = self._define_tools()
    
    def assess_tpa_eligibility(self, patient_id: str) -> dict:
        """Main entry point - coordinates retrieval and reasoning"""
        
        # Initialize conversation
        messages = [{
            "role": "user",
            "content": f"Assess tPA eligibility for patient {patient_id}"
        }]
        
        # Agent loop (max 5 steps for safety)
        for step in range(5):
            response = self.client.messages.create(
                model="claude-sonnet-4-20250514",
                max_tokens=4000,
                tools=self.tools,
                messages=messages
            )
            
            # Check if we're done
            if response.stop_reason == "end_turn":
                # Extract final answer
                answer = self._extract_answer(response.content)
                return {
                    "eligible": answer["eligible"],
                    "reasoning": answer["reasoning"],
                    "contraindications": answer["contraindications"],
                    "steps": step + 1
                }
            
            # Execute tool calls
            if response.stop_reason == "tool_use":
                messages.append({"role": "assistant", "content": response.content})
                
                tool_results = []
                for tool_use in response.content:
                    if tool_use.type == "tool_use":
                        result = self._execute_tool(
                            tool_use.name, 
                            tool_use.input
                        )
                        tool_results.append({
                            "type": "tool_result",
                            "tool_use_id": tool_use.id,
                            "content": result
                        })
                
                messages.append({"role": "user", "content": tool_results})
        
        # Fallback if max steps exceeded
        return {
            "eligible": None,
            "reasoning": "Unable to determine - exceeded decision steps",
            "error": "timeout"
        }
    
    def _define_tools(self) -> list:
        """Define available tools for the agent"""
        return [
            {
                "name": "get_patient_vitals",
                "description": "Retrieve current vital signs and labs",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "patient_id": {"type": "string"}
                    },
                    "required": ["patient_id"]
                }
            },
            {
                "name": "get_medical_history",
                "description": "Retrieve relevant medical history",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "patient_id": {"type": "string"},
                        "lookback_days": {"type": "integer", "default": 90}
                    },
                    "required": ["patient_id"]
                }
            },
            {
                "name": "check_contraindications",
                "description": "Check against tPA contraindication guidelines",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "vitals": {"type": "object"},
                        "history": {"type": "object"}
                    },
                    "required": ["vitals", "history"]
                }
            }
        ]
    
    def _execute_tool(self, tool_name: str, inputs: dict) -> str:
        """Execute tool and return result"""
        try:
            if tool_name == "get_patient_vitals":
                return self._get_patient_vitals(inputs["patient_id"])
            elif tool_name == "get_medical_history":
                return self._get_medical_history(
                    inputs["patient_id"],
                    inputs.get("lookback_days", 90)
                )
            elif tool_name == "check_contraindications":
                return self._check_contraindications(
                    inputs["vitals"],
                    inputs["history"]
                )
            else:
                return f"Error: Unknown tool {tool_name}"
        except Exception as e:
            return f"Error executing {tool_name}: {str(e)}"
```

### Alternative: LangGraph for complex workflows

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated
import operator

class AgentState(TypedDict):
    patient_id: str
    vitals: dict
    history: dict
    contraindications: list
    decision: str
    messages: Annotated[list, operator.add]

def retrieve_vitals(state: AgentState) -> AgentState:
    """Node: Retrieve patient vitals"""
    vitals = database.get_vitals(state["patient_id"])
    return {"vitals": vitals}

def retrieve_history(state: AgentState) -> AgentState:
    """Node: Retrieve medical history"""
    history = database.get_history(state["patient_id"])
    return {"history": history}

def check_contraindications(state: AgentState) -> AgentState:
    """Node: Apply clinical guidelines"""
    contraindications = []
    
    # Deterministic checks (no LLM needed)
    if state["vitals"]["systolic_bp"] > 185:
        contraindications.append("BP too high")
    if state["history"].get("recent_surgery"):
        contraindications.append("Recent surgery")
    
    return {"contraindications": contraindications}

def make_decision(state: AgentState) -> AgentState:
    """Node: LLM synthesizes final decision"""
    prompt = f"""
    Patient vitals: {state['vitals']}
    Medical history: {state['history']}
    Contraindications found: {state['contraindications']}
    
    Based on AHA/ASA guidelines, is this patient eligible for tPA?
    Provide: eligible (yes/no), reasoning, and confidence (0-1).
    """
    
    response = llm.generate(prompt)
    return {"decision": response}

# Build graph
workflow = StateGraph(AgentState)

workflow.add_node("get_vitals", retrieve_vitals)
workflow.add_node("get_history", retrieve_history)
workflow.add_node("check_contraindications", check_contraindications)
workflow.add_node("decide", make_decision)

workflow.set_entry_point("get_vitals")
workflow.add_edge("get_vitals", "get_history")
workflow.add_edge("get_history", "check_contraindications")
workflow.add_edge("check_contraindications", "decide")
workflow.add_edge("decide", END)

app = workflow.compile()

# Use it
result = app.invoke({"patient_id": "12345"})
```

**When to use LangGraph:**

- Fixed workflow with conditional branches
- Need to visualize/debug execution flow
- Multiple specialized agents coordinating
- Workflow needs approval gates or human-in-the-loop

**When to use simple loop:**

- Flexible reasoning path
- <5 tool calls typically
- Rapid prototyping phase

---

## 4) The Critical Parts: Prompts & Tools

### Prompt engineering for reliability

```python
SYSTEM_PROMPT = """You are a clinical decision support assistant for stroke assessment.

CRITICAL CONSTRAINTS:
- NEVER recommend treatment; only assess eligibility per guidelines
- If any absolute contraindication exists, patient is NOT eligible
- Always cite the specific guideline criterion
- Uncertainty requires human review

AVAILABLE TOOLS:
- get_patient_vitals: Current BP, glucose, platelets, etc.
- get_medical_history: Prior strokes, surgeries, medications
- check_contraindications: Apply AHA/ASA contraindication criteria

WORKFLOW:
1. Retrieve vitals and history
2. Check each contraindication systematically
3. Provide clear yes/no with reasoning

OUTPUT FORMAT (strict):
{
  "eligible": true/false,
  "confidence": 0.0-1.0,
  "reasoning": "...",
  "contraindications_found": [...],
  "requires_review": true/false
}
"""

# Prompt tips for healthcare:
# 1. Explicit constraints (never diagnose, never recommend)
# 2. Cite sources (which guideline criterion)
# 3. Confidence scoring for uncertainty handling
# 4. Structured output for downstream systems
```

### Tool design principles

```python
from pydantic import BaseModel, Field
from typing import Optional

class PatientVitals(BaseModel):
    """Strongly typed domain model"""
    systolic_bp: int = Field(..., ge=0, le=300, description="mmHg")
    diastolic_bp: int = Field(..., ge=0, le=200)
    heart_rate: int = Field(..., ge=0, le=300, description="bpm")
    glucose: int = Field(..., ge=0, le=1000, description="mg/dL")
    timestamp: str
    
    def is_within_tpa_window(self) -> bool:
        """Deterministic checks don't need LLM"""
        return (
            self.systolic_bp <= 185 and
            self.diastolic_bp <= 110
        )

def get_patient_vitals(patient_id: str) -> str:
    """
    Tool implementation pattern:
    1. Validate input
    2. Execute (with timeout/retry)
    3. Validate output
    4. Return serialized result
    """
    try:
        # Database call
        vitals_raw = database.query(
            f"SELECT * FROM vitals WHERE patient_id = '{patient_id}' "
            f"ORDER BY timestamp DESC LIMIT 1",
            timeout=5.0
        )
        
        # Parse and validate
        vitals = PatientVitals(**vitals_raw)
        
        # Return as formatted string for LLM
        return f"""
        Latest vitals for patient {patient_id}:
        - Blood pressure: {vitals.systolic_bp}/{vitals.diastolic_bp} mmHg
        - Heart rate: {vitals.heart_rate} bpm
        - Glucose: {vitals.glucose} mg/dL
        - Recorded: {vitals.timestamp}
        
        Within tPA BP criteria: {vitals.is_within_tpa_window()}
        """
    
    except TimeoutError:
        return "Error: Database timeout retrieving vitals"
    except ValidationError as e:
        return f"Error: Invalid vitals data - {e}"
    except Exception as e:
        logger.error(f"Vitals retrieval failed: {e}")
        return "Error: Unable to retrieve vitals"
```

**Tool design checklist:**

- ✓ Timeouts on all I/O operations
- ✓ Input validation (Pydantic schemas)
- ✓ Output validation (typed returns)
- ✓ Graceful error messages (LLM-readable)
- ✓ Deterministic where possible (push logic into tools, not prompts)

---

## 5) Evaluation for Applied Systems

### Start with small, high-quality test set

```python
# test_cases.json (n=50 to start, grow to 200+)
[
  {
    "case_id": "001",
    "patient_id": "PT123",
    "description": "Baseline eligible case",
    "expected": {
      "eligible": true,
      "must_mention": ["BP within limits", "no contraindications"]
    }
  },
  {
    "case_id": "002",
    "patient_id": "PT124",
    "description": "High BP contraindication",
    "expected": {
      "eligible": false,
      "must_mention": ["systolic BP", "185"]
    }
  },
  // ... critical edge cases
]
```

### Simple evaluation harness

```python
def evaluate_system(test_cases: list) -> dict:
    """Run all test cases and compute metrics"""
    results = []
    
    for case in test_cases:
        result = system.assess_tpa_eligibility(case["patient_id"])
        
        # Check correctness
        correct = (result["eligible"] == case["expected"]["eligible"])
        
        # Check reasoning quality
        mentions_all = all(
            phrase.lower() in result["reasoning"].lower()
            for phrase in case["expected"]["must_mention"]
        )
        
        results.append({
            "case_id": case["case_id"],
            "correct": correct,
            "reasoning_complete": mentions_all,
            "latency": result.get("latency_ms"),
            "tool_calls": result.get("steps"),
            "output": result
        })
    
    # Compute aggregate metrics
    return {
        "accuracy": sum(r["correct"] for r in results) / len(results),
        "reasoning_quality": sum(r["reasoning_complete"] for r in results) / len(results),
        "avg_latency_ms": sum(r["latency"] for r in results) / len(results),
        "avg_tool_calls": sum(r["tool_calls"] for r in results) / len(results),
        "failures": [r for r in results if not r["correct"]]
    }
```

### Domain-specific metrics (healthcare example)

```python
def clinical_metrics(results: list, test_cases: list) -> dict:
    """Metrics that matter for your domain"""
    
    # Confusion matrix
    tp = sum(1 for r, c in zip(results, test_cases) 
             if r["eligible"] and c["expected"]["eligible"])
    fp = sum(1 for r, c in zip(results, test_cases)
             if r["eligible"] and not c["expected"]["eligible"])
    tn = sum(1 for r, c in zip(results, test_cases)
             if not r["eligible"] and not c["expected"]["eligible"])
    fn = sum(1 for r, c in zip(results, test_cases)
             if not r["eligible"] and c["expected"]["eligible"])
    
    # Clinical decision metrics
    sensitivity = tp / (tp + fn) if (tp + fn) > 0 else 0
    specificity = tn / (tn + fp) if (tn + fp) > 0 else 0
    ppv = tp / (tp + fp) if (tp + fp) > 0 else 0
    npv = tn / (tn + fn) if (tn + fn) > 0 else 0
    
    return {
        "sensitivity": sensitivity,  # How many true positives caught
        "specificity": specificity,  # How many true negatives caught
        "ppv": ppv,                  # Positive predictive value
        "npv": npv,                  # Negative predictive value
        "false_positive_rate": fp / (fp + tn) if (fp + tn) > 0 else 0,
        "false_negative_rate": fn / (fn + tp) if (fn + tp) > 0 else 0
    }
```

**Critical for healthcare/high-stakes:**

- False negatives vs. false positives have different costs (prioritize accordingly)
- Test edge cases exhaustively (5% of cases cause 50% of errors)
- Include adversarial cases (edge of criteria, ambiguous wording)
- Human expert review on random sample (n=20 weekly)

---

## 6) Safety & Validation (Non-Negotiable for Healthcare)

### Multi-layer validation

```python
class SafetyValidator:
    """Catches unsafe outputs before they reach users"""
    
    def validate_response(self, response: dict, patient_data: dict) -> tuple[bool, str]:
        """Returns (is_safe, reason)"""
        
        # 1. Schema validation
        required_fields = ["eligible", "reasoning", "contraindications"]
        if not all(field in response for field in required_fields):
            return False, "Missing required fields"
        
        # 2. Logical consistency
        if response["eligible"] and len(response["contraindications"]) > 0:
            return False, "Logic error: eligible despite contraindications"
        
        # 3. Completeness check
        if len(response["reasoning"]) < 50:
            return False, "Reasoning too brief"
        
        # 4. Inappropriate content
        forbidden_phrases = ["definitely", "guaranteed", "you should", "I recommend"]
        if any(phrase in response["reasoning"].lower() for phrase in forbidden_phrases):
            return False, "Inappropriate medical advice language"
        
        # 5. Data consistency
        if "BP" in response["reasoning"]:
            vitals = patient_data.get("vitals", {})
            bp_mentioned = f"{vitals['systolic_bp']}/{vitals['diastolic_bp']}"
            if bp_mentioned not in response["reasoning"]:
                return False, "BP values don't match"
        
        return True, "OK"

# Use it
response = agent.assess_patient(patient_id)
is_safe, reason = validator.validate_response(response, patient_data)

if not is_safe:
    logger.error(f"Unsafe response: {reason}")
    return {
        "eligible": None,
        "error": "System validation failed - requires manual review",
        "requires_review": True
    }
```

### Monitoring in production

```python
class ProductionMonitor:
    """Track system behavior over time"""
    
    def __init__(self):
        self.metrics = defaultdict(list)
    
    def log_decision(self, patient_id: str, response: dict, metadata: dict):
        """Log every decision for audit"""
        
        record = {
            "timestamp": datetime.now().isoformat(),
            "patient_id": patient_id,
            "eligible": response["eligible"],
            "tool_calls": metadata["steps"],
            "latency_ms": metadata["latency"],
            "model": metadata["model"],
            "prompt_version": metadata["prompt_version"]
        }
        
        # Write to audit log
        audit_log.append(record)
        
        # Track metrics
        self.metrics["latency"].append(metadata["latency"])
        self.metrics["tool_calls"].append(metadata["steps"])
        
        # Alert on anomalies
        if metadata["latency"] > 30000:  # 30 second threshold
            alert.send("High latency detected", details=record)
        
        if metadata["steps"] > 10:
            alert.send("Excessive tool calls", details=record)
    
    def daily_summary(self) -> dict:
        """Aggregate metrics for review"""
        return {
            "total_assessments": len(self.metrics["latency"]),
            "p50_latency": percentile(self.metrics["latency"], 50),
            "p95_latency": percentile(self.metrics["latency"], 95),
            "avg_tool_calls": mean(self.metrics["tool_calls"]),
            "eligible_rate": sum(m["eligible"] for m in audit_log) / len(audit_log)
        }
```

---

## 7) Iteration Workflow (What Actually Happens)

### Week-by-week roadmap

**Week 1: Baseline without agent**

```python
def baseline_system(patient_id: str) -> dict:
    """Simplest possible approach"""
    vitals = get_vitals(patient_id)
    history = get_history(patient_id)
    
    prompt = f"""
    Patient vitals: {vitals}
    Medical history: {history}
    
    Is this patient eligible for tPA per AHA/ASA guidelines?
    """
    
    response = llm.generate(prompt)
    return parse_response(response)

# Evaluate baseline
baseline_results = evaluate_system(test_cases, baseline_system)
# Result: 75% accuracy, 2s latency, $0.02/query
```

**Week 2: Add retrieval if needed**

```python
def rag_system(patient_id: str) -> dict:
    vitals = get_vitals(patient_id)
    history = get_history(patient_id)
    
    # Retrieve relevant guidelines
    query = f"tPA eligibility criteria for stroke with BP {vitals['bp']}"
    guidelines = vector_db.search(query, k=3)
    
    prompt = f"""
    Patient: {vitals}, {history}
    Guidelines: {guidelines}
    
    Assess eligibility.
    """
    
    response = llm.generate(prompt)
    return parse_response(response)

# Evaluate
rag_results = evaluate_system(test_cases, rag_system)
# Result: 82% accuracy (+7%), 2.5s latency, $0.03/query
```

**Week 3: Add agent only if multi-step reasoning needed**

```python
# Analyze errors from RAG system
error_analysis = analyze_failures(rag_results)
# Finding: 12 of 18 errors needed multi-step reasoning
# - "Check BP, THEN check if on anticoagulants, THEN assess timing"
# Conclusion: Agent warranted

agent_results = evaluate_system(test_cases, agent_system)
# Result: 91% accuracy (+9%), 4.5s latency, $0.08/query
```

**Week 4: Optimize for production**

- Add caching for repeated vitals lookups (-20% latency)
- Switch to cheaper model for simple cases (-40% cost)
- Add validation layer (catches 3 more errors → 93% accuracy)

### Error analysis drives everything

```python
def analyze_failures(results: list, test_cases: list):
    """Understand WHY system failed"""
    failures = [
        (r, c) for r, c in zip(results, test_cases)
        if r["eligible"] != c["expected"]["eligible"]
    ]
    
    # Categorize errors
    categories = {
        "retrieval_miss": [],  # Needed data not retrieved
        "reasoning_error": [], # Had data, wrong conclusion
        "tool_failure": [],    # Tool returned error
        "ambiguous": []        # Unclear from trace
    }
    
    for result, case in failures:
        # Manual review or automated classification
        category = classify_error(result, case)
        categories[category].append((result, case))
    
    # Prioritize fixes
    print("Error breakdown:")
    for cat, cases in categories.items():
        print(f"{cat}: {len(cases)} cases")
        if cases:
            print(f"  Example: {cases[0][1]['description']}")
    
    return categories

# Example output:
# Error breakdown:
# retrieval_miss: 8 cases
#   Example: "Recent surgery not in last 90 days of history"
# reasoning_error: 6 cases  
#   Example: "Misinterpreted 'within 4.5 hours' criterion"
# tool_failure: 3 cases
#   Example: "Database timeout on complex patient"
# ambiguous: 1 case
```

**Fix priority:**

1. **Tool failures** (most urgent - breaks system)
2. **Retrieval misses** (add tool calls or adjust lookback windows)
3. **Reasoning errors** (improve prompts, add examples)
4. **Edge cases** (add to test suite, may accept lower accuracy)

---

## 8) Practical Heuristics (Applied Systems)

### Start stupidly simple

```
Day 1: Hard-coded rules (if-else logic)
  ↓ (works for 60% of cases, document failures)
Day 3: Single LLM call with prompt
  ↓ (works for 80%, still failures)
Day 7: Add retrieval (RAG)
  ↓ (works for 85%, multi-step failures remain)
Day 10: Add agent with 2-3 tools
  ↓ (works for 90%+)
```

### When to use what

|Need|Solution|Example|
|---|---|---|
|Lookup + summarize|RAG + single LLM|"What are guidelines for X?"|
|Multi-step with tools|Agent|"Check eligibility across 3 systems"|
|Fixed workflow|Deterministic pipeline|"Always do A→B→C"|
|Uncertain workflow|Agent|"Do A, decide next based on result"|
|<1s response|Cache + simple model|Real-time dashboards|
|Creative/open-ended|No agent|"Write a report"|

### Cost management (practical)

```python
# Typical costs per query
COSTS = {
    "no_agent": {
        "llm": 0.01,      # Single call
        "retrieval": 0.001,
        "total": 0.011
    },
    "agent": {
        "llm": 0.05,      # 3-5 calls average
        "retrieval": 0.003,
        "tools": 0.01,    # Database queries
        "total": 0.063
    }
}

# Budget constraints
MAX_COST_PER_PATIENT = 0.10
DAILY_BUDGET = 100.00  # Support ~1500 agent queries/day

# Monitor and route
def smart_route(query_complexity: float):
    if query_complexity < 0.3:
        return no_agent_path  # 70% of queries
    else:
        return agent_path     # 30% of queries
    
    # Effective cost: 0.7 * 0.011 + 0.3 * 0.063 = $0.026/query
    # vs. pure agent: $0.063/query (58% savings)
```

### Prompt versioning (simple but effective)

```python
# prompts.py
PROMPTS = {
    "v1_baseline": """
    Assess tPA eligibility for this patient.
    """,
    
    "v2_add_constraints": """
    Assess tPA eligibility per AHA/ASA guidelines.
    NEVER recommend treatment, only assess eligibility.
    """,
    
    "v3_add_examples": """
    Assess tPA eligibility per AHA/ASA guidelines.
    
    Example eligible case:
    - BP: 140/80, onset 2h ago, no contraindications → ELIGIBLE
    
    Example ineligible case:
    - BP: 190/105 → NOT ELIGIBLE (BP too high)
    
    NEVER recommend treatment, only assess eligibility.
    """
}

CURRENT_PROMPT = "v3_add_examples"  # Change here

# Track performance by version
results_by_version = {
    "v1": {"accuracy": 0.75, "date": "2025-01-15"},
    "v2": {"accuracy": 0.82, "date": "2025-01-22"},
    "v3": {"accuracy": 0.89, "date": "2025-01-29"}
}
```

### Testing without over-engineering

```python
# test_stroke_dss.py
import pytest

def test_baseline_eligible_case():
    """Known good case should work"""
    result = system.assess("PT123_baseline_eligible")
    assert result["eligible"] == True
    assert "no contraindications" in result["reasoning"].lower()

def test_high_bp_contraindication():
    """High BP should be caught"""
    result = system.assess("PT124_high_bp")
    assert result["eligible"] == False
    assert "blood pressure" in result["reasoning"].lower()

def test_tool_timeout_graceful():
    """System should handle database timeouts"""
    with mock.patch('database.get_vitals', side_effect=TimeoutError):
        result = system.assess("PT125")
        assert "error" in result
        assert result["requires_review"] == True

def test_malformed_patient_id():
    """Invalid input should be caught"""
    with pytest.raises(ValidationError):
        system.assess("invalid@@@id")

# Run weekly
@pytest.mark.slow
def test_full_regression_suite():
    """All 200 test cases must pass"""
    test_cases = load_test_cases()
    results = evaluate_system(test_cases)
    assert results["accuracy"] >= 0.90  # Don't ship if regression
```

---

## 9) Getting Started Checklist

**Before writing any code:**

- [ ] 50-100 test cases with expert labels
- [ ] Baseline system (simplest possible approach)
- [ ] 2-3 key metrics defined
- [ ] Failure analysis framework

**Week 1 deliverable:**

- [ ] Baseline working (may be just prompting)
- [ ] Evaluation harness running
- [ ] Error categorization started

**Week 2 deliverable:**

- [ ] Agent prototype (if needed based on errors)
- [ ] 2-3 tools implemented
- [ ] Safety validation layer

**Week 3 deliverable:**

- [ ] Production monitoring setup
- [ ] Cost tracking
- [ ] Human review process

**Production readiness:**

- [ ] Accuracy >90% on test set (or your threshold)
- [ ] p95 latency < requirement
- [ ] Cost per query < budget
- [ ] Safety validation passes
- [ ] Audit logging functional
- [ ] Error handling tested

---

## 10) Red Flags (Stop and Rethink)

🚩 **Agent success rate <80% after 2 weeks** → Problem may not be well-defined or tools inadequate

🚩 **Evaluation accuracy not improving with agent vs. baseline** → Agent is overkill, stick with simpler approach

🚩 **Average >7 tool calls per query** → Tools too granular or planning is poor

🚩 **p95 latency >10s** → Too many sequential steps, need parallelization or caching

🚩 **Human experts disagree with "correct" labels >20% of time** → Ground truth is ambiguous, may need probabilistic approach

🚩 **Cost >$0.50 per query** → Likely using expensive models unnecessarily

🚩 **More than 5 tools** → Over-engineering, consolidate or question if agent is right approach

---

**What would be most useful next?**

1. Concrete code template for your health DSS use case
2. Example test case structure for clinical scenarios
3. Evaluation metrics specific to medical decision support
4. Safety validation checklist for healthcare applications