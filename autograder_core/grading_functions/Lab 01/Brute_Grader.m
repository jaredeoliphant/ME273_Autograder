function [Score, Feedback] = Brute_Grader(filename)

%--------------------------------------------------------------
% FILE: Brute_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 22 Feb 2018
% 
% PURPOSE: Function for grading Lab 6, part 3: Brute force method
%
% INPUTS: 
%   filename - a filename corresponding to a student's code
% 
% 
% OUTPUT: 
%   Score - a scalar between 0 and 1
%   Feedback - a character array of feedback, containing a grades breakdown.
%
% 
% VERSION HISTORY
% V1 - 
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------


% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================| 
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    tol = .01;
    guess = [5 10];
    fh = @RandomFunction01;
    
    
    a = 1.698199531671272;
    b = -8.920997626667857;
    c = 0.246380424071782;
    parameters = struct('a',1.698199531671272,'b',-8.920997626667857,'c',0.246380424071782);
    save('parameters')
    
    Solution_xr = exp(a);
    Solution_yr = 0.055576295844827;
    Solution_n = 46;
  
    
    %================================================   
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_xr,Stud_yr,Stud_n] = ',StudentFunction,'(fh,guess,tol);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    if abs(Stud_xr - Solution_xr) < .1 ...
            && abs(Stud_yr - Solution_yr) < .5 ...
%             && Stud_n < Solution_n + 1 
        Score = 1;
        Feedback = ['Well done! The exact solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
    else
        Score = 1 - abs(Stud_xr - Solution_xr)/5;
        Feedback = ['The exact solution was: xr = ',num2str(Solution_xr),'  yr = ',...
            num2str(Solution_yr),'  n = ',num2str(Solution_n),'.  Your answer was: xr = ',...
            num2str(Stud_xr),'  yr = ',num2str(Stud_yr),'  n = ',num2str(Stud_n)];
        
        if Stud_yr < tol && abs(Stud_xr - Solution_xr) > .1
            Feedback = ['It''s likely that you reintialized the Random_Function_01 inside your function   ',...
                Feedback]
        end
    end
    
    
flag = 0;
    
    %==================================================
    
    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
    Score = 0;      % give score of 0
    flag = 1;
    % An explanation of the zero score and the MATLAB error message. 
    Feedback = regexprep(ERROR.message,'\n',' ');     
    %==============================================================
    
   
    
end

%=======================================================================

try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================| 
    StudentFunction = filename(1:end-2);    % get function name     |
    %=================================================
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    tol = .1;
    guess = [5 5.2];
    fh = @RandomFunction01;
    
    
    a = 1.698199531671272;
    b = -8.920997626667857;
    c = 0.246380424071782;
    parameters = struct('a',1.698199531671272,'b',-8.920997626667857,'c',0.246380424071782);
    save('parameters')
    
    Solution_xr = exp(a);
    Solution_yr = 0.055576295844827;
    Solution_n = 46;
  
    
    %================================================   
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = ['[Stud_xr,Stud_yr,Stud_n] = ',StudentFunction,'(fh,guess,tol);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
   
    
    %==================================================
    
    
    % Their code should have thrown an error, if not
    Score = Score*.9;

    Feedback= [Feedback,'  --  Your code did not throw an error when there was no root on the interval... 10% penalty'];


    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
    %Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message. 
    if flag == 1 || Score == 0
       Feedback= [Feedback,'  --  '];
    else
        Feedback = [Feedback,'  --  Your code threw an error when the guesses were the same sign, as requested.'];     
    end     
    %==============================================================
    
   
    
end

%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE. 
% Note: Final score must between 0 and 1.

    index = Score < 0;     % Checking the bounds of score
    Score(index) = 0;
    index = Score > 1;
    Score(index) = 1;
    % NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================
   
    
end