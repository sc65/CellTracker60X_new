function makeColonyImages_mm_separateChannels(rawImagesPath, saveInPath, plate1, acoords, shapeNum, colonyPrefix)

%% saving original colony images.
%rawImagesPath = '/Volumes/SAPNA/170726_pluripotencyTest_nanogSox2Smad2/MMdirec1';
%saveInPath = '/Volumes/SAPNA/170726_pluripotencyTest_nanogSox2Smad2/originalColonyImages';
mkdir(saveInPath);

%shapeNum = 2;
saveInPath = [saveInPath filesep 'shape' int2str(shapeNum)];
mkdir(saveInPath);

coloniesInShape = find([plate1.colonies.shape] == shapeNum);
if ~isempty(coloniesInShape)
    for ii = coloniesInShape
        ii
        im = plate1.colonies(ii).assembleColonyMM(rawImagesPath, acoords, [2048 2048]);
        
        for jj = 1:4
            if exist('colonyPrefix', 'var')
                fileName = [saveInPath filesep colonyPrefix 'colony' int2str(ii) '_ch' int2str(jj) '.tif'];
            else
                fileName = [saveInPath filesep 'colony' int2str(ii) '_ch' int2str(jj) '.tif'];
            end
            imwrite(im{jj}, fileName);
        end
    end
end
