function prevGraded = getPrevGrading(partName, gradedFile, weights)
%============================================BEGIN-HEADER=====
% FILE: getPrevGrading.m
% AUTHOR: Caleb Groves
% DATE: 6 July 2018
%
% PURPOSE:
%   This function reads in a .csv file of a previously graded lab and
%   creates a lab part table with that lab part's grades.
%
% INPUTS:
%   partName - character array with the given name for this lab part.
%
%   gradedFile - Matlab structure with fields <name> and <path> for the
%   .csv of the graded lab.
%
%   weights - Matlab structure with fields <code>, <header>, and <comments>
%   with values that add up to 1.0, representing the grading weights for
%   each of these parts.
%
% OUTPUTS:
%   prevGraded - A Matlab table for this lab part with the following
%   fields: CourseID, Score, CodeScore, CodeFeedback, HeaderScore,
%   HeaderFeedback, CommentScore, CommentFeedback.
%
%
% NOTES:
%   This function depends highly on the ordering of the columns in the
%   graded file's .csv. Any changes to the way the compiled lab parts are
%   put together and written out will need to be changed here, as well.
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Read in the gradedFile as a table
addpath gradedFile.path;
T = readtable(gradedFile.name);

% Convert the table to a cell array
gradedTable = table2cell(T);

% Get the CourseID column

% Go through each column and look for the lab partName match
% Keep that column index when found
% Copy over the columns for code, header, and comment scores and feedback.

% Create a new column for Score, and calculate it for each student using
% the weights structure

% Remove path from graded file
rmpath gradedFile.path;