function [HeaderScore, HeaderFeedback, CommentScore, CommentFeedback, error] = HeaderCommentGrader_Cplusplus(filename)
%--------------------------------------------------------------
% FILE: HeaderCommentGrader_Cplusplus.m
% AUTHOR: DC & Jared Oliphant
%
% PURPOSE: adapted from the MATLAB header grader to work for C++ syntax
% files
%
%
% INPUT: filename of the file of interest
%
%
% OUTPUT: A data table, T containing:
%           index - for associating data with files
%           headersum - the number of characters in the header (excludes the % as well as initial and final header lines
%           codelines - number of lines of code
%           commentlines - number of lines of comments
%           commentsum - total number of comment characters
%
% NOTES:
% On grading headers:
%       An empty header template contains 93 characters - 0%
%       A header with minimal effort contains 150 characters - 50%
%       A header with 200 characters: 80%
%       A header with 230 or more characters: 100%
%       Grading Equation: Score = 0.75*n - 70, where n is the number of header
%       characters.
%
% On grading comments:
%       The most robust measure seems to simply be the number of lines with comments
%       divided by the number of lines of code. Anything above 80% gets full credit.
%       Grading Equation: Score = 1.25*r, where r is ratio of comment lines to code lines.
%
% FUTURE IMPROVEMENTS:
%       Make the function adjustable with a few more inputs?
%
% VERSION HISTORY
% V1 - adapted from the MATLAB version to work for C++ (the linux computers
% have an older version of MATLAB that doesn't have 'contains()' so I wrote
% my own 'myContains()' function   -JO
%--------------------------------------------------------------


% DEFAULT OUTPUT VALUES
error = 0;
HeaderScore = NaN;
HeaderFeedback = '';
CommentScore = NaN;
CommentFeedback = '';
error = 0;


try                             % TRY structure used to catch errors

% BUILD THE CONTENT VARIABLE - a cell array containing all of the file's text
f = fopen(filename);        % open the file
test = 1;                   % initialize the test variable
i = 1;                      % initialize i: the variable for which row of the file is being examined
while test == 1             % loop through the lines of the file
    
    tline = fgetl(f);       % get a line of text
    if tline == -1          % if the end of file is reached, BREAK
        break
    elseif length(tline)==0 % loop around if the line contains nothing
        continue
    else
        content{i,1} = strtrim(tline);  % trim out inital and ending space characters
    end
    
    i = i + 1;              % increment i
    
end


% ANALYZE THE TEXT IN THE CONTENT VARIABLE
i = 1;              % initialize variables
header = 0;
headerows = 0;
headersum = 0;
commentsum = 0;
codelines = 0;
commentlines = 0;

% HEADER SECTION
while i <= length(content)      % loop through the lines of "contents"
    
    if length(content{i}) > 2                       % check that this line has at least 3 characters
        
        % if header indicator is 0 (OFF) and the line contains 'BEGIN-HEADER', we are entering the header
        if (header == 0 && myContains(content{i},'BEGIN',1) && myContains(content{i},'HEADER',1))       % CHANGE REQ: This structure is used to avoid the problem of students entering "BEGIN HEADER". Next year this should be a single test for 'BEGIN-HEADER'
            header = 1;                             % turn header indicator ON
            headerows = headerows + 1;              % count header rows
            
            while header == 1                       % loop through header rows
                
                i = i + 1;                          % increment
                if length(content{i}) > 2           % check that the length of this line is at least 3 characters long
                    
                    if (myContains(content{i},'END',1) && myContains(content{i},'HEADER',1))    % if we encounter a line containing 'END' and 'HEADER', we are leaving the header section
                        header = 0;                         % set header indicator to 0 - OFF
                        i = i + 1;                          % increment i
                        break                               % bail out
                    else
                        headersum = headersum + length(content{i});     % sum the number of header characters
                        headerows = headerows + 1;                      % count header rows
                    end
                end
            end
        else            % HEADER section not found
            
        end
    end
    
    % BODY SECTION
    if length(content{i}) > 2       % check that each line has at least 3 characters (otherwise it will be ignored)
        n = length(content{i});     % the number of characters in this line
        comdex = myFind(content{i},'//');     % comdex: the index of the comment character
        if length(comdex)>0  % if comdex is nonempty it will have a length > 0, and thus no comment character was found
            commentsum = commentsum + n-comdex; % number of characters following the //
            commentlines = commentlines + 1;    % number of lines with comments
        end
        
        if length(content{i}) > 3 && ~strcmp(content{i}(1),'/')     % count only lines of code with more than 3 characters and that don't start with a %
            codelines = codelines + 1;                             % increment the codelines variable
        end
        
    end
    i = i + 1;  % increment i
    
    % if the END of the main function is found, we can stop reading
    % their file (i.e. ignore local functions)
    %         if (contains(content{i},'END','IgnoreCase',true) && contains(content{i},'FUNCTION','IgnoreCase',true))
    %             break;
    %         end
end
fclose(f);     % close the file that was opened (saves memory)


if error == 0
    
    
    HeaderScore = 0.75*headersum - 69;      % Equation for converting headersum to a score
    if HeaderScore > 100                    % adjust if it's above 100 or below 0
        HeaderScore = 100;
    elseif HeaderScore < 0
        HeaderScore = 0;
    end
    
    CommentScore = 125*(commentlines/codelines);   % Equation for converting comments info to a score
    if CommentScore > 100                           % adjustments...
        CommentScore = 100;
    elseif CommentScore < 0
        CommentScore = 0;
    end
    
    
    if HeaderScore <= 0
        HeaderFeedback = 'No header found - check your header for keywords: BEGIN-HEADER and END-HEADER';
    elseif 0 < HeaderScore && HeaderScore < 50
        HeaderFeedback = 'Minimal header information present';
    elseif HeaderScore >= 50 && HeaderScore < 80
        HeaderFeedback = 'Marginal header information present';
    elseif HeaderScore >= 80 && HeaderScore <90
        HeaderFeedback = 'Reasonable amount of header information present';
    elseif HeaderScore >= 90 && HeaderScore < 100
        HeaderFeedback = 'Good amount of header information present';
    elseif HeaderScore >= 100
        HeaderFeedback = 'Nice header information';
    end
    
    
    
    if (CommentScore < 50)
        CommentFeedback = 'Minimal comments present';
    elseif (CommentScore >= 50 && CommentScore < 80)
        CommentFeedback = 'Marginal comments present';
    elseif (CommentScore >= 80 && CommentScore < 90)
        CommentFeedback = 'Reasonable amount comments present';
    elseif (CommentScore >=90 && CommentScore < 100)
        CommentFeedback = 'Good amount of comments present';
    elseif (CommentScore >=100)
        CommentFeedback = 'Good commenting!';
    end
    
    CommentScore = CommentScore/100;
    HeaderScore = HeaderScore/100; % normalize for output to grader function
    
    
end




catch ERR
  ERR
  HeaderScore = 0;
  HeaderFeedback = 'check your header and comments, something went wrong';
  CommentScore = 0;
  CommentFeedback = 'check your header and comments, something went wrong';
  error = 1;
end



end



function [result] = myContains(bigString, phrase, ignorecase)
result = 0;
if ignorecase
    phrase = upper(phrase);
    bigString = upper(bigString);
    
    for i = 1:length(bigString)-length(phrase)+1
        if strcmp(phrase,bigString(i:i+length(phrase)-1))
            result = 1;
            return
        end
    end
else
    
    for i = 1:length(bigString)-length(phrase)+1
        if strcmp(phrase,bigString(i:i+length(phrase)-1))
            result = 1;
            return
        end
    end
end



end



function [index] = myFind(bigString, phrase)

index = [];
phrase = upper(phrase);
bigString = upper(bigString);

for i = 1:length(bigString)-length(phrase)+1
    if strcmp(phrase,bigString(i:i+length(phrase)-1))
        index = i;
        return
    end
end

end











