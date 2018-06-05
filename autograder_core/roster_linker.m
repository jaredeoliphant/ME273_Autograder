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
% submissionsTable.LastName = cell(n,1);
% submissionsTable.FirstName = cell(n,1);
% submissionsTable.Email = cell(n,1);
% submissionsTable.SectionNumber = zeros(n,1);
submissionsTable.matched = zeros(n,1);

% Add on pertinent fields to roster table from graded submissions table
m = size(rosterTable,1);

rosterTable.Assignment = cell(m,1);
rosterTable.fileName = cell(m,1);
rosterTable.CodeScore = zeros(m,1);
rosterTable.CodeFeedback = cell(m,1);
rosterTable.HeaderScore = zeros(m,1);
rosterTable.HeaderFeedback = cell(m,1);
rosterTable.CommentScore = zeros(m,1);
rosterTable.CommentFeedback = cell(m,1);
rosterTable.GradingError = zeros(m,1);
rosterTable.FinalScore = cell(m,1);
rosterTable.Late = zeros(m,1);
rosterTable.file = cell(m,1);

% Go through each submission table
for i = 1:n
    
    % Go through each row in the roster table
    for j = 1:size(rosterTable,1)
        
        % if the course ID's match, then assign all student info and
        % grading info to the linked table
        if submissionsTable.ID(i) == rosterTable.CourseID(j)
            
            submissionsTable.matched(i) = 1;
            
            % assign student info to submissions table
%             submissionsTable.LastName{i} = rosterTable.LastName(j);
%             submissionsTable.FirstName{i} = rosterTable.FirstName(j);
%             submissionsTable.Email{i} = rosterTable.Email(j);
%             submissionsTable.SectionNumber(i) = rosterTable.SectionNumber(j);
            rosterTable.Assignment{j} = submissionsTable.Assignment{i};
            rosterTable.fileName{j} = submissionsTable.oldName{i};
            rosterTable.CodeScore(j) = submissionsTable.CodeScore(i);
            rosterTable.CodeFeedback{j} = submissionsTable.CodeFeedback{i};
            rosterTable.HeaderScore(j) = submissionsTable.HeaderScore(i);
            rosterTable.HeaderFeedback{j} = submissionsTable.HeaderFeedback{i};
            rosterTable.CommentScore(j) = submissionsTable.CommentScore(i);
            rosterTable.CommentFeedback{j} = submissionsTable.CommentFeedback{i};
            rosterTable.GradingError(j) = submissionsTable.GradingError(i);
            rosterTable.file{j} = submissionsTable.file{i};

            break;
            
        end
        
    end % roster loop
    
    % If no match was found
    if submissionsTable.matched(i) == 0
        % add on the submission to the end of the roster
        rosterTable.CourseID(end+1) = submissionsTable.ID(i);
        rosterTable.Assignment{end} = submissionsTable.Assignment{i};
        rosterTable.fileName{end} = submissionsTable.oldName{i};
        rosterTable.CodeScore(end) = submissionsTable.CodeScore(i);
        rosterTable.CodeFeedback{end} = submissionsTable.CodeFeedback{i};
        rosterTable.HeaderScore(end) = submissionsTable.HeaderScore(i);
        rosterTable.HeaderFeedback{end} = submissionsTable.HeaderFeedback{i};
        rosterTable.CommentScore(end) = submissionsTable.CommentScore(i);
        rosterTable.CommentFeedback{end} = submissionsTable.CommentFeedback{i};
        rosterTable.GradingError(end) = submissionsTable.GradingError(i);
        rosterTable.file{end} = submissionsTable.file{i};
    end
    
end % student loop

% Create linkedTable
%   linkedTable - Matlab table structure with the following fields:
%   CourseID, LastName, FirstName, Email, SectionNumber, Assignment,
%   CodeScore, CodeFeedback, HeaderScore, HeaderFeedback, CommentScore,
%   CommentFeedback, GradingError.
n = size(rosterTable,1);

linkedTable = table;
linkedTable.CourseID = rosterTable.CourseID; % A
linkedTable.LastName = rosterTable.LastName; % B
linkedTable.FirstName = rosterTable.FirstName; % C
linkedTable.Email = rosterTable.Email; % D
linkedTable.SectionNumber = rosterTable.SectionNumber; % E
linkedTable.Assignment = rosterTable.Assignment; % F
linkedTable.FinalScore = rosterTable.FinalScore; % G
linkedTable.CompositeScore = cell(n,1); % H
linkedTable.Late = rosterTable.Late; % I
linkedTable.CodeScore = rosterTable.CodeScore; % J
linkedTable.CodeFeedback = rosterTable.CodeFeedback; % K
linkedTable.HeaderScore = rosterTable.HeaderScore; % L
linkedTable.HeaderFeedback = rosterTable.HeaderFeedback; % M
linkedTable.CommentScore = rosterTable.CommentScore; % N
linkedTable.CommentFeedback = rosterTable.CommentFeedback; % O
linkedTable.GradingError = rosterTable.GradingError; % P
linkedTable.file = rosterTable.file;
linkedTable.oldName = rosterTable.fileName;

% end of function
end