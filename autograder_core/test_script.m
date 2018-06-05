%% Setup of Variables (to be done in GUI later)

partName = 'Euler'; % set assignment name
dueDate = datetime(2018,5,18,14,0,0); % set assignment due date

sub_dir = '/home/pizzaslayer/Downloads/lab9_subs/'; % set submissions directory

graderFile.name = 'Euler_Grader.m'; % set name of grader function
graderFile.path = fullfile('grading_functions'); % set directory of grader function

roster.name = 'roster.csv'; % set name of roster
roster.path = ''; % set directory of roster
%% In-file preparation
submissions = in_file_prep(sub_dir,partName);

%% Assignment Grading
graded = lab_part_grader(submissions,partName,graderFile);

%% Out-file preparation
linked = out_file_prep(graded,dueDate,roster);
