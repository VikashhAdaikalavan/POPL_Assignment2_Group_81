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
