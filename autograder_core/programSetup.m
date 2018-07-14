function outFile = programSetup(labNum, roster, weights, labParts,...
    regrade, pseudoDate)
%============================================BEGIN-HEADER=====
% FILE: programSetup.m
% AUTHOR: Caleb Groves
% DATE: 11 July 2018
%
% PURPOSE:
%   This function calls the autograder function with the appropriate
%   arguments, based on its own inputs. Its primary function is to make
%   sure that original grading is always done before regrading.
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
%   regrade - 0: original grading, 1: re-grading mode
%
%   pseudoDate - Matlab datetime that the autograder will interpret as
%   "now" (useful for retroactive grading).
%
%
% OUTPUTS:
%   outFile - structure with fields <name> and <path> for the file created
%   from this grading run.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Get most recent file in the path for the lab files
[labPath, prevGraded] = getOrCreateLabRecord(labNum);

% If original grading (no file to read in)
if ischar(prevGraded)
    master = autograder(labNum, roster, weights, labParts, 0, ...
        pseudoDate); % call without passing in a file
elseif isstruct(prevGraded) % if a file is passed in
    master = autograder(labNum, roster, weights, labParts, 0, ...
        pseudoDate, prevGraded); % always do original grading first
end

if regrade % if we're going to grade resubmissions
    master = autograder(labNum, roster, weights, labParts, 1, ...
        pseudoDate, master); % run in regrading mode with output generated
    % by original grading run, above
end

% Write out grades to appropriate folder location
% write out table as .csv with datetime integer interpretation appended to
% the end
outFile.name = ['Lab',num2str(labNum),'Graded',datestr(pseudoDate,...
    '(yyyy-mm-dd HH-MM-SS)'),'.csv'];
outFile.path = labPath;
writetable(master,fullfile(outFile.path,outFile.name));

end % end of function
    