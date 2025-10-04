# Introduction
Dempster shafer theory (DST) can be interpreted as a generalization of probability theory and deals with *evidence*, not chance (in the frequentist sense). Here, probabilities are assigned to *sets* rather than singletons. And if there is sufficient evidence so as to derive proabilities of single events, DST collapses into generic proability theory.
The probability assignment function is called the *Basic Probability Assignment or BPA* function. See [[BPA]].
From the BPA, the upper and lower bounds of an interval can be defined. These are respectively called *Plausibility* and *Belief*. Both of these measures are non-additive, meaning, the measures do not have to sum up to 1, unlike the probability assignment function.

# Belief and Plausibility
## Belief
The belief $bel(A)$ for a set A is the sum of all the masses of subsets of the set of interest.
$$ 
bel(A)=\sum_{B|B \subseteq A} m(B)
$$
Where $m$ is the [[BPA]] (Basic Probability Assignment) function.
## Plausibility
Let $\omega$ be a set of subsets of $\Omega$ wherein every subset has at least one element in common with a subset of interest $A$, i.e.
$$
\omega=\{ s: s \cap A \neq \Phi \}
$$
where $s \subset \Omega$ and $A \subset \Omega$
Then the plausibility of A is 
$$
pl(A)=\sum m(\omega)
$$
Algorithmically, this can be expressed as
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
![[Pasted image 20251002104723.png]]
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
