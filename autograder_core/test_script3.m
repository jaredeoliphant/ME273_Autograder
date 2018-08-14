% Test script for running the autograder function in full, testing 3 lab
% parts all at once. All inputs are manually specified (you would have to
% change certain file directories).

pseudoDate = datetime(2018,4,30,21,0,0); % pseudoDate
regrading = 0;

% Manual setup of autograder function inputs
labNum = 10;
dueDate = datetime(2018,3,26,16,0,0);

roster.name = 'roster.csv'; % set name of roster
roster.path = ''; % set directory of roster

% Lab Parts
labParts = cell(1,1);

% Euler
i = 1;
labParts{i}.name = 'Euler';
labParts{i}.submissionsDir = '/home/pizzaslayer/Downloads/lab9_subs/';
labParts{i}.graderfile.name = 'Euler_Grader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% grade all of the lab parts
programSetup(labNum, dueDate, roster, labParts, regrading, pseudoDate);
