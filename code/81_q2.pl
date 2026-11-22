% 81_q2.pl -- P2: Form a Valid Arithmetic Equation
% Group 81
%
% Three public predicates:
%   generate_equation(+List, -Equation)
%   all_equations(+List, -Equations)
%   count_equations(+List, -N)
%
% Allowed libraries: lists, apply, yall, aggregate.
% No assert/retract, no global variables, no initialization directives,
% no calls to halt/0, no output at load time.

:- use_module(library(lists)).

% ============================================================
% Unit 1: split_list/3
% ============================================================

% split_list(+List, -Left, -Right)
%
% Declarative reading: Left and Right are non-empty lists such that
% appending Left and Right gives List.
%
% On backtracking, enumerates every way to split List into two non-empty
% contiguous parts while preserving the original order.
% Fails immediately when List has fewer than two elements.
split_list(List, Left, Right) :-
    append(Left, Right, List),
    Left  = [_|_],
    Right = [_|_].

% ============================================================
% Unit 2: build_expr/2
% ============================================================

% build_expr(+List, -Expr)
%
% Declarative reading: Expr is an expression tree over the numbers in List,
% using every number exactly once and in the original order.
%
% Internal representation:
%   num(N)            -- a leaf node holding integer N
%   expr(Op, L, R)    -- an internal node with operator Op in {+,-,*,/}
%                        and sub-trees L and R
%
% Base case: a singleton list produces exactly one tree: num(N).
% Recursive case: split List into two non-empty halves at every position,
% pick an operator, and recursively build sub-trees for each half.
% The guard [_,_|_] prevents the recursive clause from firing on singletons.

% base case
build_expr([N], num(N)).

% recursive case
build_expr(List, expr(Op, Left, Right)) :-
    List = [_,_|_],
    split_list(List, LeftNums, RightNums),
    member(Op, [+, -, *, /]),
    build_expr(LeftNums, Left),
    build_expr(RightNums, Right).
