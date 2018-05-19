%% Setup of Variables (to be done in GUI later)

assignmentName = 'Euler';
sub_dir = '/home/pizzaslayer/Downloads/lab9_subs/';

graderFile.name = 'Euler_Grader.m';
graderFile.path = fullfile('grading_functions');

roster.name = 'roster.csv';
roster.path = '';

dueDate = datetime(2018,5,18,14,0,0);

%% In-file preparation
submissions = in_file_prep(sub_dir,assignmentName);

%% Assignment Grading
graded = assignment_grader(submissions,assignmentName,graderFile);

%% Out-file preparation
out_file_prep(graded,dueDate,roster);
