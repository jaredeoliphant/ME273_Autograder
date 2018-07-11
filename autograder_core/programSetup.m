function outFile = programSetup(labNum, roster, weights, labParts,...
    regrade, pseudoDate, varargin)
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
%   varargin{1} - Matlab structure with fields <name> and <path> for a
%   previously created lab grades file.
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

% If original grading (no file to read in)
if nargin == 6
    outFile = autograder(labNum, roster, weights, labParts, 0, ...
        pseudoDate); % call without passing in a file
elseif nargin == 7 % if a file is passed in
    outFile = autograder(labNum, roster, weights, labParts, 0, ...
        pseudoDate, varargin{1}); % always do original grading first
end

if regrade % if we're going to grade resubmissions
    outFile = autograder(labNum, roster, weights, labParts, 1, ...
        pseudoDate, outFile); % run in regrading mode with output generated
    % by original grading run, above
end

end % end of function
    