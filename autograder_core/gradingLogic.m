function [feedbackFlag, gradingAction] = gradingLogic(File, ...
    CurrentDeadline, OldLate, OldFeedbackFlag, OldScore, pseudoDate, ...
    regrading)
%============================================BEGIN-HEADER=====
% FILE: gradingLogic.m
% AUTHOR: Caleb Groves
% DATE: 4 August 2018
%
% PURPOSE:
%   This function embodies the logic to determine whether a particular file
%   is going to be graded, regraded, or whether old scores will be copied
%   over.
%
% INPUTS:
%   File - student's File structure
%   CurrentDeadline - student's current deadline
%   OldLate - late flag copied over from previous grading
%   OldFeedbackFlag - previous feedback flag
%   OldScore - previous score recorded for current lab part
%   pseudoDate - "now" for the program
%   regrading - regrade flag
%
%
% OUTPUTS:
%   gradingAction - integer corresponding to specific grading actions
%   feedbackFlag - new feedback flag to record
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

if pseudoDate < CurrentDeadline
    feedbackFlag = OldFeedbackFlag;
    gradingAction = 2;
    return;
end

if isstruct(File) % filter students that haven't submitted
    if datetime(File.date) <= CurrentDeadline % make sure file was submitted before deadline
        if regrading
            if OldScore < .8 && ~OldLate % if it satisfies the regrading criteria
                gradingAction = 3; % late grading
                feedbackFlag = 1;
            else % if it doesn't satisfy the regrading criteria
                gradingAction = 2;
                feedbackFlag = OldFeedbackFlag;
            end
        else % if the program is not running in regrading mode
            if OldScore == 0 % if there is no score
                gradingAction = 1; % perform original grading
                feedbackFlag = 1;
            else % if there is a pre-existing score
                gradingAction = 2; % copy over the old scores and feedback
                feedbackFlag = OldFeedbackFlag;
            end
        end
        
    else % if the file was submitted after the deadline
        gradingAction = 2; % copy over the old scores and feedback
        feedbackFlag = OldFeedbackFlag;
    end
else % if no file was submitted
    if OldFeedbackFlag == 0
        gradingAction = 4; % no-submit, 1st warning
        feedbackFlag = 1;
    elseif OldFeedbackFlag ~= 0
        gradingAction = 2; % copy over the old scores and feedback
        feedbackFlag = OldFeedbackFlag;
    end
end