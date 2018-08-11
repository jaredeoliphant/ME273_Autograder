%============================================BEGIN-HEADER=====
% FILE: config.m
% AUTHOR: Caleb Groves
% DATE: 11 August 2018
%
% PURPOSE:
%   This config script creates globally-scoped variables that will be used
%   throughout the program. It should be extensively commented in order to
%   enable edits corresponding to different semester grading policies and
%   section schedules.
%
% INPUTS:
%   N/A
%
%
% OUTPUTS:
%   N/A
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

%% Grading Weights
% weights - a structure with three fields (code, header, comments)
% containing floats that add to 1.0. These are the grading weights of each
% of these items, respectively.
global weights;
weights.code = 0.8;
weights.header = 0.1;
weights.comments = 0.1;

% Catch any errors with the assignment of weights
if weights.code + weights.header + weights.comments ~= 1.0
    error('Fields of variable <weights> must add to 1.0');
end

%% Section Dates
% Structure with fields for the days of the week. The value represents the
% corresponding section number. Used primarily in getSectionDueDates to
% stagger the default due dates for each section; should be updated each
% semester.
global sectionDays;

% set section number to corresponding day of the week
sectionDays.Monday = 5;
sectionDays.Tuesday = 1;
sectionDays.Wednesday = 2;
sectionDays.Thursday = 3;
sectionDays.Friday = 4;