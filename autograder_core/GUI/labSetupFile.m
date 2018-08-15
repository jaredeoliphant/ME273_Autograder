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
%   
%
%
% OUTPUTS:
%   Returns a LabsList object, which contains all of the pertinent
%   information and functions necessary for the GUI to read in the labs.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% Create labs list object
L = LabsList();

% Lab 9
L.addLab(9);
L.addLabPart('Euler','Euler_Grader.m');
L.addLabPart('Heun','Heun_Grader.m');
L.addLabPart('RK4','RK4_Grader.m');

% Lab 6
L.addLab(6);
L.addLabPart('SixDerivs','SixDerivs_Grader.m');
L.addLabPart('FBC','fbc_grader.m');