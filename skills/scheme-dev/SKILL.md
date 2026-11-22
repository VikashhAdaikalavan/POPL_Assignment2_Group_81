---
name: scheme-dev
description: Write, test and review Racket 8.x (#lang racket/base) Scheme code under a restricted built-in set for CS F301 Assignment 2 (S1 tree traversals, S2 nested-list insert). Use for any Scheme function, test or review request in this repository.
---

# scheme-dev

## 1. Language and environment
- Racket 8.x. Every file starts with `#lang racket/base`.
- Run with `racket code/id_q3.rkt` and `racket code/id_q4.rkt`. The grader appends its own calls to the end of the file.
- Files contain only definitions. No top-level calls and no output when the file is loaded.
- S2 reads from standard input using `read` inside `print-insert-result`. It prints no prompt and no extra text.

## 2. Allowed built-ins (and nothing else)
- Forms: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (written `'`).
- Lists: `cons`, `car`, `cdr`, `list`, all `c[ad]{2,4}r` compositions (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, ...), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
- Numbers: `+ - * < > <= >= =`, `max`.
- Output: `display`, `newline`. `read` only in S2.
- Forbidden: `set!` and relatives, vectors, hash tables, strings, loops (`do`, `for`), `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`, `apply`, `foldl`, `list?`, `null`, `else` outside `cond`, and anything not listed above.
- Need a forbidden function? Write your own helper (`my-length`, `my-map`, `my-reverse`, `my-append`).

## 3. Scope of work (decomposition rule)
- One request = one unit: one function, one test file, or one review.
- If asked for a whole problem at once, refuse and propose the list of units first.
- Each unit is answered with: code, a 2-3 line explanation, and 2-3 test calls with expected output.

## 4. Coding conventions
- Names: lowercase with hyphens (`print-inorder`, `my-length`), predicates end in `?`.
- Comment above every function: purpose, argument types, return type, and a recursive reading ("the result for a tree is ... of its subtrees").
- Pass all state through arguments (accumulators). No mutation.
- Prefer tail recursion with an accumulator where it is natural. Use named `let` for local loops.
- Helpers are defined at top level or with `letrec`. Each helper does one thing.
- Trees are `()` or `(value left right)`. Do not use `list?` or dotted pairs.
- Output uses only `display` and `newline`. Every printing function ends with a newline.

## 5. How to run and test
- Tests live in `tests/`, one file per problem. A test file is the solution file's contents plus calls at the end (the way the grader does it), or a separate file that includes the definitions.
- Run `racket tests/<file>.rkt` and compare the output with the expected lines.
- Cover the assignment's examples (`t1`, `t2`, `t3`, the empty tree, the S2 examples) and edge cases: empty list, `n = 0`, single node, deep nesting (depth 100), 10,000-element lists.
- Stdin tests: `echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket tests/s2.rkt`.

## 6. Self-review checklist (apply before every answer)
1. Starts with `#lang racket/base` and runs with no errors or output when loaded?
2. Only allowed built-ins used? Scan every identifier against section 2.
3. No `set!`, no vectors, no strings, no loops?
4. All state passed through arguments, no mutation?
5. Base cases correct for `()` and single-element inputs?
6. Does the output format match exactly (parentheses, spaces, one line per list, trailing newline)?
7. Is recursion safe for depth 100 and 10,000 elements (tail-recursive or at most one non-tail call per level)?
8. Is length measured on the original list, before insertion (S2)?
9. Does every example from the assignment pass word for word?
10. Is the answer exactly one unit of work, with a comment and tests?

## 7. Known AI failure modes for Scheme
- Using `length`, `append`, `map`, `reverse`, `filter`, `member`, `list?`, `apply`, `foldl` out of habit.
- Using `set!`, `define` inside loops to mutate, or `for` / `do`.
- Using `let loop` with mutable state, or hash tables and vectors for "efficiency".
- Writing `(print x)` or `(write x)` instead of `display`.
- Printing extra text, prompts or a result with `~a` formatting, or forgetting the trailing `newline`.
- Calling the function at the top level to "demo" it, which breaks the grader.
- Forgetting `#lang racket/base`, or relying on `#lang racket` built-ins.
- Using `else` incorrectly, or `cond` without a final `else` that returns a wrong value.
- Treating `'()` and `()` inconsistently, or testing emptiness with `(= (length x) 0)`.
- Using `eq?` on numbers (use `=`) or `=` on symbols (use `eq?`).
- Computing the length of a list after inserting into it (S2).
- Non-tail recursion that overflows or is very slow on 10,000 elements, and quadratic `my-append` in loops.
- Confusing atoms with lists: `pair?` is true for non-empty lists, `null?` for `()`, anything else is an atom.
- Claiming tests pass without running them.