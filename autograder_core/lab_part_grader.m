function submissionsTable = lab_part_grader(submissionsTable, partName,...
    graderFile, dueDate, weights, regrading, varargin)

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
%   partName - name of the lab part that is currently being graded.
%
%   dueDate - datetime structure for the first day the assignment is due
%   for the first (chronological) lab section.
%
%   graderFile - Matlab structure for the grading function file with 2
%   fields: name and path.
%
%   weights - Matlab structure with fields <code>, <header>, <comments>,
%   whose values add up to 1.0, representing grading weights given to each
%   part.
%
%   regrading - 0: Original grading mode, 1: Re-grading mode
%
%   varargin{1} - structure containings fields <name> and <path> for
%   previously graded file.
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
% Deal with variable inputs
% number of normal inputs
NORM_IN = 5;
firstGrading = 1;

if nargin == NORM_IN + 1
    firstGrading = 0;
end

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

% If not doing first grading, get a table for this lab part's submissions
% from the already graded file
prevGraded = table;

if ~firstGrading
    varargin{1} = gradedFile;
    % get the table
    prevGraded = getPrevGrading(partName, gradedFile, weights);
end

% Go through submissions table
for i = 1:n
    
    gradeSub = 0;
    copyGrade = 0;
    
    % Point to the current student's file
    f = submissionsTable.File{i};
    % Get this student's due dates
    [firstDeadline, finalDeadline] = adjustedDateRange(...
        submissionsTable.SectionNumber(i), dueDate);
    
    % Check to make sure the student submitted a file
    if class(f) == 'struct'
    
        % Grading Logic:
    
        % If this IS the first grading
        if firstGrading
            % If the submission is before the first deadline
            if f.date <= firstDeadline
                % Mark this new submission for grading
                gradeSub = 1;
            else
                break;
            end
            
        else % If this is not the first grading
            
            % Find the matching student in the prevGraded table
            r = 0; % working index

            for j = 1:size(prevGraded,1) % search through previously graded table
                if prevGraded.CourseID(i) == submissionsTable.CourseID(i) % match
                    r = j; % assign current index to working index
                    break; % leave loop
                end
            end

            % If you can find him/her
            if r ~= 0

                % If we're re-grading
                if regrading

                    % If Re-grading Criteria are met
                    if prevGraded.Score(i) < .80 && (f.date > firstDeadline ...
                            && f.date <= finalDeadline)

                        gradeSub = 1; % mark for grading and late
                        submissionsTable.Late(i) = 1;

                    else % if re-grading criteria are not met
                        % copy over old score and feedback
                        copyGrade = 1;
                    end

                else % If we're NOT re-grading, but this is not a first grading run

                    % Check original grading criteria
                    if prevGraded.Score == 0 && (f.date < firstDeadline)
                        gradeSub = 1;
                    else % if original grading criteria are not met
                        copyGrade = 1;
                    end
                end

            else % No match found between prevGraded and current submission
                gradeSub = 1;
            end
        end 

        % Do the grading
        if gradeSub
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
            
        elseif copyGrade % copy the previously recorded grade
            
            submissionsTable.CodeScore(i) = prevGraded.CodeScore(i);
            submissionsTable.CodeFeedback{i} = prevGraded.CodeFeedback{i};
            submissionsTable.HeaderScore(i) = prevGraded.HeaderScore(i);
            submissionsTable.HeaderFeedback{i} = prevGraded.HeaderFeedback{i};
            submissionsTable.CommentScore(i) = prevGraded.CommentScore(i);
            submissionsTable.CommentFeedback{i} = prevGraded.CommentFeedback{i};
            submissionsTable.GradingError(i) = prevGraded.GradingError(i);
            
        end
    
end % end of looping through students

% Remove paths that were added for this function
rmpath(grade_dir);
rmpath(graderFile.path);

% Delete the File field from the table
submissionsTable.File = [];

% end of function
end