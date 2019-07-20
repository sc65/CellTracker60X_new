
function [xvalues, yvalues] = findQuadrantsImagedFromLogFile(logFile)
%% returns the number of x and y positions imaged in each quadrant.
% Get the quadrant information from the .log file

%Read the file
fileId  = fopen(logFile);
fileInfo = textscan(fileId, '%s');
fclose(fileId);

%Find the line corresponding to Images information: 'XImages', 'YImages'.
IndexC = strfind(fileInfo{1}, 'XImages');
Index = find(not(cellfun('isempty', IndexC)));

quadrants = length(Index);
xvalues = zeros(1, quadrants);
yvalues = xvalues;

for ii = 1:quadrants
    pos1 = strfind(fileInfo{1}{Index(ii)}, '</');
    xvalues(ii) = str2double(fileInfo{1}{Index(ii)}(10:pos1-1));
    pos2 = strfind(fileInfo{1}{Index(ii)+1}, '</');
    yvalues(ii) = str2double(fileInfo{1}{Index(ii)+1}(10:pos2-1));
end

