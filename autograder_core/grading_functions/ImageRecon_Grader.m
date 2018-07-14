 function [Score, Feedback] = ImageRecon_Grader(filename)

%--------------------------------------------------------------
% FILE: ImageRecon_Grader.m 
% AUTHOR: Jared Oliphant
% DATE: 12 March 2018
% 
% PURPOSE: Function for grading Lab 8, part 2: Image decryption section
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
    StudentFunction = filename(1:end-2);   % get function name     |
    filetext = fileread(filename);         % get the function as a string to check for text inside
    load('system7.mat')                    % load up the encrypted image

    %=================================================|
    
    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE
    tic
    Solution(:,:,1) = A\B1;
    Solution(:,:,2) = A\B2;
    Solution(:,:,3) = A\B3; 
    solutiontime = toc;
    %================================================
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    close all
    tic
    CallingString = ['[Student_I] = ',StudentFunction,'(A,B1,B2,B3);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    studenttime = toc;
    %================================================================================
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    
    %check the student versus the solution
    if norm(Student_I(:,:,1)-Solution(:,:,1)) < 0.1 && ...
            norm(Student_I(:,:,2)-Solution(:,:,2)) < 0.1 && ...
            norm(Student_I(:,:,3)-Solution(:,:,3)) < 0.1
        Score1 = 1;
        Feedback = 'Your [I] array matched the solution perfectly, well done!   ';
    else
        Score1 = .5;
        Feedback = ['Your [I] array did not match the solution, review the lab handout.   ',num2str(norm(Student_I(:,:,1)-Solution(:,:,1))),'   ',num2str(norm(Student_I(:,:,2)-Solution(:,:,2))),'   ',num2str(norm(Student_I(:,:,3)-Solution(:,:,3)))];
    end
    
    
    %score them based on solution time
    if studenttime <= solutiontime
        Score2 = 1;                     %the student beat the solution time
    else
        Score2 = 1-.01*abs(studenttime - solutiontime);   %relative score based on time 
    end
    
    
    %check to see if any of the solver expressions are present in the function
    use_linsolve = ~isempty(regexp(filetext,'[^\n]*linsolve[^\n]*', 'once'));
    use_rref = ~isempty(regexp(filetext,'[^\n]*rref[^\n]*', 'once'));
    use_inverse = ~isempty(regexp(filetext,'[^\n]*inv[^\n]*', 'once'));
    use_forloop = ~isempty(regexp(filetext,'\nfor\s[^\n]*','once'));

    
    %give feedback according to predicted time based on what method was
    %used
    if use_linsolve == 1
        Feedback = [Feedback,'--- Timing: Grader solution time: ',num2str(solutiontime),'  Your solution time: ',num2str(studenttime),'  ---   Your Image Reconstruction function used linsolve() to solve each linear system. In general, this method is fastest ONLY if we know something about the matrix to be solved and can pass in solver options. In this case, mldivide() or A\b would be faster.'];
    elseif use_inverse == 1
        Feedback = [Feedback,'--- Timing: Grader solution time: ',num2str(solutiontime),'  Your solution time: ',num2str(studenttime),'  ---   Your Image Reconstruction function used inv(A)*b to solve each linear system. To achieve faster solution times, mldivide() or A\b should be used.'];
    elseif use_rref == 1
        Feedback = [Feedback,'--- Timing: Grader solution time: ',num2str(solutiontime),'  Your solution time: ',num2str(studenttime),'  ---   Your Image Reconstruction function used rref to solve each linear system, which is the slowest solver technique. To achieve faster solution times, mldivide() or A\b should be used.'];
    else
        Feedback = [Feedback,'--- Timing: Grader solution time: ',num2str(solutiontime),'  Your solution time: ',num2str(studenttime),'  ---   Your Image Reconstruction function likely used mldivide() or A\b to solve each linear system, which is an adequately fast solver technique. Good job!!'];
    end
    
    if use_forloop == 1 
        Feedback = [Feedback,'   --- It also looks like you utilized a for loop instead of vectorization. If you vectorize you should notice a marked performance increase.'];
    end
    

%     %==================================================
%     
%     
% %====================================================================================
% % ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
%     
%     %==============================================================
% %     % Zero score if the code doesn't run:   
    if ~isempty(regexp(filetext,'[^\n]*decomposition[^\n]*', 'once')) == 0  % decomposition() function only included in MATLAB 2017b
        Score1 = 0;      % give score of 0
        Score2 = 0;      % give score of 0
    %     % An explanation of the zero score and the MATLAB error message. 
        Feedback = regexprep(ERROR.message,'\n',' ');     
    else 
        Score1 = 1;
        Score2 = 1;
        Feedback = 'Used decomposition function';
    end

%     %==============================================================
%     
%    
    
 end


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE. 
% Note: Final score must between 0 and 1.

    Score = (3*Score1+Score2)/4;   %weighted average

    index = Score < 0;     % Checking the bounds of score
    Score(index) = 0;
    index = Score > 1;
    Score(index) = 1;
    % NORMALIZE THE SCORE (0 <= score <= 1)
%
%========================================================================
    
end