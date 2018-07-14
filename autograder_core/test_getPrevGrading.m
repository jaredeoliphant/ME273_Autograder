% Test for getPrevGrading.m
% Set partName
partName = 'SixDerivs';

% Set gradedFile name and path
gradedFile.path = './../graded_labs';
gradedFile.name = 'Lab6Graded(2018-07-09 08-41-41).csv';

% set weights structure
weights.code = .8;
weights.header = .1;
weights.comments = .1;

prevGraded = getPrevGrading(partName, gradedFile, weights);