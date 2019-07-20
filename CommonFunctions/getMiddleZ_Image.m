function [middleZ_images, zSlices, z1] = getMiddleZ_Image(fileReader, channelOrder, seriesNum)

%% get images in the center z plane for a given channel in a given image
if exist('seriesNum', 'var')
    fileReader.setSeries(seriesNum); %for a multi-position tif file, initialize the reader to the specific position number.
end

zSlices = 1:fileReader.getSizeZ;
z1 = floor((numel(zSlices)+1)/2);


for ii = channelOrder
    imagePlane = fileReader.getIndex(z1-1,ii-1,1-1)+1;
    middleZ_images(:,:,ii) = bfGetPlane(fileReader, imagePlane);
end

end

