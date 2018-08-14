function gradesTable = dynamicToStatic(gradesTable, configVars)
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

gradesTable = table2cell(gradesTable);

% re-write the lab part scores
n = size(gradesTable,2); % get number of columns
p = (n - configVars.studentFields.l)/configVars.partFields.p; % get number of lab parts for this lab

for i = 1:size(gradesTable,1) % for each student
    a = zeros(n,1);
    
    for j = 1:p % for each lab part
        % get column for lab part score
        c = configVars.studentFields.lf + 1 + configVars.partFields.ScoreOffset + (j-1)*configVars.partFields.pf;
        gradesTable{i,c} = configVars.weights.code*gradesTable{i,c+1} + ...
            configVars.weights.header*gradesTable{i,c+2} + ...
            configVars.weights.comments*gradesTable{i,c+3};
        
        if gradesTable{i,c-1} == 1 && gradesTable{i,c} > 0.8% if marked as late
            gradesTable{i,c} = 0.8; % haircut policy
        end
        
        a(j) = c; % store score reference for overall lab score later
    end
    
    % re-write the lab score
    gradesTable{i,configVars.studentFields.LabScore} = sum(gradesTable{i,a})/n;
end

gradesTable = cell2table(gradesTable);