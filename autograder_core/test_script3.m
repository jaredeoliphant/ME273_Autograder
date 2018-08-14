% Test script for running the autograder function in full, testing 3 lab
% parts all at once. All inputs are manually specified (you would have to
% change certain file directories).

pseudoDate = datetime(datestr(now)); % pseudoDate
regrading = 1;

manualGrading.flag = 0;
manualGrading.feedbackFlag = 1;
manualGrading.gradingAction = 1;

% Manual setup of autograder function inputs
labNum = 9;
dueDate = datetime(2018,3,26,16,0,0);

roster.name = 'roster.csv'; % set name of roster
roster.path = ''; % set directory of roster

% Lab Parts
labParts = cell(3,1);

% Euler
i = 1;
labParts{i}.name = 'Euler';
labParts{i}.submissionsDir = '~/Documents/ME273_Autograder/testing_files/lab9/Euler';
labParts{i}.graderfile.name = 'Euler_Grader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% Heun
i = 2;
labParts{i}.name = 'Heun';
labParts{i}.submissionsDir = '~/Documents/ME273_Autograder/testing_files/lab9/Heun';
labParts{i}.graderfile.name = 'Heun_Grader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% RK4
i = 3;
labParts{i}.name = 'RK4';
labParts{i}.submissionsDir = '~/Documents/ME273_Autograder/testing_files/lab9/RK4';
labParts{i}.graderfile.name = 'RK4_Grader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% grade all of the lab parts
programSetup(labNum, dueDate, roster, labParts, regrading, manualGrading, ...
    pseudoDate);
