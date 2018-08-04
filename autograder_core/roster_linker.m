function linkedTable = roster_linker(submissionsTable, roster, labNum, ...
    partName, weights, regrading, dueDate, pseudoDate)

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
%   weights - a structure with the weights assigned to each part of the lab
%   part score: code, header, feedback
%
%   regrading - an integer 1 or 0 indicating whether the program is being
%   run is regrading mode or not.
%
%   dueDate - Matlab datetime structure of the first chronological due date
%   for this current lab.
%
%   pseudoDate - Matlab datetime structure indicating what the program
%   interprets as "now", or "today"
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
rosterTable.FirstDeadline = cell(m,1);
rosterTable.FinalDeadline = cell(m,1);

% Try finding previously graded lab part
firstTimeGrading = 1; % initiate firstTimeGrading flag
[~, prevGraded] = getOrCreateLabRecord(labNum);

if ~strcmp('none',prevGraded) % if a previously graded file exists
    firstTimeGrading = 0; % clear firstTimeGrading flag
    % get this lab part from the graded file
    prevGraded = getPrevGrading(partName, prevGraded, weights);
end

% Go through each student in the roster table
for i = 1:m
    % label the lab part name regardless of whether or not there is a file
    % submission
    rosterTable.PartName{i} = partName;
    
    % Get or assign student submission deadlines
    
    match = 0; % matching student flag
    
    if ~firstTimeGrading % if there's a previously graded lab part
        for j = 1:size(prevGraded,1) % for each student in that file
            % if CourseID's match (student match)
            if rosterTable.CourseID(i) == prevGraded.CourseID{j}
                match = 1;
                rosterTable.FirstDeadline{i} = ...
                    datetime(prevGraded.FirstDeadline{j});
                rosterTable.FinalDeadline{i} = ...
                    datetime(prevGraded.FinalDeadline{j});
                break; % exit this for-loop
            end
        end
    elseif firstTimeGrading || ~match
        % create deadlines based on student section number
        [rosterTable.FirstDeadline{i}, rosterTable.FinalDeadline{i}] = ...
            getSectionDueDates(rosterTable.SectionNumber(i), dueDate);
    end
    
    % Choose which deadline to use as current
    currentDeadline = rosterTable.FirstDeadline{i};
    if regrading
        currentDeadline = rosterTable.FinalDeadline{i};
    end
    
    % Go through each row in the submissions table
    for j = 1:n
        % parse CourseID from filename
        submissionID = parseCourseID(submissionsTable(j).name);
        
        if rosterTable.CourseID(i) == submissionID % student match
            % Check to see if submission file should replace current file
            f = rosterTable.File{i};
            
            d = datetime(submissionsTable(j).date); 
            
            % if the submission date is before the current deadline and it
            % was submitted before the pseudodate ("now")
            if d < currentDeadline && d <= pseudoDate
                
                % if there exists a current file for this student and the
                % submission date is newer than the current file's date OR
                % if there's no file with this student at all
                if (isstruct(f) && d > f.date) || ~isstruct(f)
                    
                    % rename file and assign to student
                    rosterTable.File{i} = rename_file(...
                        submissionsTable(j), partName);
                    rosterTable.GoogleTag{i} = getGoogleTag(...
                        submissionsTable(j).name);
                end
            end % before current deadline check
            
        end % course ID check
    end % next submission
                    
end % roster loop

linkedTable = rosterTable; % create linked table

% end of function
end