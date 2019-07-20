%%
clearvars;
masterFolder = '/Volumes/sapnaDrive2/190414_nanog_sox2_AllConditions';
channelOrder = {'dapi', 'SOX2', 'NANOG', 'Smad2'}; % order in which channels were imaged.
nuclearChannel = 1;
alignmentChannel = 1; % channel used to find overlap between images. 

%%
samples = dir([masterFolder '/rawData/']);
samples(1:2) = [];

%subFolders in the folder rawData corresponding to one condition.
imagesFolder = cell(1, length(samples));
saveInFolder = imagesFolder;
%%
%for ii = 1
for ii = 1:length(samples)
    imagesFolder{ii} = [masterFolder filesep 'rawData' filesep samples(ii).name];
    saveInFolder{ii} = [masterFolder filesep 'processedData' filesep samples(ii).name filesep];% where aligned images are stored.
    mkdir(saveInFolder{ii});
end

%% -------------------------- align & save
logFile = 'MATL_Mosaic.log';
for ii = 2
%for ii = 1:length(imagesFolder)
%for ii = 2:length(imagesFolder)
    ii
    files = readLSMmontageDirectory(imagesFolder{ii}, logFile, channelOrder);
    coloniesImaged =  find(files.images1, 1, 'last');
    %%
    for jj = 1
    %for jj = 1:coloniesImaged
        jj
        finalImage = align3by3LSMImage(files, jj, alignmentChannel);
        %figure; imshow(finalImage(:,:,1),[]);
        allChannelImage = [saveInFolder{ii} filesep 'colony' int2str(jj) '.tif'];
        nuclearChannelImage = [saveInFolder{ii} filesep 'colony' int2str(jj) '_ch' int2str(nuclearChannel) '.tif'];
        for kk = 1:size(finalImage,3)
            if kk == 1
                imwrite(finalImage(:,:,kk),allChannelImage);
            else
                imwrite(finalImage(:,:,kk), allChannelImage, 'WriteMode', 'append');
            end
            
            if kk == nuclearChannel
                imwrite(finalImage(:,:,kk), nuclearChannelImage); %for ilastik
            end
        end
    end
end

%%

%%
finalImage = imrotate(finalImage, -180);
%figure; imshow(finalImage(:,:,1),[]);

%% --------------------------------- adding tracking data
colonyIds = [1 5 6 8]; %corresponding to tracking data.

% save
dapiFolder = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/dapi';
venusFolder = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/finalFateData/venus';
% save
for ii = 1:4 %loop over channels.
    image1 = finalImage(:,:,ii);
    imageName = [saveInFolder filesep 'fateImageColony' int2str(colonyIds(colonyNumber)) '.tif'];
    if ii == 1  %also save the dapi images in a separate folder.
        imwrite(image1, imageName);
        imageName = [dapiFolder filesep 'fateImageColony' int2str(colonyIds(colonyNumber)) '.tif'];
        imwrite(image1, imageName);
        
    else
        imwrite(image1, imageName, 'WriteMode', 'append');
        if ii==2  %also save the venus images in a separate folder.
            imageName = [venusFolder filesep 'fateImageColony' int2str(colonyIds(colonyNumber)) '.tif'];
            imwrite(image1, imageName);
        end
    end
    
end
%%














