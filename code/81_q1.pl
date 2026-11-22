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

    % Clue 5: The friend whose favorite language is Java works in the design
% department.
clue(5, Sol) :-
    memberchk(p(_, Dept, java, _), Sol),
    Dept == design.

% Clue 6: Carla's project preference is not embedded, and her department is
% not development.
clue(6, Sol) :-
    memberchk(p('Carla', Dept, _, Project), Sol),
    Project \== embedded,
    Dept \== development.

% Clue 7: Dana's favorite language is not Java, and she works in research or
% testing.
clue(7, Sol) :-
    memberchk(p('Dana', Dept, Lang, _), Sol),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% Clue 8: The friend who prefers data projects works in research and does not
% use JavaScript.
clue(8, Sol) :-
    memberchk(p(_, Dept, Lang, data), Sol),
    Dept == research,
    Lang \== javascript.

    % satisfies(+Active, -Sol)
% Sol is a candidate in which every clue whose number is in Active holds.
% Clues that are not in Active are ignored.
satisfies(Active, Sol) :-
    candidate(Sol),
    forall(member(N, Active), clue(N, Sol)).

% print_person(+P)
% Prints one friend as "Name = [Dept, Lang, Project]" on its own line.
% ~w writes atoms without quotes, so 'c++' and 'AI' appear as c++ and AI.
print_person(p(Name, Dept, Lang, Project)) :-
    format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project]).

% main/0
% Finds one solution that satisfies clues 1 to 8 and prints it, one line per
% friend, in the order Alex, Ben, Carla, Dana.
main :-
    once(satisfies([1, 2, 3, 4, 5, 6, 7, 8], Sol)),
    forall(member(P, Sol), print_person(P)).