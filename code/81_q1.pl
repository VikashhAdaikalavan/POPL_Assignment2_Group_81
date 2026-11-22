% 81_q1.pl -- P1: Department Assignment Puzzle, Reloaded
:- use_module(library(lists)).

% candidate(-Sol)
% Sol is a fully filled-in assignment for Alex, Ben, Carla and Dana (in that
% order) in which every department, language and project is used exactly once.
% Declarative reading: Sol is a candidate if its departments, languages and
% projects are each a permutation of the four allowed values.
candidate(Sol) :-
    Sol = [ p('Alex',  D1, L1, P1),
            p('Ben',   D2, L2, P2),
            p('Carla', D3, L3, P3),
            p('Dana',  D4, L4, P4) ],
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],        [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [P1, P2, P3, P4]).

    % clue(+N, +Sol)
% Succeeds exactly when clue number N holds in the fully filled-in Sol.
% Each value is used by exactly one friend, so memberchk/2 finds the one
% friend a clue talks about.

% Clue 1: The friend who prefers the AI project does not work in research
% and is not Dana.
clue(1, Sol) :-
    memberchk(p(Name, Dept, _, 'AI'), Sol),
    Dept \== research,
    Name \== 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Sol) :-
    memberchk(p('Alex', Dept, Lang, _), Sol),
    Dept \== development,
    Lang \== 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Sol) :-
    memberchk(p(_, testing, Lang, _), Sol),
    Lang == python.

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Sol) :-
    memberchk(p('Ben', Dept, _, Project), Sol),
    Project == web,
    Dept \== testing.