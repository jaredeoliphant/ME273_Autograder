%============================================BEGIN-HEADER=====
% FILE: adjustedDateRange.m
% AUTHOR: Caleb Groves
% DATE: 6 July 2018
%
% PURPOSE:
%   This function returns the first as well as the final deadline for a
%   student based on his/her section number and the due date for the first
%   (chronological) section.
%
% INPUTS:
%   section - the integer section number of the student concerned.
%
%   dueDate - Matlab datetime object with the first deadline for the first
%   (chronological) section (i.e. if there are sections M, T, W, Th, F, it
%   would be the Monday section's first deadline).
%
% OUTPUTS: This function will produce Matlab datetime objects.
%   firstDeadline - the deadline for first (full-credit) submissions.
%
%   finalDeadline - the final deadline to receive any credit.
%
%
% NOTES:
%   The finalDeadline is calculated by adding 7 days to the firstDeadline
%   day. All assignments are due at 4:00 pm (1600 hrs).
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

function [firstDeadline, finalDeadline] = adjustedDateRange(section,...
    dueDate)

    % get assignment due date    
    firstDeadline = dueDate; % initialize adjusted due date
    
    % find adjusted due date
    switch section
        case 1 % Tuesday lab
            firstDeadline = dueDate + 1;
        case 2 % Wed. lab
            firstDeadline = dueDate + 2;
        case 3 % Thurs. lab
            firstDeadline = dueDate + 3;
        case 4 % Fri. lab
            firstDeadline = dueDate + 4;
        case 5 % Mon. lab
            firstDeadline = dueDate + 0;
        otherwise
            error('Unrecognized section number passed in.');
    end
    
    % Calculate final deadline for resubmissions
    finalDeadline = firstDeadline + 7;
            
end