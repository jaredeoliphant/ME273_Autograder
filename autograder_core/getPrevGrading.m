function prevGraded = getPrevGrading(partName, gradedFile, weights)
%============================================BEGIN-HEADER=====
% FILE: getPrevGrading.m
% AUTHOR: Caleb Groves
% DATE: 6 July 2018
%
% PURPOSE:
%   This function reads in a .csv file of a previously graded lab and
%   creates a lab part table with that lab part's grades.
%
% INPUTS:
%   partName - character array with the given name for this lab part.
%
%   gradedFile - Matlab structure with fields <name> and <path> for the
%   .csv of the graded lab.
%
%   weights - Matlab structure with fields <code>, <header>, and <comments>
%   with values that add up to 1.0, representing the grading weights for
%   each of these parts.
%
% OUTPUTS:
%   prevGraded - A Matlab table for this lab part with the following
%   fields: CourseID, Late, Score, CodeScore, CodeFeedback, HeaderScore,
%   HeaderFeedback, CommentScore, CommentFeedback, FeedbackFlag.
%
%
% NOTES:
%   This function depends highly on the ordering of the columns in the
%   graded file's .csv. Any changes to the way the compiled lab parts are
%   put together and written out will need to be changed here, as well.
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Read in the gradedFile as a table
T = readtable(fullfile(gradedFile.path,gradedFile.name));

global studentFields;
global partFields;

% Convert the table to a cell array
gradedTable = table2cell(T);

% Get the CourseID column
prevGraded = table; % initialize prevGraded table
prevGraded.CourseID = gradedTable(:,studentFields.CourseID);
prevGraded.FirstDeadline = gradedTable(:,studentFields.FirstDeadline);
prevGraded.FinalDeadline = gradedTable(:,studentFields.FinalDeadline);

% Go through each column and look for the lab partName match
n = size(gradedTable,2); % get number of columns
p = (n - studentFields.l)/partFields.p; % get number of lab parts for this lab

r = 0; % working index
j = 0;
for i = studentFields.l:partFields.pf:size(gradedTable,2)
    if strcmp(gradedTable(1,i),partName)
        r = i; % Keep that column index when found
        break;
    end
    j = j + 1; % increment part counter
end

% Check to see if lab part name was found in this file
if r == 0
    error(['Could not find lab part <',partName,'> in file <',...
        gradedFile.name,'>.']);
end

% Copy over the columns for code, header, and comment scores and feedback.
% Get the pertinent column indices
feedbackFlagCol = studentFields.FeedbackFlag;
lateCol = r + partFields.LateOffset;
codeCol = r + partFields.CodeScoreOffset;
headerCol = r + partFields.HeaderScoreOffset;
commentCol = r + partFields.CommentScoreOffset;
codeFBCol = n - (p-j)*partFields.pb + partFields.CodeFBOffset;
headerFBCol = n - (p-j)*partFields.pb + partFields.HeaderFBOffset;
commentFBCol = n - (p-j)*partFields.pb + partFields.CommentFBOffset;

% Copy over the columns into the output table
prevGraded.FeedbackFlag = gradedTable(:,feedbackFlagCol);
prevGraded.Late = gradedTable(:,lateCol);
prevGraded.CodeScore = gradedTable(:,codeCol);
prevGraded.HeaderScore = gradedTable(:,headerCol);
prevGraded.CommentScore = gradedTable(:,commentCol);
prevGraded.CodeFeedback = gradedTable(:,codeFBCol);
prevGraded.HeaderFeedback = gradedTable(:,headerFBCol);
prevGraded.CommentFeedback = gradedTable(:,commentFBCol);

% Create a new column for Score, and calculate it for each student using
% the weights structure
for i = 1:size(prevGraded,1)
    prevGraded.Score(i) = prevGraded.CodeScore{i}*weights.code + ...
        prevGraded.HeaderScore{i}*weights.header + ...
        prevGraded.CommentScore{i}*weights.comments;
end