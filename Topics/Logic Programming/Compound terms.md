# 🔷 1. What a Compound Term _Really_ Is

A **compound term** is a _tree_.

Example:

```prolog
point(3,4)
```

Diagram:

```
       point
       /   \
      3     4
```

Another example:

```prolog
edge(node(a), node(b))
```

Diagram:

```
           edge
          /    \
       node     node
        |        |
        a        b
```

Anything shaped like a **functor + arguments** is a compound term.

---

# 🔷 2. Structure of a Compound Term

General form:

```
f(t1, t2, ..., tn)
```

Internally it is:

```
    f
   /|\
 t1 t2 ... tn
```

Where each `ti` can be:

- an atom
    
- a number
    
- a variable
    
- another compound term
    

So compound terms can nest indefinitely.

---

# 🔷 3. Why They Matter: Compound Terms = Structured Data

### ✔ For representing relationships

```prolog
parent(john, mary).
```

### ✔ For representing objects

```prolog
car(toyota, camry, 2020)
```

### ✔ For representing record-like structures

```prolog
student(name(john, doe), id(123), major(cs))
```

Diagram:

```
                student
    /               |                \
 name(...)          id(...)         major(cs)
   /    \             |
 john   doe          123
```

---

# 🔷 4. Compound Terms and Unification (the superpower)

Unification is the pattern-matching engine of Prolog.

Given:

```prolog
X = point(3, 4).
```

The variable `X` becomes the whole structure.

### Matching substructure

```prolog
point(X, 4) = point(3, 4).
```

Unification result:

- `X = 3`
    

Diagram:

```
point(X, 4)       point(3, 4)
     | \               | \
     ?  4              3  4
```

The two trees match, so Prolog fills in the missing piece.

---

# 🔷 5. When Unification Fails

```prolog
point(3,4) = point(3,5).   % ❌ fails
```

Because:

- arguments don’t match
    

```prolog
edge(X, Y) = node(a).      % ❌ fails
```

Because:

- functor name differs (`edge` vs `node`)
    
- arity differs (2 vs 1)
    

Unification only works when **functor name + arity match**, then arguments unify pairwise.

---

# 🔷 6. Lists are Compound Terms Too (secret representation)

Prolog list:

```prolog
[a, b, c]
```

Is _actually_:

```prolog
.(a, .(b, .(c, [])))
```

Diagram:

```
     .
    / \
   a   .
      / \
     b   .
        / \
       c   []
```

So list syntax is just a **convenient wrapper** around compound terms!

---

# 🔷 7. Compound Terms in Rules

```prolog
distance(point(X1, Y1), point(X2, Y2), D) :-
    DX is X2 - X1,
    DY is Y2 - Y1,
    D is sqrt(DX*DX + DY*DY).
```

The rule head:

```
distance(point(X1,Y1), point(X2,Y2), D)
```

is one big compound term with subterms inside it.

Diagram overview:

```
                       distance
        /                   |                \
   point(X1,Y1)        point(X2,Y2)           D
      /     \            /      \
    X1      Y1         X2        Y2
```

---

# 🔷 8. Intuition Summary

A **compound term is:**

- a tree
    
- a structured object
    
- a pattern that Prolog can match
    
- the backbone of facts, rules, and data structures
    
- the internal representation for lists and many other constructs
    

It’s the **core data structure** in logic programming.

---

If you'd like, I can also show:

✅ how to _build your own_ compound terms  
✅ how Prolog stores them internally (heap cells)  
✅ how compound terms interact with backtracking  
✅ how to pattern-match deeply nested structures

Just tell me which direction you want to go!