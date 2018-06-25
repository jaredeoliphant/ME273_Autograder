function submissionsTable = lab_part_grader(submissionsTable, graderFile, dueDate)

%============================================BEGIN-HEADER=====
% FILE: lab_part_grader.m
% AUTHOR: Caleb Groves
% DATE: 18 May 2018
%
% PURPOSE:
%   To grade the code, headers, and comments of all of the student
%   submissions passed in as a table for a particular assignment, and
%   return a table with all of their scores and feedback assigned to it.
%
% INPUTS:
%   submissionTable - Matlab Table with columns CourseID, File, GoogleTag,
%   LastName, FirstName, SectionNumber, Email
%
%   dueDate - datetime structure for the first day the assignment is due
%   for the first (chronological) lab section.
%
%   graderFile - Matlab structure for the grading function file with 2
%   fields: name and path.
%
%
% OUTPUTS:
%   submissionTable - Matlab table structure containing the following
%   columns:
%   LastName, FirstName, CourseID, SectionNumber, GoogleTag, PartName,
%   Email, CodeScore, CodeFeedback, HeaderScore, HeaderFeedback,
%   CommentScore, CommentFeedback, Late
%
%
% NOTES:
%   If a student has no file linked to his/her lab part, then the Late
%   field gets a 2 assigned to it in order to help differentiate these
%   students from the rest in later steps.
%  
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

n = size(submissionsTable,1); % get the number of students to grade

grade_dir = 'grading_directory'; % name of grading directory folder

% Add paths of submissions and grading function so that Matlab can find and
% run them when called
addpath(grade_dir);
addpath(graderFile.path);

% Add on the appropriate columns for the submission table
submissionsTable.Late = zeros(n,1);
submissionsTable.CodeScore = zeros(n,1);
submissionsTable.CodeFeedback = cell(n,1);
submissionsTable.HeaderScore = zeros(n,1);
submissionsTable.HeaderFeedback = cell(n,1);
submissionsTable.CommentScore = zeros(n,1);
submissionsTable.CommentFeedback = cell(n,1);
submissionsTable.GradingError = zeros(n,1);

% Go through submissions table
for i = 1:n
    
    % Point to the current student's file
    f = submissionsTable.File{i};
    
    % Check to make sure the student submitted a file
    if class(f) == 'struct'
    
        % Grade each file:
        filename = f.name; % get current submission's filename

        % Code - call grader function
        eval(['[codeScore, codeFeedback] = ', graderFile.name(1:end-2),...
            '(filename);']);

        % Headers and Comments
        [headerScore, headerFeedback, commentScore, commentFeedback, error] = ...
            HeaderCommentGrader_V3(filename);

        % Tack on score and feedback for each
        submissionsTable.CodeScore(i) = codeScore;
        submissionsTable.CodeFeedback{i} = codeFeedback;
        submissionsTable.HeaderScore(i) = headerScore;
        submissionsTable.HeaderFeedback{i} = headerFeedback;
        submissionsTable.CommentScore(i) = commentScore;
        submissionsTable.CommentFeedback{i} = commentFeedback;
        submissionsTable.GradingError(i) = error;
        
        % Determine late penalty
        % get adjusted due date
        [~, date2] = adjustedDateRange(submissionsTable.SectionNumber(i),...
            dueDate,0);
    
        % If date of file submission is greater than the adjusted due date
        if f.date > date2
            % mark the submission late
            submissionsTable.Late(i) = 1;
        end
       
    else % if there is no file for this student
        submissionsTable.Late(i) = 2; % mark Late as 2 in order to differentiate        
    end
    
end % end of looping through students

% Remove paths that were added for this function
rmpath(grade_dir);
rmpath(graderFile.path);

% Delete the File field from the table
submissionsTable.File = [];

% end of function
end