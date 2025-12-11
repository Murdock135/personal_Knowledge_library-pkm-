Main Ref: https://tomassetti.me/antlr-mega-tutorial/#chapter17
- Rules are typically written in the following order
	1. Parser rules
	2. Lexer rules
- Rules are applied in the opposite order.
- The typical example is the identifier: in many programming languages it can be any string of letters, but certain combinations, such as “class” or “function” are forbidden because they indicate a _class_ or a _function_. So the order of the rules solves the ambiguity by using the first match and that’s why the tokens identifying keywords such as _class_ or _function_ are defined first, while the one for the identifier is put last.