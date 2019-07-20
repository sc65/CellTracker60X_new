function maxZ = getMaxZ(imageFile, seriesNum)

%% make max z projections for all channels in a given image
filereader = bfGetReader(imageFile);
if exist('seriesNum', 'var')
    filereader.setSeries(seriesNum); %for a multi-position tif file, initialize the reader to the specific position number.
end

zslices = filereader.getSizeZ;
channels = filereader.getSizeC;
metadata = filereader.getMetadataStore();
pixelsX = double(metadata.getPixelsSizeX(0).getValue());
pixelsY = double(metadata.getPixelsSizeY(0).getValue());
imageBits = double(metadata.getPixelsSignificantBits(0).getNumberValue);

maxZ = uint16(zeros(pixelsX, pixelsY, channels));

for ii = 1:channels
    maxZ_1 = uint16(zeros(1024));
    for jj = 1:zslices
        imagePlane = filereader.getIndex(jj-1,ii-1,1-1)+1; %a single timepoint.
        imageFile = bfGetPlane(filereader, imagePlane);
        maxZ_1 = max(maxZ_1, imageFile);
    end
    maxZ(:,:,ii) = maxZ_1;
end

if imageBits == 8
    maxZ = uint8(maxZ);
end

end





