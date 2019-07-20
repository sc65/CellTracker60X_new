%% runFile - making peaks array using tiff files and masks

clearvars;
rawImagesPath = '/Volumes/sapnaDrive2/181021_mediaChange_IWP2_17_34/Folder_20181021/tifffiles';
conditions = 1:10;
dapiChannel = 1; % channel number (in the order of channels imaged)
nChannels = 3;
%% start with condition1
for ii = 1:numel(conditions)
    ii
    rawImages1_path = [rawImagesPath filesep 'Condition' int2str(ii) '/colonies'];
    outputFile1_path = [rawImagesPath filesep 'Condition' int2str(ii)];
    makePeaksForTiffFiles_96wellPlate(rawImages1_path, outputFile1_path,  ii, dapiChannel, nChannels);
end
%%
