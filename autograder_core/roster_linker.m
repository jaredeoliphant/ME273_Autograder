function linkedTable = roster_linker(submissionsTable, rosterTable)

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
%   submissionsTable - Matlab table structure with fields: CourseID, file,
%   GoogleTag, PartName, CodeScore, CodeFeedback, HeaderScore,
%   HeaderFeedback, CommentScore, CommentFeedback.
% 
%   rosterTable - Matlab table structure with fields: LastName, FirstName,
%   Email, CourseID, SectionNumber
%
%
% OUTPUTS:
%   linkedTable - Matlab table structure with the following fields:
%   CourseID, LastName, FirstName, GoogleTag, SectionNumber, PartName,
%   Score, CodeScore, CodeFeedback, HeaderScore, HeaderFeedback,
%   CommentScore, CommentFeedback, Email.
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

% Add on pertinent fields to roster table from graded submissions table
m = size(rosterTable,1);

rosterTable.PartName = cell(m,1);
rosterTable.GoogleTag = cell(m,1);
rosterTable.CodeScore = zeros(m,1);
rosterTable.CodeFeedback = cell(m,1);
rosterTable.HeaderScore = zeros(m,1);
rosterTable.HeaderFeedback = cell(m,1);
rosterTable.CommentScore = zeros(m,1);
rosterTable.CommentFeedback = cell(m,1);
rosterTable.Late = zeros(m,1);
rosterTable.file = cell(m,1);

% Go through each submission table
for i = 1:n
    
    r = 0; % set working index to zero
    match = 0; % set match flag
    
    % Go through each row in the roster table
    for j = 1:size(rosterTable,1)
        
        % if the course ID's match, then assign all student info and
        % grading info to the linked table
        if submissionsTable.CourseID(i) == rosterTable.CourseID(j)
            match = 1;
            
            % working index is current roster index
            r = j;

            break;
            
        end
        
    end % roster loop
    
    % If no match was found
    if match == 0
        % working index is one past the end
        r = size(rosterTable.CourseID,1) + 1;
    end
    
    % assign the info based on the working index
    rosterTable.CourseID(r) = submissionsTable.CourseID(i);
    rosterTable.PartName{r} = submissionsTable.PartName{i};
    rosterTable.GoogleTag{r} = submissionsTable.GoogleTag{i};
    rosterTable.CodeScore(r) = submissionsTable.CodeScore(i);
    rosterTable.CodeFeedback{r} = submissionsTable.CodeFeedback{i};
    rosterTable.HeaderScore(r) = submissionsTable.HeaderScore(i);
    rosterTable.HeaderFeedback{r} = submissionsTable.HeaderFeedback{i};
    rosterTable.CommentScore(r) = submissionsTable.CommentScore(i);
    rosterTable.CommentFeedback{r} = submissionsTable.CommentFeedback{i};
    rosterTable.file{r} = submissionsTable.file{i};
    
end % student loop

linkedTable = rosterTable;

% end of function
end