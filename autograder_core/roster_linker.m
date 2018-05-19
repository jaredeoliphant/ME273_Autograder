function linkedTable = roster_linker(submissionTable, rosterTable)

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



% end of function
end