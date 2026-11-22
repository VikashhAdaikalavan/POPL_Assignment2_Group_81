% tests/q2_tests -- Test suite for P2 (Form a Valid Arithmetic Equation)
% Group 81

:- consult('../code/81_q2.pl').

% Run all tests and print summary
run_tests :-
    format("Running Q2 Test Suite...~n", []),
    run_all([
        test_example_1,
        test_example_2,
        test_example_3,
        test_empty_list,
        test_single_element_list,
        test_zeros_in_input,
        test_division_by_zero,
        test_inexact_division,
        test_negative_intermediate_values,
        test_canonical_parentheses,
        test_string_types,
        test_sorted_no_duplicates
    ]).

run_all([]).
run_all([Test|Rest]) :-
    (   call(Test)
    ->  format("  [PASS] ~w~n", [Test])
    ;   format("  [FAIL] ~w~n", [Test]),
        fail
    ),
    run_all(Rest).

% 1. Example 1 from PDF: [4,2,5,3]
test_example_1 :-
    all_equations([4,2,5,3], Es),
    Expected = [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ],
    Es == Expected,
    count_equations([4,2,5,3], 7),
    generate_equation([4,2,5,3], E),
    member(E, Expected).

% 2. Example 2 from PDF: [2,3,4] (no valid equation)
test_example_2 :-
    \+ generate_equation([2,3,4], _),
    all_equations([2,3,4], []),
    count_equations([2,3,4], 0).

% 3. Example 3 from PDF: [2,4,8]
test_example_3 :-
    all_equations([2,4,8], ["2*4=8"]),
    count_equations([2,4,8], 1),
    generate_equation([2,4,8], "2*4=8").

% 4. Empty list edge case
test_empty_list :-
    \+ generate_equation([], _),
    all_equations([], []),
    count_equations([], 0).

% 5. Single element list edge case
test_single_element_list :-
    \+ generate_equation([5], _),
    all_equations([5], []),
    count_equations([5], 0).

% 6. Zeros in input list
test_zeros_in_input :-
    all_equations([0,0], ["0=0"]),
    count_equations([0,0], 1),
    generate_equation([0,0], "0=0").

% 7. Division by zero fails cleanly without raising errors
test_division_by_zero :-
    \+ eval_expr(expr(/, num(5), num(0)), _),
    \+ eval_expr(expr(+, expr(/, num(5), num(0)), num(1)), _),
    all_equations([4,0,2], Es),
    \+ member("4/0=2", Es).

% 8. Inexact division fails cleanly without converting to float
test_inexact_division :-
    \+ eval_expr(expr(/, num(5), num(2)), _),
    \+ eval_expr(expr(/, num(7), num(3)), _),
    \+ generate_equation([5,2], _).

% 9. Negative intermediate values are allowed
test_negative_intermediate_values :-
    eval_expr(expr(-, num(3), num(5)), -2),
    eval_expr(expr(+, expr(-, num(3), num(5)), num(2)), 0),
    all_equations([3,5,2,0], Es),
    member("3-5+2=0", Es).

% 10. Canonical parentheses formatting rules from PDF
test_canonical_parentheses :-
    expr_to_string(num(5), "5"),
    expr_to_string(expr(*, expr(+, num(4), num(2)), num(3)), "(4+2)*3"),
    expr_to_string(expr(+, num(4), expr(*, num(2), num(3))), "4+2*3"),
    expr_to_string(expr(*, expr(/, num(8), num(4)), num(2)), "8/4*2"),
    expr_to_string(expr(/, num(8), expr(*, num(4), num(2))), "8/(4*2)"),
    expr_to_string(expr(-, expr(-, num(1), num(2)), num(3)), "1-2-3"),
    expr_to_string(expr(-, num(1), expr(-, num(2), num(3))), "1-(2-3)"),
    expr_to_string(expr(+, num(1), expr(+, num(2), num(3))), "1+(2+3)"),
    expr_to_string(expr(+, expr(+, num(1), num(2)), num(3)), "1+2+3").

% 11. Type check: all generated equations are SWI-Prolog strings
test_string_types :-
    all_equations([4,2,5,3], Es),
    maplist(string, Es).

% 12. Standard term order sorting and duplicate elimination
test_sorted_no_duplicates :-
    all_equations([4,2,5,3], Es),
    sort(Es, Sorted),
    Es == Sorted.
