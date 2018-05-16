%--------------------------------------------------------------
% FILE: parse_ID.m
% AUTHOR: Caleb Groves
% DATE: 1/17/18
% 
% PURPOSE: Parse the name of a student's file submission in order to
% extract the last four digits of their BYU ID.
%
%
% INPUT: String containing the filename to parse.
%
%
% OUTPUT: Last four digits of student's BYU ID, if contained after the
% first underscore in the filename. Otherwise, returns the string 'ERROR'.
%
%
% NOTES: 
%
%--------------------------------------------------------------
function studentID = parse_ID(filename)

    % start going through each letter in the filename
    for i = 1:length(filename)
       
        % check to see if letter is underscore
        if filename(i) == '_'
            studentID = str2num(filename(i+1:i+4));
            return;
        end
    end
    
    % throw ERROR
    error('Invalid ID - unable to parse or convert to number');

end