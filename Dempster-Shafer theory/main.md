Dempster shafer theory can be interpreted as a generalization of probability theory. Here, probabilities are assigned to *sets* rather than singletons. 

# Belief and Plausibility
## Belief
The belief $bel(A)$ for a set A is the sum of all the masses of subsets of the set of interest.
$$ 
bel(A)=\sum_{B|B \subseteq A} m(A)
$$
Where $m$ is the [[BPA]] (Basic Probability Assignment) function.
## Plausibility
Let $\omega$ be a set of subsets of $\Omega$ wherein every subset has at least one element in common with a subset of interest $A$, i.e.
$$
\omega=\{ s: s \cap A \neq \Phi \}
$$
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