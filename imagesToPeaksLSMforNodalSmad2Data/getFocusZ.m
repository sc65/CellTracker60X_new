function zFocusImage = getFocusZ(imageFile, channel, seriesNum)
%% for beta-catenin images, taking the max z projections is not recommended 
% as it includes membrane values from out of focus planes. 

fileReader = bfGetReader(imageFile);
if exist('seriesNum', 'var')
    fileReader.setSeries(seriesNum); %for a multi-position tif file, initialize the reader to the specific position number.
end

zSlices = 1:fileReader.getSizeZ;
dapi = 1; %Dapi channel

intensities = zeros(1, numel(zSlices));
for ii = zSlices
    imagePlane = fileReader.getIndex(ii-1,dapi-1,1-1)+1; %a single timepoint.
    imageFile = bfGetPlane(fileReader, imagePlane);
    intensities(ii) = mean(mean(imageFile));
end

zFocus = find(intensities == max(intensities));
imagePlane = fileReader.getIndex(zFocus-1,channel-1,1-1)+1; %a single timepoint.
zFocusImage = bfGetPlane(fileReader, imagePlane);

end
