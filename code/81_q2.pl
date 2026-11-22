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

% ============================================================
% Unit 3: eval_expr/2
% ============================================================

% eval_expr(+Expr, -Value)
%
% Declarative reading: Value is the integer result of evaluating the
% expression tree Expr. Fails (without raising an error) when any
% division in the tree has a zero divisor or produces a non-integer
% result. Negative intermediate values are supported.
%
% Base case: a leaf num(N) evaluates to N.
% Recursive cases: evaluate both sub-trees, then apply the operator.
% Division: check VR \= 0 first, then check exact divisibility via mod,
% then compute the quotient with //.

% base case
eval_expr(num(N), N).

% addition
eval_expr(expr(+, L, R), V) :-
    eval_expr(L, VL),
    eval_expr(R, VR),
    V is VL + VR.

% subtraction
eval_expr(expr(-, L, R), V) :-
    eval_expr(L, VL),
    eval_expr(R, VR),
    V is VL - VR.

% multiplication
eval_expr(expr(*, L, R), V) :-
    eval_expr(L, VL),
    eval_expr(R, VR),
    V is VL * VR.

% division: succeeds only when the divisor is nonzero and the division
% is exact (no remainder). Uses // which truncates toward zero; this
% agrees with div when the remainder is zero.
eval_expr(expr(/, L, R), V) :-
    eval_expr(L, VL),
    eval_expr(R, VR),
    VR =\= 0,
    VL mod VR =:= 0,
    V is VL // VR.
