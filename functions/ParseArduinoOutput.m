function [convertToChar, exportArray] = ParseArduinoOutput(obj,readData)
    exportArray = '';
    convertToChar = strtrim(char(readData)');
%     getCommas = find(convertToChar == ',');
%     exportArray = readData(getCommas+1);
    
end