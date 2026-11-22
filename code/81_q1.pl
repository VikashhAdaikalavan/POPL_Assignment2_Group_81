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