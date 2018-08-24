classdef Lab < handle
    %Lab - Class for encapsulating ME273 lab information: the lab number, the
    %lab part (lab subassignment), and that lab part's name, grader file
    %name, and path to the grader file.
    
    properties
        num
        parts
        numParts
    end
    
    methods
        % Constructor - called when you create an instance of this class.
        function self = Lab(num)
            % initialize the lab number
            self.num = num;
            % Initialize with no lab parts/subassignments
            self.numParts = 0;
        end
        
        % Function for adding a lab part/subassignment to this lab.
        % name - character array
        % graderFileName - the name and extension of the grader file for
        % this lab part (should be a .m file).
        % graderFilePath - the file path to the graderFile.
        function addLabPart(self, name, graderFileName, graderFilePath)
            self.numParts = self.numParts + 1;
            
            self.parts{end+1}.name = name;
            self.parts{end}.graderFile.name = graderFileName;
            self.parts{end}.graderFile.path = graderFilePath;
        end
    end
    
end