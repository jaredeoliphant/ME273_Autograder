% Test script for running the autograder function in full, testing 3 lab
% parts all at once. All inputs are manually specified (you would have to
% change certain file directories).

% Specify whether this will run as first-time grading (1), continued
% grading (2), or resubmission grading (3):
mode = 2;

pseudoDate = datetime(2018,3,3,18,0,0); % default pseudoDate

% Specify graded file and pseudoDate
if mode == 2
    gradedFile.name = 'Lab6Graded(2018-03-03 18-00-00).csv';
    pseudoDate = datetime(2018,3,3,18,1,0); 
elseif mode == 3
    gradedFile.name = 'Lab6Graded(2018-03-03 18-01-00).csv';
    pseudoDate = datetime(2018,3,3,18,2,0); 
end
gradedFile.path = 'graded_labs';

% Manual setup of autograder function inputs
labNum = 6;

roster.name = 'roster.csv'; % set name of roster
roster.path = ''; % set directory of roster

% set weights structure
weights.code = .8;
weights.header = .1;
weights.comments = .1;

% Lab Parts
labParts = cell(3,1);

% Euler
i = 1;
labParts{i}.name = 'Euler';
labParts{i}.dueDate = datetime(2018,3,19,16,0,0);

if mode == 1
    labParts{i}.submissionsDir = '/home/pizzaslayer/Downloads/lab9_subs (copy)/';
else
    labParts{i}.submissionsDir = '/home/pizzaslayer/Downloads/lab9_subs/';
end

labParts{i}.graderfile.name = 'Euler_Grader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% SixDerivs
i = 2;
labParts{i}.name = 'SixDerivs';
labParts{i}.dueDate = datetime(2018,2,1,16,0,0);
labParts{i}.submissionsDir = '/home/pizzaslayer/Downloads/SixDerivs_subs/';
labParts{i}.graderfile.name = 'sixDerivsGrader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% FBC
i = 3;
labParts{i}.name = 'FBC';
labParts{i}.dueDate = datetime(2018,2,1,16,0,0);
labParts{i}.submissionsDir = '/home/pizzaslayer/Downloads/FBC_subs/';
labParts{i}.graderfile.name = 'fbcGrader.m';
labParts{i}.graderfile.path = fullfile('grading_functions');

% grade all of the lab parts
switch mode
    case 1
        programSetup(labNum, roster, weights, labParts, 0, pseudoDate);
    case 2
        programSetup(labNum, roster, weights, labParts, 0, ...
            pseudoDate);
    case 3
        programSetup(labNum, roster, weights, labParts, 1, ...
            pseudoDate);
    otherwise
        programSetup(labNum, roster, weights, labParts, 1, pseudoDate);
end