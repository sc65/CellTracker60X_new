
%%

% read images, masks
% background subtract images
% calculate allStats - cell array - [centroids dapiIntensity ch1 ch2 ch3]
% save in output file

%%
meta.nChannels = 2;
meta.channelOrder = [1:2]; %start with dapi
meta.channelNames = {'dapi', 'gata3'};
%%
files = dir('*.tif');
toKeep = ~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{files.name},'UniformOutput',false));
files = files(toKeep);

masks = dir('*.h5');
toKeep = ~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{masks.name},'UniformOutput',false));
masks = masks(toKeep);

cells = struct();
%%

for jj = 1:numel(files)
    jj
    images1 = uint16(zeros(2048));
    counter = 1;
    for kk = meta.channelOrder
        images1(:,:,counter) = imread([files(jj).folder filesep files(jj).name], kk);
        images1(:,:,counter) = smoothAndBackgroundSubtractOneImage(images1(:,:,counter),1.5);
        counter = counter+1;
    end
    
    mask1 = ~(readIlastikFile([masks(jj).folder filesep masks(jj).name]));
    mask1 = bwareaopen(mask1, 50);
    mask1 = imfill(mask1, 'holes');
    
    stats1 = regionprops(mask1, 'Centroid');
    cells(jj).position = cat(1,stats1.Centroid);
    
    for kk = 1:meta.nChannels
        stats2 = regionprops(mask1, images1(:,:,kk), 'MeanIntensity');
        cells(jj).intensity(:,kk) = cat(1, stats2.MeanIntensity);
    end
    
end
%%
save('output.mat', 'files', 'cells', 'meta');

%%

% check if data makes sense
sampleId = [1 5 9 13];
dapi = 1; meta.sampleNames = {'mTeSr', '+BMP', '+BMP+SB', '+BMP+IWP2'};
tooHigh = 50000;  % remove any row with any value higher than tooHigh
chToPlot = 2;
chLabel = {'isl1'}; minValue = 0.8;

for ch = chToPlot
    figure; hold on;
    
    for ii = sampleId
        data1 = [cells(ii).intensity; cells(ii+1).intensity; cells(ii+2).intensity; cells(ii+3).intensity];
        idx = any(data1 > tooHigh, 2);
        data1 = data1(~idx,:);
      
        cdx2 = data1(:,ch)./data1(:,dapi);
%         if ii == 1
%             cdx2(cdx2>1) = [];
%         end
%         cdx2(cdx2<minValue) = [];
        mean(cdx2)
        histogram(cdx2, 'Normalization', 'Probability', 'BinWidth', 0.1, 'DisplayStyle', 'Stairs', 'LineWidth', 3);
    end
    legend(meta.sampleNames);
    xlabel([upper(meta.channelNames{ch}) ' intensity (a.u.)']); ylabel('Fraction of cells');
    ax = gca; ax.FontSize = 25; ax.FontWeight = 'bold';
end
%%
saveInPath = '/Volumes/sapnaDrive2/190304_cellsInDish_BMP_SB_IWP2_kongData/distributions_gata3';
saveAllOpenFigures(saveInPath);
%%
% -----------------------------------------------------------------------------------
%% save sample images from paper. 

channelOrder = [1 2]; %[dapi, sox2, cdx2]. % order to save images

channelNames = {'dapi', 'gata3'}; % order in which images were taken
imageFiles = {'m1b.tif', 'm2b.tif', 'm3a.tif', 'm4d.tif'};
imageOrder = [1:4; [2 3 1 4]]; % starting with image with highest expression in each channel
saveInPath = '/Volumes/sapnaDrive2/190304_cellsInDish_BMP_SB_IWP2_kongData/sampleImages_dapiGata3';
mkdir(saveInPath);
%%
iFactor = [1 2.5]; % multplies minimum and maximum display intensity with this factor
counter = 1;
for ch = channelOrder
    filePrefix1 = channelNames{ch};
    for ii = imageOrder(counter,:)
        image1 = imread(imageFiles{ii}, ch);
        image1 = smoothAndBackgroundSubtractOneImage(image1,1.5);
        if ii == imageOrder(counter,1)
            intensities = iFactor(ch)*stretchlim(image1);
        end
        image2 = imadjust(image1, intensities);
        figure; imshow(image2,[]);
        
        filePrefix2 = meta.sampleNames{ii};
        imwrite(image2, [saveInPath filesep filePrefix1 '_' filePrefix2 '.tif']);
    end
    counter = counter+1;
end

%%

file1 = 'w2d.tif';

image1 = imread(file1,ch);
image1 = smoothAndBackgroundSubtractOneImage(image1,1.5);
intensities = stretchlim(image1);

image2 = imadjust(image1, intensities);
figure; imshow(image2);




















