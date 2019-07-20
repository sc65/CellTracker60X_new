
function [images_x, images_y] = findImagesPerMosaicFromLogFile(fileInfo)
%% returns the number of images in the x and y directions (images_x, images_y) in each mosaic.

% get number of mosaics
idx1 = contains(fileInfo{1}, 'NumberOfMosaics');
mosaicLine = fileInfo{1}(idx1);
idx1 = cell2mat(regexp(mosaicLine, '<NumberOfMosaics>','end'));
idx2 = cell2mat(regexp(mosaicLine, '</NumberOfMosaics>','start'));
mosaics = str2double(mosaicLine{1}(idx1+1:idx2-1));

images_x = zeros(1, mosaics);
images_y = images_x;

%Find the line corresponding to 'XImages', 'YImages'.
IndexC = strfind(fileInfo{1}, 'XImages');
Index = find(not(cellfun('isempty', IndexC)));
if mosaics == 1
    images_x = 1;
    images_y = 1;
else
    % assuming all mosaics have same number of images as mosaic 1.
    position1 = strfind(fileInfo{1}{Index(1)}, '</');
    images_x(1:mosaics) = str2double(fileInfo{1}{Index(1)}(10:position1-1));
    position2 = strfind(fileInfo{1}{Index(1)+1}, '</');
    images_y(1:mosaics) = str2double(fileInfo{1}{Index(1)+1}(10:position2-1));
    
end

