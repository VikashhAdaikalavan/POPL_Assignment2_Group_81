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

% ============================================================
% Unit 4: op_prec/2, needs_parens/3, expr_str/4, expr_to_string/2
% ============================================================

% op_prec(+Op, -Prec)
% Declarative reading: Op has binding precedence Prec.
% Lower-binding operators (+, -) have Prec = 1.
% Higher-binding operators (*, /) have Prec = 2.
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% needs_parens(+ChildPrec, +ParentPrec, +Side)
% Declarative reading: an expression with top-operator precedence ChildPrec,
% occupying position Side of a parent whose operator has precedence ParentPrec,
% requires enclosing parentheses.
% Left operand:  parenthesise iff child's precedence is STRICTLY LOWER than parent's.
% Right operand: parenthesise iff child's precedence is SAME OR LOWER than parent's.
needs_parens(ChildPrec, ParentPrec, left)  :- ChildPrec <  ParentPrec.
needs_parens(ChildPrec, ParentPrec, right) :- ChildPrec =< ParentPrec.

% expr_to_string(+Expr, -String)
% Declarative reading: String is the canonical no-space SWI-Prolog string
% for Expr. Delegates to expr_str/4 with ParentPrec=0 (no parent context)
% so the outermost expression is never wrapped in parentheses.
expr_to_string(Expr, String) :-
    expr_str(Expr, 0, left, String).

% expr_str(+Expr, +ParentPrec, +Side, -Str)
% Declarative reading: Str is the string for Expr, wrapped in parentheses
% when the parenthesisation rules require it given the parent context.
% ParentPrec = 0 means there is no parent; no outer parentheses are added.

% A single number is never parenthesised regardless of context.
expr_str(num(N), _ParentPrec, _Side, Str) :-
    number_string(N, Str).

% A compound expression: recurse on children, concatenate, then wrap if needed.
expr_str(expr(Op, L, R), ParentPrec, Side, Str) :-
    op_prec(Op, MyPrec),
    expr_str(L, MyPrec, left,  LS),
    expr_str(R, MyPrec, right, RS),
    format(string(Inner), "~w~w~w", [LS, Op, RS]),
    (   needs_parens(MyPrec, ParentPrec, Side)
    ->  format(string(Str), "(~w)", [Inner])
    ;   Str = Inner
    ).

% ============================================================
% Unit 5: generate_equation/2
% ============================================================

% generate_equation(+List, -Equation)
%
% Declarative reading: Equation is a valid arithmetic equation string for List,
% using every number exactly once in the original order. It places operators
% +, -, *, / between numbers and exactly one = to split the list into a
% left-hand side expression and a right-hand side expression whose integer
% values are equal.
%
% Fails cleanly (no loop, no error) when no valid equation exists, including
% when List has fewer than two elements (split_list/3 fails immediately then).
%
% On backtracking, generates further valid equations in the order determined
% by split_list/3, build_expr/2, and eval_expr/2.
generate_equation(List, Equation) :-
    split_list(List, LeftNums, RightNums),
    build_expr(LeftNums,  LeftExpr),
    build_expr(RightNums, RightExpr),
    eval_expr(LeftExpr,  V),
    eval_expr(RightExpr, V),          % same variable V: both sides must be equal
    expr_to_string(LeftExpr,  LS),
    expr_to_string(RightExpr, RS),
    format(string(Equation), "~w=~w", [LS, RS]).

% ============================================================
% Unit 6: all_equations/2
% ============================================================

% all_equations(+List, -Equations)
%
% Declarative reading: Equations is the sorted, duplicate-free list of all
% valid arithmetic equation strings for List, in standard order of terms
% (lexicographic for strings). Returns [] when no valid equation exists,
% including when List has fewer than two elements.
%
% Uses findall/3 to collect every solution from generate_equation/2 without
% failing, then sort/2 to sort and remove any duplicates.
all_equations(List, Equations) :-
    findall(E, generate_equation(List, E), All),
    sort(All, Equations).
