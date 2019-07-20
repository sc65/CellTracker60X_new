function makeColonyImages_mm(rawImagesPath, saveInPath, plate1, acoords, shapeNum)

%% saving original images.
%rawImagesPath = '/Volumes/SAPNA/170726_pluripotencyTest_nanogSox2Smad2/MMdirec1';
%saveInPath = '/Volumes/SAPNA/170726_pluripotencyTest_nanogSox2Smad2/originalColonyImages';
mkdir(saveInPath);

%shapeNum = 2;
saveInPath = [saveInPath filesep 'shape' int2str(shapeNum)];
mkdir(saveInPath);

coloniesInShape = find([plate1.colonies.shape] == shapeNum);

for ii = coloniesInShape
    ii
    im = plate1.colonies(ii).assembleColonyMM(rawImagesPath, acoords, [2048 2048]);
    fileName = [saveInPath filesep 'colony' int2str(ii) '.tif'];
    
    for jj = 1:4
        if jj == 1
            imwrite(im{jj}, fileName);
        else
            imwrite(im{jj}, fileName, 'Writemode', 'append');
        end   
    end
end
