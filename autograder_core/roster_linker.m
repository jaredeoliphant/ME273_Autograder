function linkedTable = roster_linker(submissionsTable, rosterTable)

%============================================BEGIN-HEADER=====
% FILE: roster_linker.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   Tries to match the submissionsTable.ID to the rosterTable.courseID for
%   each submission. If it succeeds, it appends all of the student
%   information. If not, it writes an error message.
%
% INPUTS:
%   submissionsTable - Matlab table structure with fields: fileID, file,
%   oldfileName, Assignment, CodeScore, CodeFeedback, HeaderScore,
%   HeaderFeedback, CommentScore, CommentFeedback, GradingError.
% 
%   rosterTable - Matlab table structure with fields: LastName, FirstName,
%   Email, CourseID, SectionNumber
%
%
% OUTPUTS:
%   linkedTable - Matlab table structure with the following fields:
%   CourseID, LastName, FirstName, Email, SectionNumber, Assignment,
%   CodeScore, CodeFeedback, HeaderScore, HeaderFeedback, CommentScore,
%   CommentFeedback, GradingError.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% get number of submissions
n = size(submissionsTable,1);

% Create the linked and unmatched tables
linkedTable = table;
unmatchedTable = table;

% Go through each submission table
for i = 1:n
    
    % initialize matched flag
    matched = 0;
    
    
    % Go through each row in the roster table
    for j = 1:size(rosterTable,1)
        
        % if the course ID's match, then assign all student info and
        % grading info to the linked table
        if submissionsTable.ID(i) == rosterTable.CourseID(j)
            
            % throw matched flag
            matched = 1;
            
            % assign student info and grading info to linked table
            
    % If no match was ever found, assign all grading info to the unmatched
    % tables and label the student info appropriately
    
% Append the unmatched table to the end of the linked table

% end of function
end