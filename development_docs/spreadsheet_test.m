% Purpose: To test whether spreadsheet formulas can be written out to cells
% using MATLAB
% 5/15/18 Confirmed to work on both LibreCalc and Microsoft Excel

F = '= A2 + A3';

T = table;
T.Test = {1, 2, F}';

writetable(T,'spreadsheet_formula_test.csv');