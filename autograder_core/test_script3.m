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
labParts{i}.dueDate = datetime(2018,3,8,16,0,0);
labParts{i}.submissionsDir = '/home/pizzaslayer/Downloads/lab9_subs/';
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
autograder(labNum, roster, weights, labParts);