function L = labSetupFile
%============================================BEGIN-HEADER=====
% FILE: 
% AUTHOR: Caleb Groves
% DATE: 15 August 2018
%
% PURPOSE:
%   This file is used to specify and organize the lab assignments in a way
%   that the rest of the program can interpret them.
%
% INPUTS:
%   - Integers used to identify different LAB ASSIGNMENTS, text used to identify lab subassignments.
%  
%
% OUTPUTS:
%   Returns a LabsList object, which contains all of the pertinent
%   information and functions necessary for the GUI to read in the labs.
%
% ---EXAMPLE:
% Lab 1
% L.addLab(1,datetime(2018,1,26,16,0,0));        % the integer value is used as a unique integer identifier - could be negative or strange numbers for test labs
% The datetime object is a way to specify the lab's default due date: year,
% month, day, hour (24 hour scheme), minute, second.
% L.addLabPart('Newton','Newton_Grader.m'));  % "Newton" is the name of this subassignment. "Netwon_Grader.m" is the name of the grading routine 
% L.addLabPart('Bisect','Bisect_Grader.m');   % Similar as above
% 
% To include assignment-level subfolders by default:
% L.addLabPart('Newton',fullfile('Lab 01','Newton_Grader.m'));  % This approach will bring up the "Lab 01" subfolder in the GUI.
% L.addLabPart('Bisect',fullfile('Lab 01','Bisect_Grader.m'));
%
% NOTES:
%  - THIS FILE DOES NOT NEED TO BE RUN, just saved. 
%
%  - LIMITATIONS: Currently, only five (5) lab subassignments will show up
%   in the GUI (as of v4.0.1); a future implementation should alter
%   AutograderGUI.m in order to display all of the lab subassignments
%   (using a scrollbar or something).
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Create labs list object
L = LabsList();

% Lab 1
L.addLab(1,datetime(2018,9,8,16,0,0));        % the integer value is used as a unique integer identifier - could be negative or strange numbers for test labs
L.addLabPart('Newton',fullfile('Lab 01','Newton_Grader.m'));    % This approach will bring up the "Lab 01" subfolder in the GUI. 
L.addLabPart('Bisect',fullfile('Lab 01','Bisect_Grader.m'));    % ditto

% Lab 4
L.addLab(4,datetime(2018,10,1,16,0,0));        % the integer value is used as a unique integer identifier - could be negative or strange numbers for test labs
L.addLabPart('Trapezoid',fullfile('Lab 04','Trapezoid_Grader.m'));    % This approach will bring up the "Lab 01" subfolder in the GUI. 
L.addLabPart('Simpson13',fullfile('Lab 04','Simpson13_Grader.m'));    % ditto
L.addLabPart('Simpson38',fullfile('Lab 04','Simpson38_Grader.m'));    % ditto

% Lab 9
L.addLab(9,datetime(2018,3,26,16,0,0));
L.addLabPart('Euler',fullfile('Lab 09','Euler_Grader.m'));
L.addLabPart('Heun',fullfile('Lab 09','Heun_Grader.m'));
L.addLabPart('RK4',fullfile('Lab 09','RK4_Grader.m'));

