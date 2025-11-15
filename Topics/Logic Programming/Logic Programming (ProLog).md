Logic programming is a declarative programming paradigm based on formal logic. Programs consist of logical statements describing relationships and rules, rather than step-by-step instructions. The execution engine uses automated theorem proving to derive solutions from these logical specifications.

**Prolog** (Programming in Logic) is the most widely used logic programming language, developed in 1972. It represents knowledge as facts and rules using Horn clauses, and employs backward-chaining inference through a resolution-based proof procedure called SLD resolution.

## Core Concepts

**Facts** define basic relationships:

```prolog
% FACT: tom is the parent of bob
parent(tom, bob).
```

**Rules** specify logical implications:

```prolog
% RULE: X is the ancestor of Y IF X is the parent of Y
ancestor(X, Y) :- parent(X, Y).

% RULE: X is an acestor of Y IF X is a parent of some Z AND Z is the ancestor of Y
% This recursive rule defines the transitive nature of ancestry
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).
```

**Queries** trigger the inference engine:

```prolog
% Query: Is tom an ancestor of bob? % The ?- operator initiates a query to the Prolog interpreter % Prolog will attempt to prove this by searching through facts and rules
?- ancestor(tom, bob).
```

