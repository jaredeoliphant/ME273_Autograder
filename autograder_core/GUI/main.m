%============================================BEGIN-HEADER=====
% FILE: main.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:
%   This script creates a GUI that allows you to control the autograder
%   functions.
%
% INPUTS:
%   None, though it does read in the ___
%
%
% OUTPUTS:
%   None, though it will write out several files.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
close all;
clear;
clc;

addpath ..

%% Main Window

gui.fig = figure('Visible','off','NumberTitle','off','Name','ME273 Autograder',...
    'Position',[250 124 900 650],'Resize','on');

%% Overall Lab Settings
settings.panel = uipanel(gui.fig, 'Title', 'Lab Settings', ...
    'Position',[0 0 .5 1]);

% Lab selection
settings.select_lab.panel = uipanel(settings.panel, 'Title', 'Select Lab',...
    'Position',[.1 .85 .8 .1]);

settings.select_lab.box = uicontrol(settings.select_lab.panel, 'Style', ...
    'popup', 'String', (1:9)', 'Units', 'Normalized',...
    'Position', [0.5 0.1 0.3 0.8]);

settings.select_lab.text = uicontrol(settings.select_lab.panel, 'Style',...
    'text', 'String', 'Lab Number:', 'Units', 'Normalized', ...
    'Position', [0.1 0.05 0.3 0.8]);

% Due Date
settings.due_date = guiDatePicker(settings.panel, 'Monday Due Date', ...
    .1, .75, datetime(2018,4,2,16,0,0));

settings.pseudo_date = guiDatePicker(settings.panel, 'Psuedo Date', ...
    .1, .65, datetime(datestr(now)));

%% Lab Part Settings
gui.lab_parts.panel = uipanel(gui.fig, 'Title', 'Lab Parts', ...
    'Position', [.5 0 .5 1]);

%% Show figure
gui.fig.Visible = 'on';

rmpath ..