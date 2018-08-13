function gradesTable = dynamicToStatic(gradesTable)
%============================================BEGIN-HEADER=====
% FILE: dynamicToStatic.m
% AUTHOR: Caleb Groves
% DATE: 13 August 2018
%
% PURPOSE:
%   Converts a dynamic grades table to a static one.
%
% INPUTS:
%   Grades table.
%
%
% OUTPUTS:
%   Grades table (with scores set to be static).
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
global weights;

% re-write the lab part scores
n = size(gradesTable,2); % get number of columns
p = (n - studentFields.l)/partFields.p; % get number of lab parts for this lab

for i = 1:size(gradesTable,1) % for each student
    a = zeros(n,1);
    
    for j = 1:p % for each lab part
        % get column for lab part score
        c = studentFields.lf + 1 + partFields.ScoreOffset + (j-1)*partFields.pf;
        gradesTable{i,c} = weights.code*gradesTable{i,c+1} + ...
            weights.header*gradesTable{i,c+2} + ...
            weights.comments*gradesTable{i,c+3};
        
        if gradesTable{i,c-1} == 1 && gradesTable{i,c} > 0.8% if marked as late
            gradesTable{i,c} = 0.8; % haircut policy
        end
        
        a(j) = c; % store score reference for overall lab score later
    end
    
    % re-write the lab score
    gradesTable{i,studentFields.LabScore} = sum(gradesTable{i,a})/n;
end