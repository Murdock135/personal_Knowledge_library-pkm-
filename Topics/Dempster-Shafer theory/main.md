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
