%% make maxZ images for iLastik - Dapi, Nodal, T Channels.
%% works for outPut (multiTiff Images) from LSM
clearvars;
masterFolderPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170914_WntLowHighDensity_timeCourse';
rawImagesPath = [masterFolderPath filesep 'rawData'];
[rawImages, start] = startPositionFunctionDir(rawImagesPath);
rawImages(1:start-1) = [];
%%
newChannelFolders = {'dapiImages', 'nodalImages', 'leftyImages'}; %to store Z images for training iLastik.
%newChannelFolders = {'rfpImages'};
for ii = 1:length(newChannelFolders)
    mkdir([masterFolderPath filesep newChannelFolders{ii}]);
end
t = 1; %Analysing fixed cell data.
%%
% dapi max Z images for nuclear mask
% channels = [1 3 4]; %[Dapi T Nodal] - mRNA Channels - for ilastik 
channels = [1];
writeMaxZImagesIlastikLSM(masterFolderPath, rawImagesPath, newChannelFolders, rawImages, channels);
%%
% mRNA all z images for spot mask
% channels = [3 4]; % for mRNA channles, separate the tif files of the
% individual z slices. 
channels = [4 3];
newChannelFolders = {'nodalImages', 'leftyImages'};
writeZImagesIlastikLSM(masterFolderPath, rawImagesPath, newChannelFolders, rawImages, channels)

%% --------------- train ilastik to identify nuclei (nucleiMask) and spots (spotsMask) ----------------

% run the file - getOneSpotIntensities.
%%
spotOutputFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/withMiki/170914_WntLowHighDensity_timeCourse/spotInformation.mat';
load(spotOutputFile);
%%
nodalSpot = oneSpotIntensities(1)
leftySpot = oneSpotIntensities(2)
%%
oneSpotIntensities = [nodalSpot leftySpot];
%% make peaks
tic;
makePeaksLSM_FISHImmuno(masterFolderPath, oneSpotIntensities)
toc;












