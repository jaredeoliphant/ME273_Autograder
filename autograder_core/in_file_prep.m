function preparedFiles = in_file_prep(sub_dir,partName)

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
%   Table with columns CourseID, File, GoogleTag, PartName
%
%
% NOTES:
%   Removes duplicate submissions, and only keeps the last one. Creates a
%   grading directory. Assigns all files a .m extension (assumes all files
%   are Matlab scripts or functions, and might accidentally have .m~ or
%   .avs extensions).
%   For removing duplicate submissions, assumes that the most recent
%   submission is the one WITHOUT parentheses.
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

oldFiles = dir(grade_dir);

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
subFiles = dir(fullfile(grade_dir,'*_*'));
n = length(subFiles);

% make table for prepared files
preparedFiles = table;

% create columns for table data
preparedFiles.CourseID = nan*ones(n,1);
preparedFiles.File = cell(n,1);
preparedFiles.GoogleTag = cell(n,1);

% store current filename in table
for i = 1:n
    
    % store current file name in table
    preparedFiles.GoogleTag{i} = get_Google_tag(subFiles(i).name);
    preparedFiles.CourseID(i) = parseCourseID(subFiles(i).name);
    
    % rename the file and store file in table
    preparedFiles.File{i} = rename_file(subFiles(i),partName);
    
    % store part name as a field
    preparedFiles.PartName{i} = partName;
    
end

% end of function
end

%============================================BEGIN-HEADER=====
% FILE: in_file_prep.m
% AUTHOR: Caleb Groves
% DATE: 5 June 2018
%
% PURPOSE:
%   Parses a filename in order to get the Google username that Google Drive
%   appends to all file uploads.
%
% INPUTS:
%   Character array of filename uploaded to Google Drive.
%
% OUTPUTS:
%   Character array of Google username appended to file submission name
%
%
% NOTES:
%     Function assumes that Google username is separated by a hyphen and
%     then a space, and consists of the rest of the characters until the
%     end of the filename. The function also assumes that there is only 1
%     hyphen in the filename.
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

function googleTag = get_Google_tag(filename)

% initialize the beginning and ending tag indices
ib = 0;
ie = 0;

% cycle through all characters in the filename
for i = 1:length(filename)
    % if the current character is a hyphen
    if strcmp(filename(i),'-')
        ib = i + 2; % take into account the space
    % or if it is a period
    elseif strcmp(filename(i),'.')
        ie = i - 1;
    end
end

% Check for improper filenames
if ib == 0 || ie == 0
    googleTag = 'Unknown';
else
    % extract the Google username tag
    googleTag = filename(ib:ie);
end

end % end function