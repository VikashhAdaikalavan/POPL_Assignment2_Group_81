---
name: prolog-dev
description: Write, test and review SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 puzzle, P2 equations). Use for any Prolog predicate, test or review request in this repository.
---

# prolog-dev

## 1. Language and environment
- SWI-Prolog 9.x. Files are loaded with `swipl -q -f id_q1.pl -g main -t halt`.
- Other goals: `swipl -q -f id_q2.pl -g "<goal>" -t halt`.
- Allowed libraries only: `lists`, `apply`, `yall`, `aggregate`. No other `use_module`.
- Forbidden: `assert*`, `retract*`, `b_setval`, `nb_setval`, `initialization/1,2`, calling `halt/0`.
- Never print anything except what the task specifies (no debug output, no prompts).
- Files contain only definitions. Nothing runs at load time.

## 2. Scope of work (decomposition rule)
- One request = one unit: one predicate, one test file, or one review.
- If asked for a whole problem at once, refuse and propose the list of units first.
- Each unit is answered with: code, a 2-3 line explanation, and 2-3 test queries with expected output.

## 3. Coding conventions
- Names: `snake_case` predicates and `Capitalised` variables. Descriptive names (`apply_op`, `count_solutions`).
- Do not redefine built-ins (`op/3`, `append/3`, `member/2`, `sum/3`). Pick a different name.
- Mode comment above every predicate, e.g. `% apply_op(+Op, +A, +B, -V)`.
- Declarative reading above every non-trivial predicate: one sentence "X holds when ...".
- Recursive predicates: base case first, then recursive case, both clearly labelled.
- One clause per clue/rule where the task requires it (e.g. `clue(N, Solution)`).
- No singleton variables: use `_` or `_Name`. Load with no warnings.
- Prefer pure relations. Use cuts only if justified in a comment, and never to hide a wrong clause.
- Use `->` / `;` only with parentheses and with an explicit else branch.
- Data representation follows the task exactly: quoted atoms (`'Alex'`, `'c++'`, `'AI'`), SWI strings (not atoms/codes) where the task says "string".

## 4. How to run and test
- Load: `swipl -q -f code/id_q2.pl -g "<goal>" -t halt`.
- Check warnings: `swipl -q -f code/id_q2.pl -g true -t halt` must print nothing.
- Every predicate gets tests in `tests/`: the examples from the assignment, plus edge cases (empty list, one element, no solution, duplicates, negative intermediate values, inexact division, division by zero).
- Failure cases are tested with `\+ goal`, not by eye.
- Compare counts and sorted lists with the assignment's examples before moving on.

## 5. Self-review checklist (apply before every answer)
1. Does it load with zero warnings (singletons, discontiguous, redefined built-ins)?
2. Only allowed libraries, no assert/retract/globals/initialization/halt?
3. Does it print nothing unless the task says so?
4. Are all outputs in the exact required type and format (strings vs atoms, quoting, order, no spaces)?
5. Does it fail cleanly (no error, no infinite loop) on empty, single-element and impossible inputs?
6. Is arithmetic correct: `is` used for evaluation, `=:=` for comparison, `//` and `mod` for exact integer division?
7. Are results free of duplicates when required, and sorted with `sort/2` when required?
8. Is every variable bound before it reaches `is`, `\+` or a comparison?
9. Do the assignment's examples pass word for word?
10. Is the answer exactly one unit of work, with mode comments and a declarative reading?

## 6. Known AI failure modes for Prolog
- Redefining a built-in (`op/2`, `append/3`) or clashing with library names.
- Using `assert` or `nb_setval` "just to collect results" instead of `findall/3`.
- Adding `:- initialization(main).` or a call to `halt.` in the file.
- Mixing atoms, strings and code lists (`"abc"` is a string in SWI-Prolog 9; `format(atom(X), ...)` gives an atom).
- Forgetting to quote atoms that need it (`c++`, `AI`, `Alex`).
- Using `/` when integer division is needed, or `=` where `is` / `=:=` is needed.
- `\+` or `\=` on unbound variables, which gives wrong answers by floundering.
- Left recursion or unbound `append/3` splits that loop forever on backtracking.
- Wrong precedence or parenthesisation when printing expressions.
- Producing duplicates through different derivations, then forgetting `sort/2`.
- Stray `print`, `write` or `format` calls left over from debugging.
- Unnecessary cuts that make the predicate non-relational or drop solutions.
- Inventing library predicates that do not exist in SWI-Prolog 9.x (check with `?- apropos(Name).`).
- Claiming tests pass without running them.