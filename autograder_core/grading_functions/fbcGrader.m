function [score, fileFeedback] = fbcGrader(filename)

%--------------------------------------------------------------
% FILE: FBC_Grader.m
% AUTHOR: Douglas Cook 
% DATE: 2/6/2018
% 
% PURPOSE: Function for grading Lab 3, part III: Forward, Backward, and Central difference numerical derivative function.  
% The function uses y = exp(x) with x = [0 0.5 1.0 1.5 2.0] as the solution. The
% solution was obtained from the function DIFF_2087.m.
%
% INPUTS: 
% a filename corresponding to a student's code
% 
% 
% OUTPUT: 
% score - a scalar between 0 and 1
% fileFeedback - a character array of feedback, containing grades breakdown.
%
% 
% VERSION HISTORY
% V1 - This version.
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------

    
    
    try
        % save state in case student runs "clear" in their function
        f = filename(1:end-2); % get function name
        save('gradingvars.mat');

        % Input Data and solution for testing student code
        x = 0:0.5:2;    % x pts.
        y = exp(x);     % y is it's own derivative
        Solution = [3.526814483758038; 2.139121115517835; 2.832967799637936];   % Obtained from the function DIFF_2087.m
        PartNames = {'Forward', 'Backward','Central'};
        feedback1 = char();
        feedback2 = char();
        
        
        % Call student code---------------------------------------------------------- 
        eval(['[F B C] = ',f,'(x,y);'])    % evaluate the function
        load('gradingvars.mat');
        
      
        % GRADING SECTION------------------------------------------------------------
        StudentFBC(1,1:length(F)) = F;
        StudentFBC(2,1:length(B)) = B;    
        StudentFBC(3,1:length(C)) = C;
        index = (StudentFBC == 0);
        StudentFBC(index) = NaN;        % if students are instructed to use NaNs, this should line should be removed.

        % compare all student answers to the Solution
        [minval, mindex] = min((abs((StudentFBC-Solution)./Solution)),[],2);
        
        
        misalignment = 0;
        for j = 1:3         % cycle through the three solutions
       
            if minval(j) > 1, minval(j) = 1; end    % prevents any negative scores, which can occur if the relative error is greater than 100%

            if mindex(j) == 3                               % The solution *should* be in the 3rd column 
                score(j) = round((1 - minval(j))*100);    % If so, the score is directly related to % accuracy
            elseif mindex(j) ~=3 & minval(j) < 0.01        % If not, the solution was misaligned    
                misalignment = 1;                           % misalignment variable set to 1.
                score(j) = round(1 - minval(j))*90;       % the score is 90% of the % accuracy
                
                    if j == 1                               % These are misalignment messages for each j
                        feedback2 = ['Forward, '];    
                    elseif j ==2
                        feedback2 = [feedback2, 'Backward, '];
                    elseif j == 3
                        feedback2 = [feedback2, 'Central, '];
                    end
                    
            else
                perc_err = abs((StudentFBC(j,3)-Solution(j))/Solution(j));   % calculate error based on the value that should have been used
                if perc_err > 1, perc_err = 1; end          % to prevent negative scores, perc_err must be bounded at 1 (100% error)
                score(j) = round((1 - perc_err)*100);     % Otherwise, they just get the closest score (it won't be good). 
                                                            % Note, they should probably just get the score in column 3.    
            end
            
        end
        
        if misalignment == 1
            feedback2 = [feedback2, 'equations coded correctly, but not aligned correctly with x-data. '];
        end
        
        % Feedback on each part
        for j = 1:3  
            feedback1 = [feedback1, PartNames{j},' Score: ',num2str(score(j)),'; '];
        end
        
        fileFeedback = [feedback1, feedback2];      % Form the final feedback string
        score = mean(score)/100;
        
        
        % NORMALIZE THE SCORE (0 <= score <= 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    catch ERR
        % store error messages and zero scores if the code doesn't run.   
        score = 0; % give score of 0
        fileFeedback = regexprep(ERR.message,'\n',' ');
    end
    
end