classdef AutograderGUI < handle
    %UNTITLED17 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labsList
        currentLab
        fig
        settingsGUI
        labPartsGUI
    end
    
    methods
        function self = AutograderGUI(labsList)
            self.labsList = labsList;
            
            self.fig = figure('Visible','off','NumberTitle','off','Name',...
                'ME273 Autograder','Position',[250 124 900 650],...
                'Resize','off');
            
            self.currentLab = nan;
            
            self.settingsGUI = makeSettingsGUI(self);
            self.labPartsGUI = makeLabPartsGUI(self);
            
            self.fig.Visible = 'on';
        end
        
        function gui = makeSettingsGUI(self)
            gui.panel = uipanel(self.fig, 'Title', 'Lab Settings', ...
            'Position',[0 0 .5 1]);

            % Lab selection
            gui.select_lab.panel = uipanel(gui.panel, 'Title', 'Select Lab',...
            'Position',[.1 .85 .8 .1]);

            labBoxCallback = @self.updatePartMger;

            gui.select_lab.box = uicontrol(gui.select_lab.panel, 'Style', ...
            'popup', 'String', self.labsList.getLabNumbers(), 'Units', 'Normalized',...
            'Position', [0.4 0.1 0.3 0.8],'callback',labBoxCallback,...
            'createfcn',labBoxCallback);

            gui.select_lab.text = uicontrol(gui.select_lab.panel, 'Style',...
            'text', 'String', 'Lab Number:', 'Units', 'Normalized', ...
            'Position', [0.0 0.05 0.3 0.8]);

            % Due Date
            gui.due_date = guiDatePicker(gui.panel, 'Monday Due Date', ...
            .1, .75, datetime(2018,4,2,16,0,0));

            gui.pseudo_date = guiDatePicker(gui.panel, 'Psuedo Date', ...
            .1, .65, datetime(datestr(now)));

            % Manual grading options
            gui.grading_opts.panel = uibuttongroup(gui.panel, 'Title', ...
            'Grading Options', 'Position', [.1 .3 .8 .25]);

            gui.grading_opts.radio(1) = uicontrol(gui.grading_opts.panel,...
            'Style', 'radiobutton', 'String','Original','Units','Normalized',...
            'Position',[.1 .8 .8 .1], 'Value', 1);

            gui.grading_opts.radio(2) = uicontrol(gui.grading_opts.panel,...
            'Style', 'radiobutton', 'String','Resubmission','Units','Normalized',...
            'Position',[.1 .6 .8 .1], 'Value', 0);

            gui.grading_opts.manual = uicontrol(gui.grading_opts.panel,...
            'Style', 'checkbox', 'String','Manual','Units','Normalized',...
            'Position',[.1 .4 .6 .1]);

            % Grade button
            gui.grade = uicontrol(gui.panel, 'Style', 'pushbutton', ...
            'String', 'GRADE', 'Units', 'Normalized', 'Position', [.25 .1 .5 .1]);
        end
        
        function gui = makeLabPartsGUI(self)
            
            gui.panel = uipanel(self.fig, 'Title', 'Lab Parts', ...
                'Position', [.5 0 .5 1]);
            
        end
        
        function updatePartMger(self,hObject,~)

            idx = hObject.Value;
            labNum = str2num(hObject.String(idx));

            self.currentLab = self.labsList.getLab(labNum);

        end
        
    end
    
end

