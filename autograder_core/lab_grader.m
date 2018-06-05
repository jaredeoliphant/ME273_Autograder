%function lab_grader(partTables)
%============================================BEGIN-HEADER=====
% FILE: lab_grader.m
% AUTHOR: Caleb Groves
% DATE: 4 June 2018
%
% PURPOSE:
%   
%
% INPUTS:
%   
%
%
% OUTPUTS:
%   
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======

% get number of lab parts coming in
n = length(partTables);

% Part Fields: PartName, SubmissionName, Late, Score, CodeScore,
% HeaderScore, CommentScore, CodeFeedback, HeaderFeedback, CommentFeedback.
% Total = 10 fields
% 7 in front, 3 in back
pf = 7; % number of fields in front
pb = 3; % number of fields in back
p = pf + pb; % total number of Lab Part fields

% Student Info Fields: CourseID, GoogleTag, LastName, FirstName, SectionNumber, Email.
% Total = 6 fields. That's 6 fields! Ha, ha, ha.
% 5 in front, 1 in back
studentFields = {'CourseID','GoogleTag','LastName','FirstName','SectionNumber','Email'};
lf = 5;
lb = 1;
l = lf + lb; % total number of student info fields

t = n*p + l; % calculate total number of columns in masterArray

% allocate the master table size
masterArray = cell(1,t);

% Create the headers for the master table
% Student info Headers
masterArray(1:lf) = studentFields(1:lf);
masterArray((end-lb+1):end) = studentFields((end-lb+1):end);

% For each lab part
for i = 1:n
    % get starting index
    s = l + (i-1)*pf;
    
    partName = partTables{i}.PartName; % get lab part name
    
    % Append towards the beginning
    masterArray{s} = partName;
    masterArray{s+1} = [partName, 'GoogleTag'];
    masterArray{s+2} = [partName, 'Late'];
    masterArray{s+3} = [partName, 'Score'];
    masterArray{s+4} = [partName, 'CodeScore'];
    masterArray{s+5} = [partName, 'HeaderScore'];
    masterArray{s+6} = [partName, 'CommentScore'];
    
    % Append to feedback section
    s = s + n*pf - (i)*pb;
    masterArray{s} = [partName, 'CodeFeedback'];
    masterArray{s+1} = [partName, 'HeaderFeedback'];
    masterArray{s+2} = [partName, 'CommentFeedback'];
    
end % next lab part

%end % end of function