P1 REPORT: DEPARTMENT ASSIGNMENT PUZZLE



1\. NUMBER OF SOLUTIONS FOR CLUES 1 TO 8



Running the following query:



count\_solutions(\[1,2,3,4,5,6,7,8], N).



gives N = 3.



This means that the first eight clues allow three possible solutions. The result was obtained using count\_solutions/2 in code/81\_q1.pl, which checks all 13,824 possible assignments and keeps only the valid ones.



2\. WHAT THE RESULT TELLS US



The three possible solutions are:



S1:

Alex  - design, java, AI

Ben   - development, javascript, web

Carla - research, c++, data

Dana  - testing, python, embedded



S2:

Alex  - design, java, embedded

Ben   - development, javascript, web

Carla - testing, python, AI

Dana  - research, c++, data



S3:

Alex  - testing, python, embedded

Ben   - development, javascript, web

Carla - design, java, AI

Dana  - research, c++, data



Some assignments remain the same in all three solutions:



\- Ben is always in development, uses JavaScript and works on web.

\- The person in research always uses C++ and works on data.

\- Java is always associated with design, while Python is associated with testing.



However, the assignment of AI and embedded projects between the design and testing departments is not fixed.



3\. WHY S2 CAN BE SELECTED WITHOUT USING NAMES



If we ignore the friends' names, S1 and S3 have exactly the same combinations of department, language and project. They differ only in which friend is assigned to each combination.



Since P1.c does not allow names to be used in the additional clue, we cannot distinguish between S1 and S3 using such a clue.



S2 is different because the person working in testing and using Python is assigned the AI project, while the person working in design and using Java is assigned the embedded project.



Therefore, a clue based on these attributes can select S2.



4\. ADDING CLUE 9



The following clue was added:



"The friend who prefers the AI project works in the testing department."



This clue is satisfied only by S2. In S1 and S3, the person assigned to AI works in the design department.



After adding clue 9, running:



count\_solutions(\[1,2,3,4,5,6,7,8,9], N).



gives N = 1.



This confirms that the puzzle now has a unique solution, which is S2.



5\. TESTING



The following commands were used to verify the results:



swipl -q -f code/81\_q1.pl -g "count\_solutions(\[1,2,3,4,5,6,7,8], N), writeln(N)" -t halt



swipl -q -f code/81\_q1.pl -g "count\_solutions(\[1,2,3,4,5,6,7,8,9], N), writeln(N)" -t halt



swipl -q -g run\_tests -t halt tests/q1\_tests.pl



The first command returns 3, the second returns 1, and all tests in tests/q1\_tests.pl pass.

