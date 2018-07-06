% Test for getPrevGrading.m
% Set partName
partName = 'Euler';

% Set gradedFile name and path
gradedFile.path = 'graded_labs';
gradedFile.name = 'Lab6Graded(25-06-2018 08-16).csv';

% set weights structure
weights.code = .8;
weights.header = .1;
weights.comments = .1;

prevGraded = getPrevGrading(partName, gradedFile, weights);