function saveOriginalImagesCorrectIndicesGoodColonies(outputFile,  saveInPath, colonyId)
%% ----------- Input-------------
% outputFile: 'output.mat' file.
% saveInPath: full path to the directory where you want to save original
% overlaid images.
% colonyId: Id of the colony for which you want to run the function. (give
% an array, if more than 1).
%%
%load(outputFile, 'plate1');
for ii = colonyId
    ii
    [alignedColonyImage, ~] = assembleColonyLSM(outputFile, ii);
    %plate1.colonies(ii).data = alignedColonyData;
    newfileName = [saveInPath filesep 'Colony' int2str(ii) '.tif'];
    alignedColonyImage = uint16(alignedColonyImage);
    for jj = 1:size(alignedColonyImage,3)
        
        if jj == 1
            imwrite(alignedColonyImage(:,:,jj), newfileName);
        else
            imwrite(alignedColonyImage(:,:,jj), newfileName, 'WriteMode', 'append');
        end
    end
end
