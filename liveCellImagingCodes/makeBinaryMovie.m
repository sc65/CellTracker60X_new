function makeBinaryMovie(ilastikMaskPath, saveInPath, trackIds)
%% make a binary movie from .h5 segmentation file returned by Ilastik.
%----------------Inputs--------------
%---ilastikMaskPath - path to the segmentation masks returned by ilastik.
%---saveInPath - path to save the binary movies.
%---trackIds - trackIds (Movie Ids), corresponding to individual colonies. 
%-------------------------------------

%ilastikMaskPath = '/Volumes/SAPNA/170201LiveCellImaging/ilastikMasks';
maskFiles = dir([ilastikMaskPath filesep '*Segmentation.h5']);

%saveInPath = '/Volumes/SAPNA/170201LiveCellImaging/images/binaryMovies';
mkdir(saveInPath);

for ii = trackIds
%for ii = 1:length(maskFiles)
    maskName = [ilastikMaskPath filesep (maskFiles(ii).name)];
    mask = readIlastikFile(maskName);
    threshold = 5;
    maskNew = uint16(IlastikMaskPreprocess(mask, threshold));
    
    fileNamePosition = strfind(maskFiles(ii).name, 'ch1');
    saveInImagePath = [saveInPath filesep maskFiles(ii).name(1:fileNamePosition-1) '.tif'];
    
    for jj = 1:size(maskNew,3)
        if jj == 1
            imwrite(maskNew(:,:,jj), saveInImagePath);
        else
            imwrite(maskNew(:,:,jj), saveInImagePath, 'writemode', 'append');
        end
    end
end
%%

