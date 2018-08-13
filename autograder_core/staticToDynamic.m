function gradesTable = staticToDynamic(gradesTable)
%============================================BEGIN-HEADER=====
% FILE: staticToDynamic.m
% AUTHOR: Caleb Groves
% DATE: 11 August 2018
%
% PURPOSE:
%   To convert a gradesTable to a dynamic one, ready to write out.
%
% INPUTS:
%   gradesTable - a table structure with static grade calculations.
%
%
% OUTPUTS:
%   gradesTable - a table structure with dynamic grade calculations
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

global partFields;
global studentFields;

% re-write the lab part scores
n = size(gradesTable,2); % get number of columns
p = (n - studentFields.l)/partFields.p; % get number of lab parts for this lab

for i = 1:size(gradesTable,1) % for each student
    for j = 1:p % for each lab part
        c = studentFields.lf + 1 + partFields.ScoreOffset + (j-1)*partFields.pf;
        gradesTable{i,c} = get_lab_part_score();
    end
    
    % re-write the lab score
    gradesTable{i,studentFields.LabScore} = calculate_lab_score(n);
end
        