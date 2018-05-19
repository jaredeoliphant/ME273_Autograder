function submissionTable = assignment_grader(submissionTable, assignmentName, graderFile)

%============================================BEGIN-HEADER=====
% FILE: assignment_grader.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   To grade the code, headers, and comments of all of the student
%   submissions passed in as a table for a particular assignment, and
%   return a table with all of their scores and feedback assigned to it,
%   and a standard spreadsheet formula for calculating the composite score
%   (including assignment lateness).
%
% INPUTS:
%   submissionTable - Matlab Table with columns ID, file, oldName
%   assignmentName - char array with name of the assignment that's being
%   graded
%   dueDate - datetime structure for the first day the assignment is due
%   for the first (chronological) lab section.
%   graderFile - Matlab structure for the grading function file with 2
%   fields: name and path.
%
%
% OUTPUTS:
%   submissionTable - Matlab table structure containing the following
%   columns:
%   | File ID | prepared file (object) | original filename | assignment
%   name | code score | code feedback | header score | header feedback |
%   comments score | comments feedback |
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

n = size(submissionTable,1); % get the number of submissions to grade

grade_dir = 'grading_directory'; % name of grading directory folder

% Add paths of submissions and grading function so that Matlab can find and
% run them when called
addpath grade_dir;
addpath graderFile.path;

% Add on the appropriate columns for the submission table
submissionTable.Assignment = cell(n,1);
submissionTable.CodeScore = zeros(n,1);
submissionTable.CodeFeedback = cell(n,1);
submissionTable.HeaderScore = zeros(n,1);
submissionTable.HeaderFeedback = cell(n,1);
submissionTable.CommentScore = zeros(n,1);
submissionTable.CommentFeedback = cell(n,1);
submissionTable.Errors = zeros(n,1);

% Go through submissions table
for i = 1:n
    
    % Grade each file's:
    submission = submissionTable.file{i};
    filename = submission.name; % get current submission's filename
    submissionTable.Assignment{i} = assignmentName;
    
    % Code - call grader function
    eval(['[codeScore, codeFeedback] = ', graderFile.name(1:end-2),...
        '(filename);']);
    
    % Headers and Comments
    [headerScore, headerFeedback, commentScore, commentFeedback, error] = ...
        HeaderCommentGrader_V3(filename);
    
    % Tack on score and feedback for each
    submissionTable.CodeScore(i) = codeScore;
    submissionTable.CodeFeedback{i} = codeFeedback;
    submissionTable.HeaderScore(i) = headerScore;
    submissionTable.HeaderFeedback{i} = headerFeedback;
    submissionTable.CommentScore(i) = commentScore;
    submissionTable.CommentFeedback{i} = commentFeedback;
    submissionTable.GradingError(i) = error;
    
end

% end of function
end