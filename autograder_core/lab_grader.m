function masterTable = lab_grader(labNum, partTables, weights)
%============================================BEGIN-HEADER=====
% FILE: lab_grader.m
% AUTHOR: Caleb Groves
% DATE: 4 June 2018
%
% PURPOSE:
%   This takes the graded submissionTables produced by multiple runs of the
%   function out_file_prep.m and combines them together into a master table
%   that is returned and written out as a .csv file.
%
% INPUTS:
%   partTables - cell array of multiple submissionsTables from
%   out_file_prep.m
%
%
% OUTPUTS:
%   masterTable - table with student info at the front, then each lab
%   part's grade data, then the feedback at the end.
% 
%   weights - structure with fields code, header, and comments, whose
%   values add up to 1. Used in calculating lab part grades.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Check weights
if weights.code + weights.header + weights.comments ~= 1.0
    error('Parameter ''weights'' is not formatted correctly; fields should add up to 1.0');
end

% get number of lab parts coming in
n = length(partTables);

% CREATE LAB TABLE HEADERS AND SETUP COLUMN INFORMATION -----------------

% % Part Fields
global partFields;
% partFields.Front = {'Part','Late','Score','CodeScore','HeaderScore',...
%     'CommentScore'};
% partFields.Back = {'CodeFeedback','HeaderFeedback','CommentFeedback'};
% pf = length(partFields.Front); % number of fields in front
% pb = length(partFields.Back); % number of fields in back
% p = pf + pb; % total number of Lab Part fields
% 
% % Student Info Fields
global studentFields;
% % create lab score field
% labScoreField = ['Lab',num2str(labNum),'Score'];
% 
% studentFields.Front = {'CourseID','LastName','FirstName','GoogleTag',...
%     'SectionNumber',labScoreField,'FeedbackFlag','FirstDeadline',...
%     'FinalDeadline'};
% studentFields.Back = {'Email'};
% lf = length(studentFields.Front);
% lb = length(studentFields.Back);
% l = lf + lb; % total number of student info fields

t = n*partFields.p + studentFields.l; % calculate total number of columns in masterArray

% allocate the master table size
masterArray = cell(1,t);
headers = cell(1,t);

% Create the headers for the master table
% Student info Headers
headers(1:studentFields.lf) = studentFields.Front;
headers((end-studentFields.lb+1):end) = studentFields.Back;

% For each lab part
for i = 1:n
    % get starting index
    s = studentFields.l + (i-1)*partFields.pf;
    
    partName = partTables{i}.PartName{1}; % get lab part name
    
    % Append Beginning Fields
    for j = 1:partFields.pf
        
        headers{j + s - 1} = [partName,partFields.Front{j}];
        
    end
    
    % Append Backend fields
    s = t - (n - i + 1)*partFields.pb;
    
    for j = 1:partFields.pb
        
        headers{j + s - 1} = [partName,partFields.Back{j}];
        
    end
    
    
end % next lab part

% COMPILING LAB GRADES AND FEEDBACK TABLE -------------------------------

% Go through each partTable submission by submission
for i = 1:n
    part = partTables{i}; % get reference to current part Table
    
    % for each submission in the lab part table
    for j = 1:length(part.CourseID)
        
        r = 0; % initialize index
        match = 0; % initialize match flag
        
        % if this is the first table
        if i == 1
            
            % set the working index to the part table index
            r = j;
            
        else
            
            % search through masterArray to look for a matching course ID            
            for k = 1:size(masterArray,1)
                % if found, mark as a match and get the masterArray row #
                if masterArray{k,1} == part.CourseID(j)
                    match = 1; % set match flag
                    r = k; % set working index
                end
            end
            
            % if no match was found
            if match == 0
                % working index is a new row in masterArray
                r = size(masterArray,1) + 1;
            end
            
        end % end finding the working index
        
        % If student info has not already been added
        if match == 0
            % add in student info to working index row
            masterArray{r,1} = part.CourseID(j);
            masterArray{r,2} = part.LastName{j};
            masterArray{r,3} = part.FirstName{j};
            % ! May want to change this next line in the future! Right now,
            % it only adds the GoogleTag for the first lab part; if they
            % didn't submit the first lab part, but did other parts, the
            % GoogleTag won't be added right now. This would be a simple
            % fix, but low priority.
            masterArray{r,4} = part.GoogleTag{j};
            masterArray{r,5} = part.SectionNumber(j);
            masterArray{r,6} = part.Score(j);
            % masterArray{r,6} = calculate_lab_score(n,partFields.pf);
            masterArray{r,7} = 0; % feedback flag: initialize as a zero
            masterArray{r,8} = part.FirstDeadline{j}; % set first deadline
            masterArray{r,9} = part.FinalDeadline{j}; % set final deadline
            masterArray{r,end} = part.Email{j};
        end
        
        % Compose the appropriate feedback flag
        % masterArray{r,7} = part.FeedbackFlag(j) || masterArray{r,7};
        if part.FeedbackFlag(j) == 1 || masterArray{r,7} == 1
            masterArray{r,7} = 1;
        elseif part.FeedbackFlag(j) == 2 || masterArray{r,7} == 2
            masterArray{r,7} = 2;
        else
            masterArray{r,7} = 0;
        end
        
        % using the working index, make add in all of the appropriate
        % grading information for this lab part
        
        % Front Fields (Grades)
        s = l + (i-1)*pf; % get starting column for front fields
        masterArray{r,s} = part.PartName{j};
        masterArray{r,s+1} = part.Late(j);
        masterArray{r, s+2} = part.Score(j);
        %masterArray{r,s+2} = get_lab_part_score(weights,s); % score
        masterArray{r,s+3} = part.CodeScore(j);
        masterArray{r,s+4} = part.HeaderScore(j);
        masterArray{r,s+5} = part.CommentScore(j);
        
        % Backend Fields (feedback)
        s = t - (n - i + 1)*partFields.pb; % get starting col for back fields
        masterArray{r,s} = part.CodeFeedback{j};
        masterArray{r,s+1} = part.HeaderFeedback{j};
        masterArray{r,s+2} = part.CommentFeedback{j};
    end % end looping through each submission in this lab part
end % end looping through each lab part

% convert cell array to table
masterTable = cell2table(masterArray,'VariableNames',headers);

end % end of function