assignmentName = 'Euler';
sub_dir = '/home/pizzaslayer/Downloads/lab9_subs/';
graderFile.name = 'Euler_Grader.m';
graderFile.path = fullfile('grading_functions');

submissions = in_file_prep(sub_dir,assignmentName);

graded = assignment_grader(submissions,assignmentName,graderFile);