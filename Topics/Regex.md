- Regular expressions can be concatenated to form new regular expressions; if _A_ and _B_ are both regular expressions, then _AB_ is also a regular expression. In general, if a string _p_ matches _A_ and another string _q_ matches _B_, the string _pq_ will match AB
- Regular expression patterns are compiled into a series of bytecodes which are then executed by a matching engine written in C
- 
# References
1. https://docs.python.org/3/howto/regex.html#regex-howto