function [score, fileFeedback] = derivPlotGrader(filename)

    try
        % save state in case student runs "clear" in their function
        f = filename(1:end-2); % get function name
        save('gradingvars.mat');

        % alter outputs and inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % EX: eval(['[output1, output2] = ',f,'(input1, input2);'])
        eval(f);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        load('gradingvars.mat');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % grading algorithm - assign scores here and feedback here
        
        score = input('Score? ');
        
        if (score == 10)
            fileFeedback = 'no feedback';
        else
            fileFeedback = input('Feedback? ','s');
        end
        
        % NORMALIZE THE SCORE (0 <= score <= 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        score = score/10;
        
    catch
        
        load('gradingvars.mat'); % re-load grading script data and variables
        score = 0; % give score of 0
        fileFeedback = ERROR.getReport; % store the stack trace in scores
        
    end
    
end