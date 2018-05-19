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

% Add on pertinent fields to submissions table
submissionsTable.LastName = cell(n,1);
submissionsTable.FirstName = cell(n,1);
submissionsTable.Email = cell(n,1);
submissionsTable.SectionNumber = zeros(n,1);

% unmatched counter
unmatched = 0;

% Go through each submission table
for i = 1:n
    % match flag
    match = 0;
    
    % Go through each row in the roster table
    for j = 1:size(rosterTable,1)
        
        % if the course ID's match, then assign all student info and
        % grading info to the linked table
        if submissionsTable.ID(i) == rosterTable.CourseID(j)
            
            match = 1;
            
            % assign student info to submissions table
            submissionsTable.LastName{i} = rosterTable.LastName(j);
            submissionsTable.FirstName{i} = rosterTable.FirstName(j);
            submissionsTable.Email{i} = rosterTable.Email(j);
            submissionsTable.SectionNumber(i) = rosterTable.SectionNumber(j);
            
            continue;
            
        end
        
    end % roster loop
        
    % If no match was ever found, label the student info as such
    if match == 0

        submissionsTable.LastName{i} = 'unmatched';
        submissionsTable.FirstName{i} = submissionsTable.oldName{i};
        
        unmatched = unmatched + 1; % increment unmatched counter

    end
    
end % student loop

% allocate table sizes for matched and unmatched
matched = n-unmatched;

mTable = submissionsTable(1:matched,:);
umTable = submissionsTable(1:unmatched,:);

% Reorder submissionsTable to put columns in order and all unmatched
% entries at the end
m = 1; % matched table index
um = 1; % unmatched table index

for i = 1:n
    
    if strcmp(submissionsTable.LastName{i},'unmatched')
        umTable(um,:) = submissionsTable(i,:);
        um = um + 1;
    else
        mTable(m,:) = submissionsTable(i,:);
        m = m + 1;
    end

end

% Make the LinkedTable
linkedTable = [mTable; umTable];

% end of function
end