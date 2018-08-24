function [Score, Feedback] = ErrPlots_Grader(filename)
%--------------------------------------------------------------
% FILE: ErrPlots_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 3/15/2018
% 
% PURPOSE: Function for grading Lab 9, part 3: Error plotting function
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
Feedback = '';
numweight = 0.2;     %percentage of score based on having the right number of axes (2)
stepsizeweight = 0.1; %percentage of score based on having the correct step size vector for the 1st plot
logweight = 0.05;     %percentage of score based on having a log scale on 2nd plot
legendweight = 0.05; %percentage of score based on having any kind of legend on either plot
humanweight = 0.3;   %percentage of score based on human grader score
Score = 0.3;        %bonus to add up to 1
set(0,'Defaultlinelinewidth',2)
% the TRY/CATCH structure is used to prevent code crashes
try
    
    % FILENAME TRUNCATED and stored in the variable f.
    %=================================================| 
    StudentFunction = filename(1:end-2)    % get function name     |
    %=================================================|
    

    %=================================================
    % PLACE HARD-CODED REFERENCE SOLUTION CODE HERE    
    fh = @odeproblem;
    Xrange = [0 1.4];
    y0 = -1;
    N = [3:10];           %vector of N steps
    fhs = @odesolution;
    stepsizexdata = [0.7  0.466666666666667  0.35   0.28   0.233333333333333   0.2 ...
    0.175   0.155555555555556];
    %=================================================
    
        
    
    %================================================================================
    % Running student code
    % NOTE: CallingString WILL NEED TO BE ADJUSTED BASED ON THE FORMAT SPECIFIED IN THE LAB HANDOUT
    CallingString = [StudentFunction,'(fh, Xrange, y0, fhs, N);'];        % A string passed to eval.
    eval(CallingString)                                         % evaluate the function
    %================================================================================
    
    
    
    %==================================================
    % GRADING SECTION - evaluate student work here.
    hLegend = findobj(gcf, 'Type', 'Legend');   %extracts the legend
    hLines = findobj(gcf, 'Type', 'Line');   %extracts the lines
    hAxes = findobj(gcf, 'Type', 'Axes');   %extracts the axes in backward order
    


    %should have 2 plots with 5 lines each;  should have 2 total axes
    if  length(hAxes) == 2  
        Score = Score + numweight;
        Feedback = [Feedback,'Looks like you have the correct number of axes.'];
        
        
        
        %Extract the 2 plots
        Stepsz_plot = hAxes(2);
        Effort_plot = hAxes(1);

        %Extract the 5 effort lines
%         eff1 = hLines(1);
%         eff2 = hLines(2);
%         eff3 = hLines(3);
%         eff4 = hLines(4);
%         eff5 = hLines(5);
        
        %Extract the 5 step size lines
          step1 = hLines(6);
%         step2 = hLines(7);
%         step3 = hLines(8);
%         step4 = hLines(9);
          step5 = hLines(10);
        
        
        %this will check the xdata on the step size plot to make sure they
        %created that vector properly. May have issues if someone plots the
        %two plots in reverse order
        if norm(step1.XData-stepsizexdata) < .01 && norm(step5.XData-stepsizexdata) < .01
            Score = Score + stepsizeweight;
            Feedback = [Feedback,'  --  Your step size vector is correct'];
        else
            Feedback = [Feedback,'  --  Your step size vector is incorrect.   norm(step - step_sol) = ',num2str(norm(step1.XData-stepsizexdata))];
        end
        

    
        %this section will check the yscale on the effort plot to make sure it
        %is log
        if string(Effort_plot.YScale) == "log"
            Score = Score + logweight;
            Feedback = [Feedback,'  --  Good job setting the yscale on the effort plot to log.'];
        else
            Feedback = [Feedback,'  --  If you set the yscale on your effort plot to log it will be much more readable: use set(gca,''yscale'',''log'')'];
        end
    
    else % they didn't have the right number of lines / axes so the previous grading would have been impossible.
        Feedback = [Feedback,'Looks like you have an incorrect number of lines or axes.'];
    end
    
    
    %this check to see if a legend exists. it does not check the entries in
    %the legend.
    if ~isempty(hLegend)
        Score = Score + legendweight;
        Feedback = [Feedback,'  --  Good job on your legend.'];
    else 
        Feedback = [Feedback,'  --  A legend would be a good idea in this scenario, otherwise the information is not communicated properly.'];
    end
    
    %finally we have the human grader section. The user is asked for a
    %grade on a 0 - 5 scale and given information about what parts have been autograded                        
    flag = 0;
    errormsg = '';
    while flag == 0
        humangrader = input([errormsg,'\n The legend, the stepsize vector, the log scale on the Effort chart, and the number of plots \n have been autograded. Are the lines following the appropiate trends? Does it look good? \n Please give a score from 0 to 5  \n ']);
        if ~isempty(humangrader) 
            if isnumeric(humangrader) == 0
                humangrader = pi;              %little easter egg, just for fun
            end
            if humangrader >=0 && humangrader <=5
                flag = 1;
                Score = Score + .2*humanweight*humangrader;
                Feedback = [Feedback,'   ---   Your ''human'' score is ',num2str(humangrader),' out of 5.'];
            else
                flag = 0;
                errormsg = '\n ERROR: Number entry out of bounds!! Try again.  \n ';
            end
        end
    end
    close all
    %==================================================
    
    
%====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
  catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
    Score = 0;      % give score of 0
    % An explanation of the zero score and the MATLAB error message. 
    Feedback = regexprep(ERROR.message,'\n',' ');     
    %==============================================================
    
   
    
  end


%========================================================================
% COMBINE SUB-SCORES, CONCATENATE FEEDBACK MESSAGES, AND CHECK SCORE. 
% Note: Final score must between 0 and 1. 
%
%
%
%========================================================================
   
    
end


%needs to be able to accept vectors as well as scalars just in case
function dydx = odeproblem(x,y)
     dydx = (2*cos(x).^2-sin(x).^2+y.^2)./(2*cos(x));
end
%needs to be able to accept vectors as well as scalars
%some students wrote their code such that the @fhs function have 2 inputs,
%thus the varargin (variable number of input arguments
function y = odesolution(x,varargin)
    y = sin(x) + 1./(-.5*sin(x)-cos(x));
end