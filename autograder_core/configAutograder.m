function configAutograder(labNum)
%============================================BEGIN-HEADER=====
% FILE: configAutograder.m
% AUTHOR: Caleb Groves
% DATE: 11 August 2018
%
% PURPOSE:
%   This config function creates globally-scoped variables that will be
%   used throughout the program. It should be extensively commented in
%   order to enable edits corresponding to different semester grading
%   policies and section schedules.
%
% INPUTS:
%   labNum - integer value number of the current lab being graded.
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

%% Part Fields
% These variables control how student data is written out to the .csv's.

global partFields;

% Part Fields
partFields.Front = {'Part','Late','Score','CodeScore','HeaderScore',...
    'CommentScore'};
partFields.Back = {'CodeFeedback','HeaderFeedback','CommentFeedback'};
partFields.pf = length(partFields.Front); % number of fields in front
partFields.pb = length(partFields.Back); % number of fields in back
partFields.p = partFields.pf + partFields.pb; % total number of Lab Part fields
partFields.LateOffset = 1;
partFields.ScoreOffset = 2;
partFields.CodeScoreOffset = 3;
partFields.HeaderScoreOffset = 4;
partFields.CommentScoreOffset = 5;
partFields.CodeFBOffset = 0; % from the back
partFields.HeaderFBOffset = 1;
partFields.CommentFBOffset = 2;

% Student Info Fields
% create lab score field
labScoreField = ['Lab',num2str(labNum),'Score'];

global studentFields;
studentFields.Front = {'CourseID','LastName','FirstName','GoogleTag',...
    'SectionNumber',labScoreField,'FeedbackFlag','FirstDeadline',...
    'FinalDeadline'};
studentFields.Back = {'Email'};
studentFields.lf = length(studentFields.Front);
studentFields.lb = length(studentFields.Back);
studentFields.l = studentFields.lf + studentFields.lb; % total number of student info fields
studentFields.LabScore = 6;
studentFields.FeedbackFlag = 7;
studentFields.FirstDeadline = 8;
studentFields.FinalDeadline = 9;
studentFields.CourseID = 1;
