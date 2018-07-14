function [score, fileFeedback] =  SolTimes_figure_grader(filename)


%--------------------------------------------------------------
% FILE: RegressionN_Grader.m   
% AUTHOR: Jared Oliphant
% DATE: 12 Feb 2018
% 
% PURPOSE: Function for grading Lab 5, part 2: Nth order regression
% coefficients, error vector, and r2 value. 
% Two tests are performed with the same dataset. 3rd order and a 7th order
% regression. The for the high order case, the tolerance for e vector is
% bigger and we only look at one of the values of the vector b. 
% The first test will run with coloumn vector inputs and the second will be
% a row vector 
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


filename(end - 2:end) = 'fig';%Change file extension

try
openfig(filename)
score_bonus = .1;
score_axis_labels = input('Enter ''2'' if both axis labels are correct, ''1'' if 1 correct axis label is present, and ''0'' if no correct axis labels are present: ');
score_axis_labels = score_axis_labels/2*.2;
score_legend = input('Enter ''1'' if the legend is in the correct order, and ''0'' if the legend is not in the correct order: ');
score_legend = score_legend*.2;
score_extralines = input('Enter ''1'' if no extra lines are plotted, and ''0'' if extra lines are plotted: ');
score_extralines = score_extralines*.2;
score_solving_methods = input('Enter ''1'' if the correct solving methods were used, and ''0'' if the incorrect solving methods were used: ');
score_solving_methods = score_solving_methods*.2;
score_tick_marks = input('Enter ''1'' if the x-axis tick marks are correct, and ''0'' if they are incorrect e.g., 1,2,3 instead of 100, 500, 1000: ');
score_tick_marks = score_tick_marks*.1;
close

%Set up feedback based on scores given
if score_axis_labels == .2
    axis_labels_feedback = 'None';
else if score_axis_labels == .1
        axis_labels_feedback = 'One of your axes is labeled incorrectly';
    else if score_axis_labels == 0;
            axis_labels_feedback = 'Both of your axes are labeled incorrectly';
        end
    end
end
if score_legend == .2
    legend_feedback = 'None';
else if score_legend == 0
        legend_feedback = 'Your legend was in the wrong order';
    end
end
if score_extralines == .2
    extralines_feedback = 'None';
else if score_extralines == 0
        extralines_feedback = 'Your function plotted curves that weren''t requested in the ''Methods'' vector';
    end
end
    
if score_solving_methods == .2
    solving_methods_feedback = 'None';
else if score_solving_methods == 0
        solving_methods_feedback = 'Your function did not use the correct solving methods as requested by ''Methods''';
    end
end
if score_tick_marks == .1
    tick_marks_feedback = 'None';
else if score_tick_marks == 0
        tick_marks_feedback = 'The x-axis tick marks are incorrect. It is likely that you plotted your ''times'' against indices instead of against the matrix sizes';
    end
end


score = score_bonus + score_axis_labels + score_legend + score_extralines + score_solving_methods + score_tick_marks;
fileFeedback = ['Axis label score: ',num2str(score_axis_labels*100/.2),'%, Axis label feedback: ',axis_labels_feedback,', Legend score: ',num2str(score_legend*100/.2),'%, Legend feedback: ',legend_feedback,', Score for plotting the right number of curves: ',num2str(score_extralines*100/.2),'%, Feedback on plotting the right number of curves: ',extralines_feedback,', Solving methods score: ',num2str(score_solving_methods*100/.2),'%, Solving methods feedback: ',solving_methods_feedback,', X-axis tick mark score: ',num2str(score_tick_marks*100/.1),'%, X-axis tick mark feedback: ',tick_marks_feedback];


        %====================================================================================
% ANY ERRORS ARE 'CAUGHT' HERE AND STORED IN THE VARIABLE "ERROR"
catch ERROR  
    
    %==============================================================
    % Zero score if the code doesn't run:   
     score = 0;
    % An explanation of the zero score and the MATLAB error message. 
    plotscore_feedback_1 = regexprep(ERROR.message,'\n',' '); 
    fileFeedback = ['No matlab figure was found associated with your SolTimes function. ','Error Message: ',plotscore_feedback_1];
    %==============================================================
    
end

    
end