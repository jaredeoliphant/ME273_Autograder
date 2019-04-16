function submissionsTable = lab_part_grader(currentLab, submissionsTable,...
    graderFile, configVars, regrading, manualGrading, pseudoDate)

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
%   LastName, FirstName, SectionNumber, Email, as well as all previous
%   scores and feedback and blank scores and feedback
%
%   partName - name of the lab part that is currently being graded.
%
%   graderFile - Matlab structure for the grading function file with 2
%   fields: name and path.
%
%   regrading - 0: Original grading mode, 1: Re-grading mode.
%
%   pseudoDate - date and time that the function will assume "now" is.
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
n = size(submissionsTable,1); % get the number of students to grade

grade_dir = 'grading_directory'; % name of grading directory folder

% Add paths of submissions and grading function so that Matlab can find and
% run them when called
addpath(grade_dir);
addpath(graderFile.path);

%% GRADING LOGIC
% Go through submissions table
for i = 1:n
    
    f = submissionsTable.File{i}; % get current student's file
    
    feedbackFlag = -1;
    gradingAction = 0;
    
    % if doing manual grading
    if manualGrading.flag
        % if the current student is being manually graded
        if isstruct(submissionsTable.File{i})
        	% set for copying over
            feedbackFlag = manualGrading.feedbackFlag;
            gradingAction = manualGrading.gradingAction;
        else % otherwise if it's not a manually graded student
            % use manual grading flags
            feedbackFlag = submissionsTable.OldFeedbackFlag(i);
            gradingAction = 2;
        end
    else % otherwise if doing full auto grading
        % use grading logic tree
        % pass in configVars and FirstDeadline to deal with new regrading policy
        [feedbackFlag, gradingAction] = gradingLogic(f,...
            submissionsTable.CurrentDeadline{i}, submissionsTable.OldLate(i),...
            submissionsTable.OldFeedbackFlag(i), submissionsTable.OldScore(i),...
            pseudoDate, regrading, configVars, submissionsTable.FirstDeadline{i});

    end
        

    %% GRADING

    % Do the grading
    if gradingAction == 1 || gradingAction == 3
        % Grade each file:
        filename = f.name; % get current submission's filename

        % Code - call grader function
        eval(['[codeScore, codeFeedback] = ', graderFile.name(1:end-2),...
            '(filename);']);

        % Headers and Comments
        if strcmp(currentLab.language,'MATLAB')
            [headerScore, headerFeedback, commentScore, commentFeedback, ~] = ...
                HeaderCommentGrader_V3(filename);
        else
            [headerScore, headerFeedback, commentScore, commentFeedback, ~] = ...
                HeaderCommentGrader_Cplusplus(filename);
        end
        % Tack on score and feedback for each
        submissionsTable.Score(i) = configVars.weights.code*codeScore + ...
            configVars.weights.header*headerScore + ...
            configVars.weights.comments*commentScore;
        submissionsTable.CodeScore(i) = codeScore;
        submissionsTable.CodeFeedback{i} = codeFeedback;
        submissionsTable.HeaderScore(i) = headerScore;
        submissionsTable.HeaderFeedback{i} = headerFeedback;
        submissionsTable.CommentScore(i) = commentScore;
        submissionsTable.CommentFeedback{i} = commentFeedback;
        
        % set late flag (if applicable)
        if gradingAction == 3
            submissionsTable.Late(i) = 1;
			% added this to make the scores behave properly
            % nowhere in the code (before the dynamic file write out) was
            % the late penalty actually applied to the score....
			% Jared Oliphant 2/8/2019
			if submissionsTable.Score(i) > configVars.weights.latePenalty  % if they would have gotten more than (75%)
				submissionsTable.Score(i) = configVars.weights.latePenalty; 
			end 
        end

    elseif gradingAction == 2 % copy the previously recorded grade

        submissionsTable.Score(i) = submissionsTable.OldScore(i);
        submissionsTable.CodeScore(i) = submissionsTable.OldCodeScore(i);
        submissionsTable.CodeFeedback{i} = submissionsTable.OldCodeFeedback{i};
        submissionsTable.HeaderScore(i) = submissionsTable.OldHeaderScore(i);
        submissionsTable.HeaderFeedback{i} = submissionsTable.OldHeaderFeedback{i};
        submissionsTable.CommentScore(i) = submissionsTable.OldCommentScore(i);
        submissionsTable.CommentFeedback{i} = submissionsTable.OldCommentFeedback{i};
        submissionsTable.Late(i) = submissionsTable.OldLate(i);
        
    elseif gradingAction == 4 || gradingAction == 5
        
        submissionsTable.CodeFeedback{i} = ['No file submission found ',...
            'for this lab part. Please check to make sure that ',...
            'you formatted your filename correctly.'];

    end
    
    % Set feedback flag
    submissionsTable.FeedbackFlag(i) = feedbackFlag;
    
end % end of looping through students

% Remove paths that were added for this function
rmpath(grade_dir);
rmpath(graderFile.path);

% Delete the File field from the table
submissionsTable.File = [];

% end of function
end