% Test script for running all of the functions contained in the autograder
% function on just one lab part.
%% Setup of Variables (to be done in GUI later)

partName = 'Euler'; % set assignment name
dueDate = datetime(2018,5,18,14,0,0); % set assignment due date

sub_dir = '/home/pizzaslayer/Downloads/lab9_subs/'; % set submissions directory

graderFile.name = 'Euler_Grader.m'; % set name of grader function
graderFile.path = fullfile('grading_functions'); % set directory of grader function

roster.name = 'roster.csv'; % set name of roster
roster.path = ''; % set directory of roster

weights.code = .8;
weights.header = .1;
weights.comments = .1;

%% In-file preparation
submissions = in_file_prep(sub_dir,partName);

%% Linker
linked = roster_linker(submissions,roster);

%% Grader
graded = lab_part_grader(linked,graderFile,dueDate);

%% Lab Grader
partTables = cell(1,1);
partTables{1} = graded;

master = lab_grader(6,partTables,weights);

writetable(master,'graded_labs/Lab6.csv');