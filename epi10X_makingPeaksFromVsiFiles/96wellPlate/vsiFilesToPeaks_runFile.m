%% ---------------convert dapi images to .tif format (ilastik doesn't take .vsi files as input)-----------------
clearvars;

rawImagesPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170901_WntLowHighDensity/rawImages';
newImagesPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170901_WntLowHighDensity/Dapi_images';
mkdir(newImagesPath);

% rawImage specifics
zSlice = 1;
channel = 3; % [smad2 dapi]
timePoint = 1;

%% 
rawImages = dir([rawImagesPath filesep '*.vsi']);
for ii = 1:numel(rawImages)
    %% get the raw dapi image
    rawImage1_path = [rawImagesPath filesep rawImages(ii).name];
    rawImage1_reader = bfGetReader(rawImage1_path);
    rawImage1_plane = rawImage1_reader.getIndex(zSlice-1, channel-1, timePoint-1) + 1;
    rawImage1 = bfGetPlane(rawImage1_reader, rawImage1_plane);
    %% write the dapi image to a tif file
    newImage1_path = [newImagesPath filesep strtok(rawImages(ii).name, '.') '.tif'];
    imwrite(rawImage1, newImage1_path); 
end

%% ------------- do segmentation in ilastik. save segmented masks in the same folder as dapi files -------------------

%% ------------- make peaks array------------------
tic;
peaks1 = cell(1, numel(rawImages));
for ii = 1:numel(rawImages)
    ii
    rawImage1_path = [rawImagesPath filesep rawImages(ii).name];
    rawImage1_reader = bfGetReader(rawImage1_path);
    rawImage1_images = uint16(zeros(2048, 2048, 2));
    
    counter = 1;
    for jj = [2 1]
        rawImage1_plane = rawImage1_reader.getIndex(zSlice-1, jj-1, timePoint-1) + 1;
        rawImage1_images(:,:,counter) = bfGetPlane(rawImage1_reader, rawImage1_plane);
        rawImage1_images(:,:,counter) = SmoothAndBackgroundSubtractOneImage(rawImage1_images(:,:,counter));
        counter = counter+1;
    end
    
    rawImage1_prefix = strtok(rawImages(ii).name, '.');
    nuclearMask1_path = [newImagesPath filesep rawImage1_prefix '_Simple Segmentation.h5'];
    nuclearMask1 = readIlastikFile(nuclearMask1_path);
    areaThresh = 5;
    nuclearMask1 = IlastikMaskPreprocess(nuclearMask1, areaThresh);
    
    donutSize = 5;
    [nuclearMask1, cytoplasmicMask1] = MakeCytoplasmicMaskDonut(nuclearMask1, donutSize);
    peaks1{ii} = MasksToPeaks1(rawImage1_images, nuclearMask1, cytoplasmicMask1);
end
toc;
%% ------------------ make one output file for each sample --------------
outputFilesPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170901_WntLowHighDensity/outputFiles';
samples = 1:6;
sampleNames = {'HD_treatment', 'HD_control', 'LD_treatment', 'LD_control', ...
    'LowDensity_treatment', 'LowDensity_control'};
 

for ii = samples
    startPosition = (ii-1)*6+1;
    peaks = peaks1(startPosition:startPosition+5);    
    oneSamplePath = [sampleNames{ii} '/'];
    outputFile1 = [outputFilesPath filesep 'output' int2str(samples(ii)) '.mat'];
    
    save(outputFile1, 'peaks', 'oneSamplePath');    
end












        
        

