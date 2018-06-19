function submissionsTable = out_file_prep(submissionsTable, dueDate, roster)

%============================================BEGIN-HEADER=====
% FILE: out_file_prep.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   Links the assignment submissions to actual student data (if possible),
%   assigns a late penalty if applicable based on lab section, and returns
%   the table with linked grading data and student info.
%
% INPUTS:
%   submissionsTable - Matlab table structure with fields: CourseID, File,
%   GoogleTag, PartName
% 
%   dueDate - Matlab datetime object for first section's duedate
%   (chronologically)
% 
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to.
%
% OUTPUTS:
%   Returns the linked-up submissionsTable, with a column correctly marked
%   for lateness or not.
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Read roster file into a Matlab table
addpath(roster.path);
rosterTable = readtable(roster.name);

% Link submissions to the rest of the student info
linkedTable = roster_linker(submissionsTable,rosterTable);

% Assign late penalty
% Go through each student
for i = 1:size(linkedTable,1)

    % get file from submission
    f = linkedTabe.File{i};
    
    % Check to make sure the student submitted something first
    if class(f) ~= 'struct'
    
        % get adjusted due date
        [~, date2] = adjustedDateRange(linkedTable.SectionNumber(i),...
            dueDate,0);
    
        % If date of file submission is greater than the adjusted due date
        if f.date > date2
            % mark the submission late
            linkedTable.Late(i) = 1;
        end
        
    end

end % end of late penalty assignment

% Remove the "file" column from the submissions table
linkedTable.File = [];

end % end of function