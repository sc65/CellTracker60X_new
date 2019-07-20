
function saveColonyImagesColonyMask(oldFile, newFilePath, colonyCounter, metadata)
% ---- saves oldFiles (.oif) as a maxZ tif files in the newFilePath, separate dapi file for ilastik, and colony masks   

%%
filereader = bfGetReader(oldFile);
nChannels = metadata.nChannels;

%%
% --- get maxZ images, save for later, save dapi separately for ilastik
nRows = metadata.ySize;
nCols = metadata.xSize;
images = uint16(zeros(nRows,nCols));
timepoints = metadata.nTime;
dapiChannel = find(cell2mat(cellfun(@(c)strcmp(c,'DAPI'),upper(metadata.channelNames),'UniformOutput',false)));

for ii = 1:nChannels
    maxZ = MakeMaxZImage(filereader, ii, timepoints);
    maxZ = smoothAndBackgroundSubtractOneImage(maxZ);
    images(:,:,ii) = maxZ;
    if ii == dapiChannel
        imwrite(images(:,:,ii), [newFilePath filesep 'colony' int2str(colonyCounter) '_ch' int2str(ii) '.tif']);
    end
    
    if ii == dapiChannel
        imwrite(images(:,:,ii), [newFilePath filesep 'colony' int2str(colonyCounter) '.tif']);
    else
        imwrite(images(:,:,ii), [newFilePath filesep 'colony' int2str(colonyCounter) '.tif'], 'Writemode', 'append');
    end
        
end
%%
dapiImage = images(:,:,dapiChannel);

%% ---- make colony mask
colonyMask = makeColonyMaskUsingDapiImage(dapiImage, metadata);
figure; imshowpair(dapiImage, colonyMask); title([newFilePath filesep 'colony' int2str(colonyCounter)]);
imwrite(colonyMask, [newFilePath filesep 'colony' int2str(colonyCounter) '_colonyMask' '.tif'])
%%


end
