% q1_tests.pl -- tests for P1 (code/81_q1.pl)
% Run from the repository root with:
%   swipl -q -g run_tests -t halt tests/q1_tests.pl

:- use_module(library(plunit)).
:- consult('../code/81_q1.pl').

% The three solutions of clues 1 to 8, used as known test data.
s1([p('Alex',design,java,'AI'), p('Ben',development,javascript,web),
    p('Carla',research,'c++',data), p('Dana',testing,python,embedded)]).
s2([p('Alex',design,java,embedded), p('Ben',development,javascript,web),
    p('Carla',testing,python,'AI'), p('Dana',research,'c++',data)]).
s3([p('Alex',testing,python,embedded), p('Ben',development,javascript,web),
    p('Carla',design,java,'AI'), p('Dana',research,'c++',data)]).

% clue_count(+N, -Count): number of candidates that pass clue N alone.
clue_count(N, Count) :-
    aggregate_all(count, (candidate(S), clue(N, S)), Count).

:- begin_tests(candidates).

test(all_candidates) :-
    aggregate_all(count, candidate(_), 13824).

test(every_value_used_once) :-
    forall(candidate(S),
           ( findall(D, member(p(_,D,_,_), S), Ds), msort(Ds, [design,development,research,testing]),
             findall(L, member(p(_,_,L,_), S), Ls), msort(Ls, ['c++',java,javascript,python]),
             findall(P, member(p(_,_,_,P), S), Ps), msort(Ps, ['AI',data,embedded,web]) )).

:- end_tests(candidates).

:- begin_tests(clues).

% Each clue on its own keeps the expected number of candidates.
test(clue1) :- clue_count(1, 7776).
test(clue2) :- clue_count(2, 7776).
test(clue3) :- clue_count(3, 3456).
test(clue4) :- clue_count(4, 2592).
test(clue5) :- clue_count(5, 3456).
test(clue6) :- clue_count(6, 7776).
test(clue7) :- clue_count(7, 5184).
test(clue8) :- clue_count(8, 2592).

% The three known solutions satisfy every one of clues 1 to 8.
test(known_solutions_pass_clues_1_to_8) :-
    forall(member(G, [s1, s2, s3]),
           ( call(G, S), forall(between(1, 8, N), clue(N, S)) )).

% Clue 9 is true only in the solution we keep.
test(clue9_true_in_kept_solution) :- s2(S), clue(9, S).
test(clue9_false_in_s1, [fail]) :- s1(S), clue(9, S).
test(clue9_false_in_s3, [fail]) :- s3(S), clue(9, S).

% Some single-clue failures on a candidate that breaks them.
test(clue2_fails_when_alex_uses_cpp, [fail]) :-
    clue(2, [p('Alex',design,'c++',web), p('Ben',development,java,'AI'),
             p('Carla',research,python,data), p('Dana',testing,javascript,embedded)]).
test(clue3_fails_when_tester_not_python, [fail]) :-
    clue(3, [p('Alex',design,java,web), p('Ben',development,python,'AI'),
             p('Carla',research,'c++',data), p('Dana',testing,javascript,embedded)]).

:- end_tests(clues).

:- begin_tests(counts).

test(no_clues)        :- count_solutions([], 13824).
test(clues_1_to_4)    :- count_solutions([1,2,3,4], 208).
test(clues_1_to_8)    :- count_solutions([1,2,3,4,5,6,7,8], 3).
test(clues_1_to_9)    :- count_solutions([1,2,3,4,5,6,7,8,9], 1).
test(order_irrelevant):- count_solutions([8,7,6,5,4,3,2,1], 3).

test(clues_1_to_8_are_s1_s2_s3) :-
    findall(S, satisfies([1,2,3,4,5,6,7,8], S), Sols),
    s1(A), s2(B), s3(C),
    msort(Sols, Sorted), msort([A, B, C], Sorted).

test(clues_1_to_9_unique_solution) :-
    findall(S, satisfies([1,2,3,4,5,6,7,8,9], S), [Only]),
    s2(Only).

:- end_tests(counts).

:- begin_tests(output).

% main prints four lines in the required format, values without quotes.
test(main_format) :-
    with_output_to(string(Out), main),
    Out == "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n".

:- end_tests(output).