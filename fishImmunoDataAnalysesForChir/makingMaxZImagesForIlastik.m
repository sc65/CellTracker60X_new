%% make maxZ images for iLastik - Dapi, Nodal, T Channels.
%% works for outPut (multiTiff Images) from Spinning Disk.

masterFolderPath = '/Volumes/SAPNA/170612ChirBCatNodal/RawData';
rawImagesPath = [masterFolderPath filesep 'RawData'];
files = dir([rawImagesPath filesep '*.tif']);
%%
newFolders = {'dapiImages', 'tImages', 'nodalImages'}; %to store maxZ images for training iLastik.
for ii = 1:length(newFolders)
    mkdir([masterFolderPath filesep newFolders{ii}]);
end
t = 1; %Analysing fixed cell data.
%%
channels = [1 3 4]; %[Dapi T Nodal]
%for ch = 3
for ch = 1:length(newFolders)
    for ii = 1:length(files)
        imagePath = [rawImagesPath filesep files(ii).name];
        reader = bfGetReader(imagePath);
        nSeries = reader.getSeriesCount; %returns the number of positions.
        
        fileNameParts =  strsplit(files(ii).name, '.');
        newFileNamePrefix = fileNameParts{1}; %get the part of the filename before ".tif"
        newfilePath = [masterFolderPath filesep newFolders{ch} filesep newFileNamePrefix '.tif'];
        
        for jj = 0:nSeries-1
            reader.setSeries(jj);
            nZslices = reader.getSizeZ;
            if nZslices > 1
                imageToWrite = getMaxZ(imagePath, channels(ch), jj);
            else
                
                iPlane = reader.getIndex(nZslices-1,channels(ch)-1,t-1) + 1;
                imageToWrite = bfGetPlane(reader, iPlane);
            end
            if jj == 0
                imwrite(imageToWrite, newfilePath);
            else
                imwrite(imageToWrite, newfilePath, 'WriteMode', 'append');
            end
        end
    end
end
%%
% measure spot intensity for nodal and lefty
spotsFolders = {'nodalImages', 'tImages'};
spotMeanMode = zeros(length(spotsFolders), length(files)); %initialize.

allInfo = cell(1,length(spotsFolders)); %stores spot intensities for every channel, every sample
%for ch = 1
for ch = 1:length(spotsFolders)
    spotMasksFolderPath = [masterFolderPath filesep spotsFolders{ch}];
    allMasks = dir([spotMasksFolderPath filesep '*.h5']);
    
    for ii = 1:length(allMasks) % only the negative control and t0 sample
        %for ii = 1:length(allMasks)%loop over different timepoints
        maskPath = [spotMasksFolderPath filesep allMasks(ii).name];
        mask = readIlastikFile(maskPath);
        
        imageNameParts = strsplit(allMasks(ii).name, '_');
        imagePrefix = imageNameParts{1};
        imagePath = [masterFolderPath filesep spotsFolders{ch} filesep imagePrefix '.tif'];
        
        spotIntensities = zeros(5000,1);
        counter = 1;
        
        figure;
        spotMode = zeros(length(spotsFolders), size(mask,3));
        for jj = 1:size(mask,3)%loop over different positions
            maskOne = mask(:,:,jj);
            imageOne = imread(imagePath, jj);
            
            stats = regionprops(maskOne, imageOne , 'Area', 'MeanIntensity', 'Centroid', 'PixelIdxList');
            stats = stats([stats.Area] < 9 & [stats.Area] > 4);
            bla = [stats.MeanIntensity]';
            spotIntensities(counter:counter+size(bla,1)-1) = bla;
            counter = counter+size(bla,1);
            
            subplot(3,4,jj);
            histogram(bla, 'BinWidth', 500);
            xlim([500 12000]);
            %ylim([0 900]);
            
            bins = 500:50:20000;
            n = hist(bla, bins);
            [~,idx] = max(n);
            spotMode(ch, jj) = bins(idx);
            
        end
        
        spotIntensities = spotIntensities(1:find(spotIntensities, 1, 'last'));
        allInfo{ch}{ii} = spotIntensities;
    end
end

%%
% plot the histogram of spot intensities for each samples, for both
% channels.
plotOrder = [7 6 1:5 13 8:12];
binSize = [500 100];

close all;
for ii = 1:2
    figure;
    plotnum = 1;
    for jj = 1:13
        dataToPlot = allInfo{ii}{plotOrder(jj)};
        subplot(4,4, jj);
        histogram(dataToPlot, 'BinWidth', binSize(ii), 'Normalization', 'Probability');
        title([files(plotOrder(jj)).name]);
        if ii == 1
            xlim([0 4*10^4]);
            ylim([0 0.12]);
        else
            xlim([0 12000]);
        end
        
        bins = 500:50:80000;
        n = hist(dataToPlot, bins);
        [~,idx] = max(n);
        spotMeanMode(ii, jj) = bins(idx);
        
    end
end
%%
oneSpotIntensities = mean(spotMeanMode,2);
nodalSpot = oneSpotIntensities(1);
tSpot = oneSpotIntensities(2);
%%
figure;
subplot(1,2,1);
plot(1:13, spotMeanMode(1,:), 'k-*');
title('Nodal');
xlabel('Sample');
ylabel('Mode of Spot Intensitites');

subplot(1,2,2);
plot(1:13, spotMeanMode(2,:), 'r-*');
title('Brachyury');
xlabel('Sample');
ylabel('Mode of Spot Intensitites');















