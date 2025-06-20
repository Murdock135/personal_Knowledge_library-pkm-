**Definition**: Let $X$ be a non-empty set. A set of subsets of X, $\tau$ is said to be a topology *on X* if 
1. X and the empty set $\emptyset$ belong to $\tau$.
2. The union of any (finite or infinite) number of sets in $\tau$ belongs to $\tau$ 
3. The intersection of any two sets in $\tau$ belong to $\tau$ 
# A more mathematical definition: 
Let $X$ be a non-empty set. A collection $\mathcal{T} \subseteq \mathcal{P}(X)$ is a **topology** on $X$ if:

4. $\varnothing \in \mathcal{T}$ and $X \in \mathcal{T}$,
5. For any indexed family $\{U_\alpha\}_{\alpha \in A} \subseteq \mathcal{T}$, we have  
   $$
   \bigcup_{\alpha \in A} U_\alpha \in \mathcal{T},
   $$
6. For any $U, V \in \mathcal{T}$,  
   $$
   U \cap V \in \mathcal{T}.
   $$

Then the pair $(X, \mathcal{T})$ is called a **topological space**.

**Where:**

- $\mathcal{P}(X)$ denotes the power set of $X$ (the set of all subsets of $X$),
- $A$ is an arbitrary index set (possibly infinite),
- $\{U_\alpha\}_{\alpha \in A}$ is a family of sets in $\mathcal{T}$.



