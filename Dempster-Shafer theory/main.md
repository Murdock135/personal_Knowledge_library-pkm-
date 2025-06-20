Dempster shafer theory can be interpreted as a generalization of probability theory. Here, probabilities are assigned to *sets* rather than singletons. 

# Belief and Plausibility
## Belief
The belief $bel(A)$ for a set A is the sum of all the masses of subsets of the set of interest.
$$ 
bel(A)=\sum_{B|B \subseteq A} m(A)
$$
Where $m$ is the [[BPA]] (Basic Probability Assignment) function.
## Plausibility
Let $\omega$ be a set of subsets of $\Omega$ wherein every subset has at least one element in common with a set of interest $A$, i.e.
$$
\omega=\{ s: s \cap A \neq \Phi \}
$$
Then the plausibility of A is 
$$
pl(A)=\sum m(\omega)
$$
