% Test script for checking the functionality of lab_grader.m function in
% creating the right table.

clear;

PartName = {'Euler','Newton','Pascal'};

partTables = cell(length(PartName),1);

for i = 1:length(PartName)
    partTables{i} = table;
    partTables{i}.PartName = PartName{i};
end