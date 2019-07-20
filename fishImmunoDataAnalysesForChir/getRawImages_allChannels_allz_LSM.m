function rawImages = getRawImages_allChannels_allz_LSM(samplePath, position)
%% returns an array of images (1024,1024, nCh, nZ) from a .oif file.
% bacground subtraction also done here.
%% --------------Inputs------------------
% samplePath = path to the folder containing sample details, e.g: ./Chir_t1
% position =  multiple positions are imaged in each sample. 
% position number (track number) for which raw images are required.
%%
sampleInfo = dir([samplePath filesep 'Track*']);

fileInfo = dir([samplePath filesep sampleInfo(position).name filesep '*.oif']);
filePath = [samplePath filesep sampleInfo(position).name filesep fileInfo.name];
reader = bfGetReader(filePath);
nZ = reader.getSizeZ;
nCh = reader.getSizeC;
xy = reader.getSizeX;
%%
rawImages = uint16(zeros(xy,xy,nCh-1,nZ));
%%
for ii = 1:nCh
    for jj = 1:nZ
        imagePlane = reader.getIndex(jj-1,ii-1,1-1)+1; %[zSlice-1, channel-1, timePoint-1]
        rawImages(:,:,ii,jj) = bfGetPlane(reader, imagePlane);
        rawImages(:,:,ii,jj) = SmoothAndBackgroundSubtractOneImage(rawImages(:,:,ii,jj));
    end
end

end