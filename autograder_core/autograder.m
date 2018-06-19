function autograder(labNum, roster, weights, labParts)
%============================================BEGIN-HEADER=====
% FILE: autograder.m
% AUTHOR: Caleb Groves
% DATE: 6 June 2018
%
% PURPOSE:
%   Ties together the grading of multiple lab parts and the overall grading
%   of the lab.
%
% INPUTS:
%   labNum - integer representing number for this lab
%
%   roster - structure containing two fields (name, path) for the .csv of
%   the class roster to link submissions to.
%
%   weights - structure with fields code, header, and comments, whose
%   values add up to 1. Used in calculating lab part grades.
%
%   labParts - cell array of structs with the following fields: name
%   (character array), dueDate (datetime object), submissionsDir (character
%   string), graderfile (structure with fields name, path as character
%   arrays)
%
%
% OUTPUTS:
%   None - writes out completed grades as .csv file
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

n = length(labParts);
partTables = cell(n,1);

% For each lab part
for i = 1:length(labParts)
    
    % Do in-file prep
    submissions = in_file_prep(labParts{i}.submissionsDir,labParts{i}.name);
    
    % Link the students to the submissions
    linked = roster_linker(submissions, roster);
    
    % do lab part grading
    graded = lab_part_grader(linked, labParts{i}.graderfile, ...
        labParts{i}.dueDate);
    
    partTables{i} = graded; % store graded lab
    
end

% compile all lab grades into one
master = lab_grader(labNum,partTables,weights);

% write out master table as a .csv to graded_labs dir
labGradesDir = 'graded_labs';

% make dir if it doesn't exist
if ~exist(labGradesDir,'dir')
    mkdir(labGradesDir);
end

% write out table as .csv with datetime integer interpretation appended to
% the end
writetable(master,fullfile(labGradesDir,['Lab',num2str(labNum),'Graded',...
    datestr(now,'(dd-mm-yyyy HH-MM)'),'.csv']));

end % end of function