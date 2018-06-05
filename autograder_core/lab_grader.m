%function lab_grader(partTables, weights)
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

% get number of lab parts coming in
n = length(partTables);

% Part Fields
partFields.Front = {'Part','Late','Score','CodeScore','HeaderScore','CommentScore'};
partFields.Back = {'CodeFeedback','HeaderFeedback','CommentFeedback'};
pf = length(partFields.Front); % number of fields in front
pb = length(partFields.Back); % number of fields in back
p = pf + pb; % total number of Lab Part fields

% Student Info Fields
studentFields.Front = {'CourseID','LastName','FirstName','GoogleTag','SectionNumber'};
studentFields.Back = {'Email'};
lf = length(studentFields.Front);
lb = length(studentFields.Back);
l = lf + lb; % total number of student info fields

t = n*p + l; % calculate total number of columns in masterArray
% allocate the master table size
masterArray = cell(1,t);

% Create the headers for the master table
% Student info Headers
masterArray(1:lf) = studentFields.Front;
masterArray((end-lb+1):end) = studentFields.Back;

% For each lab part
for i = 1:n
    % get starting index
    s = l + (i-1)*pf;
    
    partName = partTables{i}.PartName; % get lab part name
    
    % Append Beginning Fields
    for j = 1:pf
        
        masterArray{j + s - 1} = [partName,partFields.Front{j}];
        
    end
    
    % Append Backend fields
    s = t - (n - i + 1)*pb;
    
    for j = 1:pb
        
        masterArray{j + s - 1} = [partName,partFields.Back{j}];
        
    end
    
    
end % next lab part

% Go through each partTable submission by submission
for i = 1:n
    part = partTables{i}; % get reference to current part Table
    
    % for each submission in the lab part table
    for j = 1:length(part.CourseID)
        
        r = 0; % initialize index
        
        % if this is the first table
        if i == 1
            % set the working index to the part table index + 1 (to account
            % for the masterArray headers)
            r = j + 1;
        else
            % search through masterArray to look for a matching course ID
            match = 0; % initialize match flag
            
            for k = 2:size(masterArray,1)
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
            
            % add in student info to working index row
            masterArray{r,1} = part.CourseID(j);
            masterArray{r,2} = part.LastName{j};
            masterArray{r,3} = part.FirstName{j};
            masterArray{r,4} = part.GoogleTag{j};
            masterArray{r,5} = part.SectionNumber(j);
            masterArray{r,end} = part.Email{j};
        end
        
        % using the working index, make add in all of the appropriate
        % grading information for this lab part
        % Front Fields (Grades)
        s = l + (i-1)*pf; % get starting column for front fields
        masterArray{r,s} = part.PartName{j};
        masterArray{r,s+1} = part.Score{j};
        masterArray{r,s+2} = part.CodeScore(j);
        masterArray{r,s+3} = part.HeaderScore(j);
        masterArray{r,s+4} = part.CommentScore(j);
        
        s = t - (n - i + 1)*pb; % get starting col for back fields
        masterArray{r,s} = part.CodeFeedback{j};
        masterArray{r,s+1} = part.HeaderFeedback{j};
        masterArray{r,s+2} = part.CommentFeedback{j};
    end % end looping through each submission in this lab part
end % end looping through each lab part

%end % end of function