# Lambda Calculus Implementation

- entry point `lc`
- parser global state
- utility functions
- parser
    - parse body
    - parse expression
- ast rendering
- reductions
    - substitute
    - normal reductions

## External Interface

The `lc` function is the entry point for the lambda calculus interpreter, and the only external point of contact for the interpreter. It accepts a `str` containing a lambda calculus expression, and returns a `str` with that expression in beta-normal form.

## The Parser

The parser has two pieces of global state:

- `src` - the input string to the parser;
- `i`   - an integer index into `src` marking the next character to be consumed.


