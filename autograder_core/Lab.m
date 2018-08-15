classdef Lab < handle
    %UNTITLED10 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num
        parts
        numParts
    end
    
    methods
        function self = Lab(num)
            self.num = num;
            self.numParts = 0;
        end
        
        function addLabPart(self, name, graderFileName, graderFilePath)
            self.numParts = self.numParts + 1;
            
            self.parts{end+1}.name = name;
            self.parts{end}.graderFile.name = graderFileName;
            self.parts{end}.graderFile.path = graderFilePath;
        end
    end
    
end