classdef LabsList < handle
    %UNTITLED12 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labs
        numLabs
    end
    
    methods
        function self = LabsList
            self.labs = cell(0,1);
            self.numLabs = 0;
        end
        
        function addLab(self, num)
            self.numLabs = self.numLabs + 1;
            self.labs{end+1} = Lab(num);
        end
        
        function addLabPart(self, name, graderFileName)
            self.labs{end}.addLabPart(name, graderFileName, ...
                fullfile('grading_functions'));
        end
        
        function labNums = getLabNumbers(self)
            
            labNums = zeros(self.numLabs,1);
            
            for i = 1:self.numLabs
                labNums(i) = self.labs{i}.num;
            end
        end
        
        function lab = getLab(self, num)
            lab = 0;
            
            for i = 1:self.numLabs
                if num == self.labs{i}.num
                    lab = self.labs{i};
                end
            end
            
            if isinteger(lab)
                error('Invalid lab number');
            end
        end
    end
    
end

