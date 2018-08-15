function handles = getLabPartPanel(parent, name, graderFile, posy)
%============================================BEGIN-HEADER=====
% FILE: getLabPartHandles.m
% AUTHOR: Caleb Groves
% DATE: 15 August 2018
%
% PURPOSE:
%   Creates a GUI panel for a lab part with file selector options for the
%   grader file and for the submissions folder, as well as default options.
%
% INPUTS:
%   name - name of the lab part.
%
%   graderFileName - name for the grader file.
%
%   graderFilePath - path of the grader file.
%
%
% OUTPUTS:
%   handles - handle to the panel structure.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% panel
handles.panel = uipanel(parent, 'Title', name, 'Position',[.1, posy, ...
    .8, .2]);

% Grader controls
handles.grader.check = uicontrol(handles.panel, 'style', 'checkbox',...
    'String', 'Default', 'Value', 1,'Position',[10 60 100 20]);

handles.grader.text = uicontrol(handles.panel, 'Style', 'text', ...
    'String','Grader Function:','Position',[10 80 200 20], ...
    'horizontalalignment','left');

handles.grader.edit = uicontrol(handles.panel,'style','edit','enable',...
    'off','position',[100 60 200 20],'horizontalalignment','left',...
    'string',fullfile(graderFile.path,graderFile.name));

handles.grader.check.Callback = {@checkControl, handles.grader.edit, ...
    fullfile(graderFile.path,graderFile.name)};

handles.grader.button = uicontrol(handles.panel,'style','pushbutton',...
    'string','..','position',[300 60 30 20],'callback',...
    {@buttonPress, handles.grader, 1});

% Submission controls
default_sub = fullfile('..','dummy');

handles.sub.check = uicontrol(handles.panel, 'style', 'checkbox',...
    'String', 'None', 'Value', 0,'Position',[10 15 100 20]);

handles.sub.text = uicontrol(handles.panel, 'Style', 'text', ...
    'String','Submissions Folder:','Position',[10 35 200 20], ...
    'horizontalalignment','left');

handles.sub.edit = uicontrol(handles.panel,'style','edit','enable',...
    'on','position',[100 15 200 20],'horizontalalignment','left');

handles.sub.check.Callback = {@checkControl, handles.sub.edit, default_sub};

handles.sub.button = uicontrol(handles.panel,'style','pushbutton',...
    'string','..','position',[300 15 30 20],'callback',{@buttonPress, ...
    handles.sub, 2});

end

function buttonPress(~, ~, handles, type)

% uncheck None box
handles.check.Value = 0;
% enable line edit box
handles.edit.Enable = 'on';

if type == 1 % grader
    [filename, path] = uigetfile('*.m'); % get grader file
    handles.edit.String = fullfile(path,filename);
elseif type == 2 % submissions folder
    handles.edit.String = uigetdir(); % get submissions dir
end
    
end

function checkControl(hObject, ~, edit, default)

if hObject.Value == 1
    edit.Enable = 'off';
    edit.String = default;
else
    edit.Enable = 'on';
    edit.String = '';
end

end