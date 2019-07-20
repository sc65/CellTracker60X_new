
function [fileinfo, start] = startPositionFunctionDir(folderPath)
%% the function dir(x) returns the information of files in that folder path.
% Sometimes the list of files start from the third value, sometimes from
% the fourth value. 
% This function returns the start value of the folder, supplied as an input
% to the function. 

fileinfo = dir(folderPath);
nelem = size(fileinfo, 1);

for i = 1:nelem
     fn = fileinfo(i).name;
    
    if(fn(1) ~= '.')
        start = i;  
        break;
    end
    
end

end