function [croppedImage, colonyMask] = cropImageUsingColonyMask(rawImage, colonyMask)
%% crops image to contain only colony +/- 20 pixel square region around it. 

rawImage = bsxfun(@times, rawImage, cast(colonyMask, class(rawImage)));
stats = regionprops(colonyMask, 'PixelList');
pixels = [stats.PixelList];

extraRoom = 20;
upperBounds =  max(pixels,[],1);
lowerBounds = min(pixels, [],1);

croppedImage = rawImage([lowerBounds(2)-extraRoom:upperBounds(2)+extraRoom], [lowerBounds(1)-extraRoom:upperBounds(1)+extraRoom],:);
colonyMask = colonyMask([lowerBounds(2)-extraRoom:upperBounds(2)+extraRoom], [lowerBounds(1)-extraRoom:upperBounds(1)+extraRoom],:);

end