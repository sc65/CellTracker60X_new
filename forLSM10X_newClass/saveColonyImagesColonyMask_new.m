%%
function saveColonyImagesColonyMask_new(newImagePath, finalImage, metadata)
% newImagePath: file path where image needs to be saved
% finalImage: an array of a colony image with channels in third dimension

nChannels = size(finalImage,3);
dapiChannel = find(cell2mat(cellfun(@(c)strcmp(c,'DAPI'),upper(metadata.channelNames),'UniformOutput',false)));
betaCateninChannel = find(cell2mat(cellfun(@(c)strcmp(c,'BETACATENIN'),upper(metadata.channelNames),'UniformOutput',false)));


for ii = 1:nChannels
    if ii == dapiChannel
        imwrite(finalImage(:,:,ii), [newImagePath '_ch' int2str(ii) '.tif']);
    end
    
    if ii == dapiChannel
        imwrite(finalImage(:,:,ii), [newImagePath '.tif']);
    else
        imwrite(finalImage(:,:,ii), [newImagePath '.tif'], 'Writemode', 'append');
    end     
end

if ~isempty(betaCateninChannel)
    imwrite(finalImage(:,:,betaCateninChannel), [newImagePath '_ch' int2str(betaCateninChannel) '.tif']);
end
%%
dapiImage = finalImage(:,:,dapiChannel);

%% ---- make colony mask
colonyMask = makeColonyMaskUsingDapiImage(dapiImage, metadata);
figure; imshowpair(dapiImage, colonyMask); 
title([newImagePath]);
imwrite(colonyMask, [newImagePath '_colonyMask' '.tif'])