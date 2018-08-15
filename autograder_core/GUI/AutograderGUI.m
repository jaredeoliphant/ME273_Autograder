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
        % Constructor
        function self = AutograderGUI(labsList)
            % Initialize labs list
            self.labsList = labsList;
            
            % create figure for gui
            self.fig = figure('Visible','off','NumberTitle','off','Name',...
                'ME273 Autograder','Position',[250 124 900 650],...
                'Resize','off');
            
            % set current lab to nothing
            self.currentLab = nan;
            
            % initialize and configure the main panels for the gui
            self.labPartsGUI = makeLabPartsGUI(self);
            self.settingsGUI = makeSettingsGUI(self);
            
            % show the figure
            self.fig.Visible = 'on';
        end
        
        % Creates the panel for the overall lab settings
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
        
        % Creates the panel for the lab part settings
        function gui = makeLabPartsGUI(self)
            
            gui.panel = uipanel(self.fig, 'Title', 'Lab Parts', ...
                'Position', [.5 0 .5 1]);
            
            gui.parts = cell(0,1);
            
        end
        
        % Callback function for the dropdown lab selector box. Updates the
        % current lab that the gui displays and prepares for grading.
        function updatePartMger(self,hObject,~)
            % get the selected lab number
            idx = hObject.Value;
            labNum = str2num(hObject.String(idx));
            % get that lab from the labs list
            self.currentLab = self.labsList.getLab(labNum);
            
            % create the appropriate lab panels
            createLabPartPanels(self);

        end
        
        % Uses the current lab selected to create and display the lab part
        % panels in the gui
        function createLabPartPanels(self)        
            
            % delete the old lab part panels
            h = self.labPartsGUI.panel.Children;
            
            delete(h);
            
            % get number of lab parts
            n = self.currentLab.numParts;
            
            % reset the number of lab part panels
            self.labPartsGUI.parts = cell(n,1);
            
            % for each lab part in the current lab
            for i = 1:n
                % get parameters for panel creation
                parent = self.labPartsGUI.panel;
                name = self.currentLab.parts{i}.name;
                defaultGrader = self.currentLab.parts{i}.graderFile;
                
                % calculate the vertical position of this panel
                posy = 1 - i*.2;
                
                % create a lab part panel and store it
                self.labPartsGUI.parts{i} = getLabPartPanel(parent, ...
                    name, defaultGrader, posy);
                
            end % end for
            
        end % end function
        
    end % end methods
    
end % end class