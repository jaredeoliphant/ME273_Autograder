function out_file_prep(submissionsTable, dueDate, roster)

%============================================BEGIN-HEADER=====
% FILE: out_file_prep.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   Links the assignment submissions to actual student data (if possible),
%   assigns a late penalty if applicable based on lab section, and writes
%   out the submissions to a .csv with the final score formula.
%
% INPUTS:
%   submissionsTable - Matlab table structure with fields: fileID, file,
%   oldfileName, Assignment, CodeScore, CodeFeedback, HeaderScore,
%   HeaderFeedback, CommentScore, CommentFeedback, GradingError.
% 
%   dueDate - Matlab datetime object for first section's duedate
%   (chronologically)
% 
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to.
%
%
% OUTPUTS:
%   Writes out the completed scores with associated student information to
%   a graded folder as a .csv. No values returned.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Link submissions to the rest of the student info
% Read roster file into a Matlab table
addpath(roster.path);
rosterTable = readtable(roster.name);

submissionsTable = roster_linker(submissionsTable,rosterTable); % link

% Go through each submission
    % Determine late penalty (if possible)
    % Write out the final score formula

% Write out graded and linked submissions to file

% end of function
end