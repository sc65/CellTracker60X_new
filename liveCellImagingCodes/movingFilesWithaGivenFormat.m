%% put all the matlab codes in a new folder.


%%
% find files

allFiles = dir('*/*/*/*.m');
saveinFolder = '/Volumes/SAPNA/161014LiveCellLaserScanning/matlabCodes';
mkdir(saveinFolder);

for ii = 1:length(allFiles)
    if ~strcmp(allFiles(ii).name(1), '.')
        fromLocation = [allFiles(ii).folder filesep allFiles(ii).name];
        toLocation = saveinFolder;
        movefile(fromLocation, toLocation);
    end
end
