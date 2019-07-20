%% write a new function to get one spot intensities from spot masks.

masterFolderPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170914_WntLowHighDensity_timeCourse';
spotFolders = {'nodalImages', 'leftyImages'};
%%
spotMode = zeros(length(spotFolders), size(rawImages,1));

for ch = 1:2 % channel for which spot intensity is calculated
    spotMasksFolderPath = [masterFolderPath filesep spotFolders{ch}];
    allMasks = dir([spotMasksFolderPath filesep '*.h5']);
    
    for ii = 1:length(allMasks)
        maskPath = [spotMasksFolderPath filesep allMasks(ii).name];
        mask = readIlastikFile(maskPath);
        
        imageNameParts = strsplit(allMasks(ii).name, '_Simple Segmentation');
        imagePrefix = imageNameParts{1};
        imagePath = [masterFolderPath filesep spotFolders{ch} filesep imagePrefix '.tif'];
        
        spotIntensities = zeros(5000,1);
        counter = 1;
        
        for jj = 1:size(mask,3)%loop over different z slices
            maskOne = mask(:,:,jj);
            imageOne = imread(imagePath, jj);
            
            stats = regionprops(maskOne, imageOne , 'Area', 'MeanIntensity', 'Centroid', 'PixelIdxList');
            stats = stats([stats.Area] < 9 & [stats.Area] > 4);
            bla = [stats.MeanIntensity]';
            spotIntensities(counter:counter+size(bla,1)-1) = bla;
            counter = counter+size(bla,1);
        end
        
        spotIntensities = spotIntensities(1:find(spotIntensities, 1, 'last'));
        
        bins = 50:50:4100;
        n = hist(spotIntensities, bins);
        [~,idx] = max(n);
        spotMode(ch, ii) = bins(idx);
        
    end
end
%%
figure; plot([1:length(allMasks)], spotMode(ch,:), 'k-*');
hold on;

newSamples = [1 6 11 16 21 27 35 42 49 57];
values = spotMode(ch, [newSamples]);
plot(newSamples, values, 'r*');

xlabel('samples');
ylabel('intensities');


%%
oneSpotIntensities = mean(spotMode,2);
nodalSpot = oneSpotIntensities(1)
leftySpot = oneSpotIntensities(2)

%% ------------------------- save spot intensities in separate output file.
outputFilePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170914_WntLowHighDensity_timeCourse/spotInformation.mat';
save(outputFilePath, 'spotFolders', 'oneSpotIntensities');
%% -------------- plot spot intensities for every sample.

newSamples = [1 6 11 16 21 27 35 42 49 57];
values = spotMode(1, [newSamples]);

figure; 
subplot(1,2,1);
plot([1:length(allMasks)], spotMode(1,:), 'k-*');
hold on;
plot(newSamples, values, 'r*');

title('Nodal');
xlabel('Samples');
ylabel('Spot Intensitites');


subplot(1,2,2);
values = spotMode(2, [newSamples]);
plot([1:length(allMasks)], spotMode(2,:), 'k-*');
hold on;
plot(newSamples, values, 'r*');

title('Lefty');
xlabel('Sample');
ylabel('Spot Intensitites');










