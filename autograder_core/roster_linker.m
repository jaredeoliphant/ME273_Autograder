function linkedTable = roster_linker(submissionsTable, roster, partName)

%============================================BEGIN-HEADER=====
% FILE: roster_linker.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   Tries to match the submissionsTable.CourseID to the
%   rosterTable.CourseID for each submission. If it succeeds, it appends
%   all of the student information. If not, it writes an error message.
%
% INPUTS:
%   submissionsTable - Matlab table structure with fields: CourseID, File,
%   GoogleTag, PartName.
% 
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to. The .csv is assumed to have
%   the following columns: LastName, FirstName, Email, SectionNumber,
%   CourseID.
%
%   partName - character array of lab part name
%
% OUTPUTS:
%   linkedTable - Matlab table structure with the following fields:
%   CourseID, LastName, FirstName, GoogleTag, SectionNumber, PartName,
%   Email.
%
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
rmpath(roster.path); % remove roster path

% get number of submissions
n = size(submissionsTable,1);

% Add on pertinent fields to roster table from graded submissions table
m = size(rosterTable,1);

rosterTable.PartName = cell(m,1);
rosterTable.GoogleTag = cell(m,1);
rosterTable.File = cell(m,1);

% Go through each student in the roster table
for i = 1:m
    % label the lab part name regardless of whether or not there is a file
    % submission
    rosterTable.PartName{i} = partName;
    
    % Go through each row in the submissions table
    for j = 1:n
        
        % if the course ID's match, then assign all student info and
        % grading info to the linked table
        if submissionsTable.CourseID(j) == rosterTable.CourseID(i)
            
            %rosterTable.PartName{i} = submissionsTable.PartName{j};
            rosterTable.File{i} = submissionsTable.File{j};
            rosterTable.GoogleTag{i} = submissionsTable.GoogleTag{j};

            break;
            
        end
        
    end % roster loop
    
end % student loop

linkedTable = rosterTable; % create linked table

% end of function
end