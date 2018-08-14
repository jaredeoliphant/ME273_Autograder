function [labPath, archivesPath, fileOut] = ...
    getOrCreateLabRecord(labNum, configVars)
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
labPath = fullfile('graded_labs',labFolder);
archivesPath = fullfile('graded_labs',labFolder,'Archives');

% if not, make it
if ~exist(archivesPath,'dir')
    mkdir(archivesPath); % make lab path
    fileOut = 'none'; % list recent file as none
    return; % exit function
end

% Get a list of .csv files in Archives
static_csvs = dir(fullfile(archivesPath,'*.csv'));

% Get the current editable .csv
dynamic_csv = dir(fullfile(labPath,'Lab',num2str(labNum),...
    'Graded_Current.csv'));

% if there are no files in Archives, leave this function
if isempty(static_csvs) && isempty(dynamic_csv)
    fileOut = 'none';
    return;
elseif ~isempty(dynamic_csv) % if there is a dynamic file
    
    % if there's more than one match
    if length(dynamic_csv) > 1
        % throw an error
        error(['Multiple dynamic .csv files detected;',...
            ' delete one and then re-run.']);
    end
    
    % read in the current_csv to a table
    dynamicTable = readtable(fullfile(dynamic_csv.folder,dynamic_csv.name));
    % convert dynamic to static
    % assign to prevGraded
    prevGraded = dynamicToStatic(dynamicTable, configVars);
    
    if ~isempty(static_csvs) % if there are static files
        
        % get the most recent static
        mostRecentStatic = getMostRecentStatic(static_csvs);
        % run the comparison between the current and archived .csv's and
        % log the changes
        logManualChanges(prevGraded, mostRecentStatic);
    end
    
    % archive a copy of the current_csv (static)
    filename = ['Lab',num2str(labNum),'Graded',datestr(now, ...
        '(yyyy-mm-dd HH-MM-SS)'),'.csv'];
    writetable(dynamicTable,fullfile(archivesPath, filename));
    
elseif isempty(dynamic_csv) && ~isempty(static_csvs)
    
    % get the most recent archived static file
    % use that as prevGraded
    prevGraded = getMostRecentStatic(static_csvs);
end

% set the prevGraded file name and path
fileOut.name = prevGraded.name;
fileOut.path = prevGraded.folder;

end % end of function

% Helper function - Get the most recent file
function recentFile = getMostRecentStatic(files)

    % Find the most recent file
    recentFile = files(1); % assume it's the first one

    if length(files) > 1 % if the list is greater than one
        for i = 2:length(files) % compare dates between current assumed file and the next
            if datetime(files(i).date) > datetime(recentFile.date) 
                recentFile = files(i); % choose the newest one
            end
        end
    end
    
end