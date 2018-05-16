function preparedFiles = in_file_prep(sub_dir,assignmentName)

%============================================BEGIN-HEADER=====
% FILE: in_file_prep.m
% AUTHOR: Caleb Groves
% DATE: May 16, 2018
%
% PURPOSE:
%   Prepares a directory of student submissions downloaded from Google
%   Drive to be read as Matlab scripts or functions and graded. 
%
% INPUTS:
%   Directory of the student submissions to be read
%
%
% OUTPUTS:
%   Table with columns as follows:
%   | File ID | prepared file (object) | original filename |
%
%
% NOTES:
%   Removes duplicate submissions, and only keeps the last one. Creates a
%   grading directory. Assigns all files a .m extension (assumes all files
%   are Matlab scripts or functions, and might accidentally have .m~ or
%   .avs extensions).
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

grade_dir = 'grading_directory'; % name of grading directory folder

% Clear the grading directory if it exists, create it if not
if ~exist(grade_dir,'dir')
    mkdir(grade_dir);
end

oldFiles = get_grader_dir(grade_dir);

for i = 1:length(oldFiles)
    delete(fullfile(oldFiles(i).folder,oldFiles(i).name));
end

% Get all files is submission directory with submission tag
subFiles = dir(fullfile(sub_dir,'*_*'));

% Copy the files over to the grading directory
for i = 1:length(subFiles)
    copyfile(fullfile(subFiles(i).folder,subFiles(i).name),grade_dir);
end

% In the grading directory:
% Remove resubmissions - only keep the latest one
resubmits = dir(fullfile(grade_dir,'*(*'));

for i = 1:length(resubmits)
    delete(fullfile(grade_dir,'*(*'));
end

% Rename remaining files and store in preparedFiles table
subFiles = get_grader_dir(grade_dir);
n = length(subFiles);

% make table for prepared files
preparedFiles = table;

% create columns for table data
preparedFiles.ID = nan*ones(n,1);
preparedFiles.file = cell(n,1);
preparedFiles.oldName = cell(n,1);

% store current filename in table
for i = 1:n
    
    % store current file name in table
    preparedFiles.oldName{i} = subFiles(i).name;
    preparedFiles.ID(i) = parse_ID(subFiles(i).name);
    
    % rename the file and store file in table
    preparedFiles.file{i} = rename_file(subFiles(i),assignmentName);
    
end

% end of function
end