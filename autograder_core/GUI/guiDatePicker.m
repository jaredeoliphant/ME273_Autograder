function handles = guiDatePicker(parent, title, posx, posy, defaultDate)
%============================================BEGIN-HEADER=====
% FILE: guiDatePicker.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:
%   Creates a date picker gui panel with a default check button.
%
% INPUTS:
%   The parent, title, x and y position, and default date (in Matlab
%   datetime) for the date picker panel.
%
%
% OUTPUTS:
%   Handle for the panel.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Panel
handles.panel = uipanel(parent, 'Title', title, 'Position', ...
    [posx posy .8 .1]);

% Text edit box
handles.display = uicontrol(handles.panel, 'Style', 'edit', 'Enable', ...
    'off', 'Units', 'Normalized', 'Position', [0.35 .25 .5 .5]);

% Checkbutton
handles.check_button = uicontrol(handles.panel, 'Style', 'checkbox', ...
    'Units', 'Normalized', 'String', 'Default', ...
    'Position', [.1 0 .3 1], 'Value', 1, 'Callback', ...
    {@changeDate, handles, defaultDate}, 'CreateFcn', ...
    {@changeDate, handles, defaultDate});

end

% Callback function for checkbox
function changeDate(hObject, ~, handles, defaultDate)

% if the check box is checked
if (get(hObject, 'Value') == 1)
    % then date displayed is the default
    handles.display.String = datestr(defaultDate);
else % if it's not checked
    % allow the user to specify
    handles.display.String = datestr(uigetdate(defaultDate));
end

end