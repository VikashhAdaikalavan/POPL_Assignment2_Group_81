# P1 Report: Department Assignment Puzzle

## 1. Number of solutions for clues 1 to 8

Running the following query:

```prolog
count_solutions([1,2,3,4,5,6,7,8], N).
```

gives **N = 3**.

This means that the first eight clues allow three possible solutions. The result was obtained using `count_solutions/2` in `code/81_q1.pl`, which checks all 13,824 possible assignments and keeps only the valid ones.

## 2. What the result tells us

The three possible solutions are:

| | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| **S1** | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| **S2** | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| **S3** | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

Some assignments remain the same in all three solutions:

- Ben is always in development, uses JavaScript and works on web.
- The person in research always uses C++ and works on data.
- Java is always associated with design, while Python is associated with testing.

However, the assignment of AI and embedded projects between the design and testing departments is not fixed.

## 3. Why S2 can be selected without using names

If we ignore the friends' names, S1 and S3 have exactly the same combinations of department, language and project. They differ only in which friend is assigned to each combination.

Since P1.c does not allow names to be used in the additional clue, we cannot distinguish between S1 and S3 using such a clue.

S2 is different because the person working in testing and using Python is assigned the AI project, while the person working in design and using Java is assigned the embedded project. Therefore, a clue based on these attributes can select S2.

## 4. Adding clue 9

The following clue was added:

> The friend who prefers the AI project works in the testing department.

This clue is satisfied only by S2. In S1 and S3, the person assigned to AI works in the design department.

After adding clue 9, running:

```prolog
count_solutions([1,2,3,4,5,6,7,8,9], N).
```

gives **N = 1**. This confirms that the puzzle now has a unique solution, which is S2.

## 5. Testing

The following commands were used to verify the results:

```
swipl -q -f code/81_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)" -t halt
swipl -q -f code/81_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), writeln(N)" -t halt
swipl -q -g run_tests -t halt tests/q1_tests.pl
```

The first command returns 3, the second returns 1, and all tests in `tests/q1_tests.pl` pass.