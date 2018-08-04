function [labPath, prevGraded] = getOrCreateLabRecord(labNum)
%============================================BEGIN-HEADER=====
% FILE: getOrCreateLabRecord.m
% AUTHOR: Caleb Groves
% DATE: 14 July 2018
%
% PURPOSE:
%   This function is meant to manage the file structures for the lab
%   specified. It will create directories and return the most recently
%   altered file corresponding to this lab, if it can find it.
%
% INPUTS:
%   labNum - integer for lab number
%
%
% OUTPUTS:
%   labPath - path to lab files
%   
%   prevGraded - most recent file found in graded lab directory; if no file
%   is found, returns character string 'none'. If file is found, the output
%   is a structure with fields <name> and <path> for the file.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
% Construct lab path
labFolder = ['Lab',num2str(labNum),'Graded'];
labPath = fullfile('graded_labs',labFolder,'Archived');
% if not, make it
if ~exist(labPath,'dir')
    mkdir(labPath); % make lab path
    prevGraded = 'none'; % list recent file as none
    return; % exit function
end

% Get a list of .csv files in path
files = dir(fullfile(labPath,'*.csv'));

if isempty(files)
    prevGraded = 'none';
    return;
end

recentFile = files(1);

if length(files) > 1
    for i = 2:length(files)
        if datetime(files(i).date) > datetime(recentFile.date)
            recentFile = files(i);
        end
    end
end

prevGraded.name = recentFile.name;
prevGraded.path = recentFile.folder;

end % end of function