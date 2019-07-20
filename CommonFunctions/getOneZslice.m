function images = getOneZslice(fileReader, zSlice, channelOrder, timePoint)
%% get images for 1 zslice, 1 timePoint, all Channels.

for ii = channelOrder
    imagePlane = fileReader.getIndex(zSlice-1,ii-1,timePoint-1)+1;
    images(:,:,ii) = bfGetPlane(fileReader, imagePlane);
end

end