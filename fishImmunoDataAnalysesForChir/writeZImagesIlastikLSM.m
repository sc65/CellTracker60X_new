function writeZImagesIlastikLSM(masterFolderPath, rawImagesPath, newChannelFoldersPath, rawImages, channels)
%% a function that writes all z images as tiff files for every channel(channel number corresponding to channels - see below)
% for every file in the rawData.
%% ------------- Inputs -------------
% masterFolderPath - path to the masterFolder - containing rawData and output files.
% rawImagesPath - [masterFolder filesep rawData]
% newChannelFolders - path to the new folders - one for each channel - for
% making masks for Ilastik.
% channels - channel number (order in which that channel was imaged)
% corresponding to the channel for which you need iLastik masks.

%%
%channels = [1 3 4]; %[Dapi T Nodal]
t = 1;

for ch = 1:length(newChannelFoldersPath) % ---loop over new folders for Ilastik
    for ii = 1:length(rawImages) % ---loop over input files in rawData
        
        filePath = [rawImagesPath filesep rawImages(ii).name];
        
        [fileInfo, start] = startPositionFunctionDir(filePath);
        fileInfo(1:start-1) = [];
        
        fileInfo = fileInfo([fileInfo.isdir]); %exclude the log file.
        allPositions = length(fileInfo);
        
        %%--------- get images------------
        for jj = 1:allPositions
            newFileNamePrefix = [rawImages(ii).name '_Track' int2str(jj)];
            newfilePath = [masterFolderPath filesep newChannelFoldersPath{ch} filesep newFileNamePrefix '.tif'];
        
            imageInfo = dir([filePath filesep fileInfo(jj).name filesep '*.oif']);
            imagePath = [filePath filesep fileInfo(jj).name filesep imageInfo.name];
            reader = bfGetReader(imagePath);
            
            nZslices = reader.getSizeZ;
            
            for kk = 1:nZslices
                iPlane = reader.getIndex(kk-1,channels(ch)-1,t-1) + 1;
                imageToWrite = bfGetPlane(reader, iPlane);
                imageToWrite =  SmoothAndBackgroundSubtractOneImage(imageToWrite);
                
                if kk == 1
                    imwrite(imageToWrite, newfilePath);
                else
                    imwrite(imageToWrite, newfilePath, 'WriteMode', 'append');
                end
                    
            end
        end
    end
end