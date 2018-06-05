function score_text = get_lab_part_score(weights,r,s)
%============================================BEGIN-HEADER=====
% FILE: 
% AUTHOR: Caleb Groves
% DATE: 5 June 2018
%
% PURPOSE:
%   Write out a string interpretable by spreadsheet programs for
%   calculating the lab part score based on weights for the code, header,
%   and comments.
%
% INPUTS:
%   weights - a Matlab structure with fields: code, header, and comments,
%   whose values add up to 1.0
% 
%   r - integer value of the current spreadsheet row
% 
%   s - integer value of the current lab part starting column
%
%
% OUTPUTS:
%   score_text - character array with references to "cells" in a
%   spreadsheet using the Excel RxCy format.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
% convert row number into character, accounting for headers which will be
% added on later
R = num2str(r+1);

% expression for the score
score = [num2str(weights.code),'*R',R,'C',num2str(s+3),'+',num2str(...
    weights.header),'*R',R,'C',num2str(s+4),'+',num2str(weights.comments)...
    ,'*R',R,'C',num2str(s+5)];

score_text = ['=IF(R',R,'C',num2str(s+1),'=1,IF(',score,'>=0.8,0.8,0.8*',...
    score,'),',score,')'];

end % end of function