function path = getImagePath(direc, files, position, quadrant)
% returns the full path of the .oif image corresponding to one position. 

if ~exist('quadrant', 'var')
    quadrant = 1;
end

if quadrant == 1
    imageNumber = position;
else
    imageNumber = sum(files.images(1:quadrant-1)) + position;
end

image1dir = [direc filesep sprintf('Track%04d', imageNumber)];
image1info = dir([image1dir filesep '*.oif']);
path = [image1dir filesep image1info.name];
end