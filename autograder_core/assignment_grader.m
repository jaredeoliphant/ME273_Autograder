function submissionsTable = assignment_grader(submissionsTable, partName, graderFile)

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
%   submissionTable - Matlab Table with columns CourseID, file, GoogleTag
%   partName - char array with name of the lab part that's being
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
%   | CourseID | file (object) | GoogleTag | Part Name | CodeScore |
%   CodeFeedback | HeaderScore | HeaderFeedback | CommentScore |
%   CommentFeedback | GradingError |
%
%
% NOTES:
%  
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

n = size(submissionsTable,1); % get the number of submissions to grade

grade_dir = 'grading_directory'; % name of grading directory folder

% Add paths of submissions and grading function so that Matlab can find and
% run them when called
addpath(grade_dir);
addpath(graderFile.path);

% Add on the appropriate columns for the submission table
submissionsTable.PartName = cell(n,1);
submissionsTable.CodeScore = zeros(n,1);
submissionsTable.CodeFeedback = cell(n,1);
submissionsTable.HeaderScore = zeros(n,1);
submissionsTable.HeaderFeedback = cell(n,1);
submissionsTable.CommentScore = zeros(n,1);
submissionsTable.CommentFeedback = cell(n,1);
submissionsTable.GradingError = zeros(n,1);

% Go through submissions table
for i = 1:n
    
    % Grade each file's:
    submission = submissionsTable.file{i};
    filename = submission.name; % get current submission's filename
    submissionsTable.PartName{i} = partName;
    
    % Code - call grader function
    eval(['[codeScore, codeFeedback] = ', graderFile.name(1:end-2),...
        '(filename);']);
    
    % Headers and Comments
    [headerScore, headerFeedback, commentScore, commentFeedback, error] = ...
        HeaderCommentGrader_V3(filename);
    
    % Tack on score and feedback for each
    submissionsTable.CodeScore(i) = codeScore;
    submissionsTable.CodeFeedback{i} = codeFeedback;
    submissionsTable.HeaderScore(i) = headerScore;
    submissionsTable.HeaderFeedback{i} = headerFeedback;
    submissionsTable.CommentScore(i) = commentScore;
    submissionsTable.CommentFeedback{i} = commentFeedback;
    submissionsTable.GradingError(i) = error;
    
end

restoredefaultpath;

% end of function
end