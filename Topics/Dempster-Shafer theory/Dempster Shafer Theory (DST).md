# Introduction

The **Dempster-Shafer Theory (DST)**, also known as the theory of belief functions, is a mathematical framework for reasoning with uncertainty. It was first introduced by [Arthur P. Dempster](https://en.wikipedia.org/wiki/Arthur_P._Dempster) in the context of [statistical inference](https://en.wikipedia.org/wiki/Statistical_inference), and later expanded into a general framework by [Glenn Shafer](https://en.wikipedia.org/wiki/Glenn_Shafer). DST belongs to the broader class of *monotone (non-additive) measure theories*. While older works referred to it as *fuzzy measure theory*, this is a misnomer, as DST is not inherently fuzzy【15†source】.

DST generalizes classical probability theory. Instead of assigning probabilities strictly to atomic events, DST assigns *degrees of belief* to sets of possibilities, making it particularly useful when information is incomplete or imprecise. If sufficient evidence allows, DST reduces to classical probability【16†source】.

DST stands alongside other frameworks for uncertainty modeling, such as **imprecise probabilities** (Walley, Fine, Kuznetsov) and **possibility theory** (Zadeh, Dubois, Prade, Yager).

---

# Motivation

DST was developed to overcome limitations of classical probability theory【17†source】:  

1. In probability theory, assigning a probability to an event automatically assigns a probability to its complement. DST relaxes this requirement.  
2. When insufficient evidence exists to support a specific probability distribution, probability theory defaults to uniformity. DST allows for ignorance to be explicitly represented instead of forced uniform assumptions.  
3. DST allows reasoning about probabilities of **sets of events**, even if probabilities of individual elements are unknown.  

The central object is the **belief function**, which aggregates evidence from different sources and represents the degree of belief in various hypotheses.

---

## Basic Probability Assignment (BPA)

The **Basic Probability Assignment (BPA)** is the primitive function in DST, defined as:  

$$
\begin{matrix}
m:\mathcal{P}(X) \rightarrow[0,1] \\
m(\phi)=0
\end{matrix}
$$

where $\mathcal{P}(X)$ is the power set of a frame of discernment $X$. The BPA quantifies the **amount of evidence** supporting that an element of $X$ belongs to a set $A$, but not to any strict subset of $A$【13†source】.  

Key properties:  
- **Domain**: $\mathcal{P}(X)$ (the power set of $X$)  
- **Codomain**: $[0,1]$  
- **Normalization**:  
  $$
  \sum_{A \in \mathcal{P}(X)} m(A) = 1
  $$

---

# Belief and Plausibility

From the BPA, two important measures are derived: **Belief (bel)** and **Plausibility (pl)**.  

## Belief

The **belief function** represents the total support for a set $A$:  

$$
bel(A) = \sum_{B \subseteq A} m(B)
$$

This quantifies the minimal degree of belief that can be committed to $A$【16†source】.

## Plausibility

The **plausibility function** represents the extent to which $A$ cannot be ruled out. Let  

$$
\omega=\{ s: s \cap A \neq \Phi \}
$$

Then  

$$
pl(A) = \sum_{B \in \omega} m(B)
$$

Algorithmically:  

```python
def plausibility(A, mass_function):
    """
    A: set - the target subset of Omega
    mass_function: dict - keys are frozensets B ⊆ Omega with m(B) > 0
    returns: float - plausibility of A
    """
    pl = 0.0
    for B, m in mass_function.items():
        if A & B:  # B ∩ A ≠ ∅
            pl += m
    return pl

# Example usage
mass_function = {
    frozenset({'a'}): 0.3,
    frozenset({'a', 'b'}): 0.4,
    frozenset({'b', 'c'}): 0.3,
}

A = {'b'}
print(plausibility(A, mass_function))  # Output: 0.7
```

then `plausibility(A, mass_function)` returns **0.7**【16†source】.

## Relation between Belief and Plausibility

Belief and plausibility form lower and upper bounds of uncertainty intervals:  

1. $$m(A) = \sum_{B \subseteq A} (-1)^{|A-B|} bel(B)$$  
2. $$pl(A) = 1 - bel(\bar{A})$$【18†source】  

where $\bar{A}$ is the **classical component** of $A$, defined as:  

$$
\bar{A} := \bigcup_{\substack{B \subseteq A \\ m(B) > 0}} B
$$

## Theoretical Relations

The relations among BPA, belief, and plausibility are central:  

- BPA ($m$) provides the atomic assignment of mass.  
- Belief ($bel$) is the cumulative support of subsets.  
- Plausibility ($pl$) is the measure of compatibility, i.e., how much cannot be excluded.  

Thus, the triplet $(m, bel, pl)$ forms the backbone of DST, encapsulating both committed belief and epistemic uncertainty.  

# Types of Evidence

DST categorizes evidence into structural types【19†source】:  

1. **Consonant evidence**: Nested subsets, where smaller subsets are contained within larger ones.  
2. **Consistent evidence**: At least one element is common across all subsets.  
3. **Arbitrary evidence**: No universally common element across subsets.  
4. **Disjoint evidence**: Subsets share no common elements (totally disjoint).  

# Rules for Combining Evidence
Combination rules fall under *information aggregation methods*. In DST, it is assumed that the sources of information are *independent (TODO: DEFINE THIS).* 
The rules reflect a continuum between conjunction (AND) and disjunction (OR) (Dubois and Prade, 1992). The primary categories are the following:
1. Conjunctive pooling
2. Disjunctive pooling
3. Tradeoff
There are multiple operators under each category. The tradeoff combination assumes less information than what is assumed in a Bayesian approach (The meaning of this will be clearer with practice problems). This leads to results being less *precise* (again, the meaning will surface with practice problems).
Below is a brief discussion of the operators aka rules. The rules will be discussed *relative to* four algebraic properties (idk what this means):
- Commutativity: $A*B=B*A$ 
- Idempotence: $A*A=A$
- Continuity: $A*B=A'*B$ where $A \approx A'$
- Associativity: $A*(B*C)=(A*B)*C$
where \* denotes the operation.
## Dempster's rule
Dempster's rule assumes 2 things:
1. The belief functions to be combined are from the same *frame of discernment*.
2. The information sources are independent.
The combination operator is
$$
m_{12}(A) = \frac{ \sum_{B \cap C = A} m_1 (B) m_2 (C)}{1-K}
$$
When $A \neq \phi$ .
where 
$$
K = \sum_{B \cap C=\phi} m_1(B) m_2(C)
$$
$K$ corresponds to the mass associated with conflict. 
Some characteristics about this rule:
- This rule ignores conflicting evidence and amplifies agreement between sources; basically an AND operation. The denominator achieves this.
- The rule is *commutative and associative* and *not* *idempotent and continuous*
## Discount + Combine
This rule first discounts sources based on their *reliability* and then combines using any combination operator. Therefore, the first task on the user's part is to mathematically quantify or express *reliability*. Shafer demonstrated a very simple example by scaling belief functions with an expression; $1-\alpha_i$ where $\alpha_i \in [0,1]$ and i indicates the index of a *discounting function* associated with a particular belief measure. For example, $Bel^{\alpha_i}(A)$ represents the discounted belief function, 
$$
Bel^{a_i}(A) = (1-\alpha_i)Bel(A)
$$
This notation achieves 2 things
1. Indicate which belief function is being discounted (so can we have multiple discounting functions for one belief function?)
2. Indicate the amount of *untrust* ($\alpha$) (so can we have multple values for one belief function?)
Then the final Belief is obtained by using a combination operator. For example, averaging:
$$
\bar{Bel(A)} = \frac{1}{n} (Bel^{a_1} + Bel^{a_2} + ... + Bel^{a_n})
$$
for all subsets A of the universal set X.
# Notes
- Besides the degree of conflict, the *relevance* of conflict also matters.
