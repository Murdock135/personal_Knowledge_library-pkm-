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

## Conclusion

Dempster-Shafer Theory provides a powerful alternative to classical probability for reasoning under uncertainty. By distinguishing between belief, plausibility, and ignorance, DST allows for nuanced treatment of incomplete information and supports evidence fusion from multiple sources.  

It is widely applied in **sensor fusion, decision theory, information retrieval, and artificial intelligence**, where classical probability models may fail to capture epistemic uncertainty.

