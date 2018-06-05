function [submissionsTable, rosterCount] = out_file_prep(submissionsTable, dueDate, roster)

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
for i = 1:size(submissionsTable,1)
    % Determine late penalty (if possible)
    % get adjusted due date
    [~, date2] = adjustedDateRange(submissionsTable.SectionNumber(i),...
        dueDate,0);
    
    % get file from submission
    f = submissionsTable.file{i};
    
    % If date of file submission is greater than the adjusted due date
    if class(f) == 'struct'
        if f.date > date2
            % mark the submission late
            submissionsTable.Late(i) = 1;
        end
    end
    
    % Write out the composite and final score formula
    j = num2str(i + 1); % get current excel row #
    
    % Composite score is calculated by weighting the code, header, and
    % comments scores, without a late penalty being evaluated
    submissionsTable.CompositeScore{i} = ['=0.6*J',j,'+0.2*L',j,'+0.2*N',j];
    
    % Final Score takes into account the late penalty, using an 80% haircut
    % policy (late assignments can earn up to 80%)
    submissionsTable.FinalScore{i} = ['=IF(I',j,'=1,IF(H',j,'>0.8,0.8,0.8*H',...
        j,'),H',j,')']; 
end

% Remove the "file" column from the submissions table
submissionsTable.file = [];

% Write out graded and linked submissions to file
if ~exist('graded_assignments','dir')
    mkdir('graded_assignments');
end

writetable(submissionsTable,'graded_assignments/Euler.csv');

% end of function
end