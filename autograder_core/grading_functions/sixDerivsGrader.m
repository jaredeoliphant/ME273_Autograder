function [score, fileFeedback] =  sixDerivsGrader(filename)

%--------------------------------------------------------------
% FILE: FBC_Grader.m
% AUTHOR: Douglas Cook 
% DATE: 2/6/2018
% 
% PURPOSE: Function for grading Lab 3, part II: Forward, Backward, and Central difference 
% numerical derivative functions.  
% 
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
%filename = files(i).name
    
    
    try
        % save state in case student runs "clear" in their function
        f = filename(1:end-2); % get function name
        
        % Input Data and solution for testing student code
        Solution =  [ 0.3777,    0.6201;    0.7700,    0.6681;  0.5738,    0.5973];   % Obtained from the script ThreeDerivs_2087.m
        PartNames = {'Forward', 'Backward','Central'};
        Feedback = char();
        feedback2 = char();
        
        
        % Call student code---------------------------------------------------------- 
        
        %clear Forward Backward Central
        %save('gradingvars.mat');
        eval([f,';'])    % evaluate the function
        %load('gradingvars.mat');
        
      
        % GRADING SECTION------------------------------------------------------------
        
        for j = 1:3
            if exist(PartNames{j})
                eval(['score(j) = mean(1 - abs((',PartNames{j},' - Solution(j,:))./Solution(j,:)));']);
            else
                score(j) = 0;
                eval(['Feedback = [Feedback, ''No variable named ', PartNames{j}, '; ,''];'])
            end
        end
        
        index = score < 0;
        score(index) = 0;
        index = score > 1;
        score(index) = 1;
        
        
        % Feedback on each part
        scor = round(score*100);
        for j = 1:3  
            Feedback = [Feedback, PartNames{j},' Score: ',num2str(scor(j)),'; '];
        end
        
        fileFeedback = Feedback;      % Form the final feedback string
        score = mean(score);
        
        
        % NORMALIZE THE SCORE (0 <= score <= 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    catch ERR
        % store error messages and zero scores if the code doesn't run.   
        load('gradingvars.mat'); % re-load grading script data and variables
        score = 0; % give score of 0
        fileFeedback = regexprep(ERR.message,'\n',' ');
    end
    
end