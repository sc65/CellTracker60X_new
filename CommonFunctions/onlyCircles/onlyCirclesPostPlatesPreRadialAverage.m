
%%
masterFolder = '/Volumes/SAPNA/170825_smad2_bestSeeding_Idse';
nSamples = 11;

outputFiles = cell(1,nSamples);
for ii = 1:nSamples
    outputFiles{ii} = [masterFolder filesep 'MMdirec' int2str(ii) filesep 'output1.mat'];
end
%% Based on colony radius, classify the circles into shapes 1-4, from the
% largest to the smallest

% shape1 - radius = 500 um, range = 450 - 550 um
% shape2 - radius = 400 um, range = 360 - 440 um
% shape3 - radius = 250 um, range = 225 - 275 um
% shape4 - radius = 100 um, range = 90 - 110 um
% shape5 - radius = 50 um, range = 45 - 55 um
%% ---------------- classify colonies.
% plot radial averages.
% cell-cell smad2 vs T, smad2 vs Sox2; smad1 vs CDX2;
% bCat vs T, bCat vs Sox2

for ii = 4:5
    classifyCircularColoniesBasedOnRadii(outputFiles{ii});
    mkFullCytooPlot(outputFiles{ii});
end
%% ----------------- pick a file for further analyses
close all;
sampleNum = 1;
outputFile = outputFiles{sampleNum};
load(outputFile);
%% ----------------- Filter colonies
for shapeNum = 2
    coloniesInShape = find([plate1.colonies.shape] == shapeNum);
    figure;
    counter = 1;
    for ii = coloniesInShape
        if ~mod(counter,100)
            figure;
            counter = 1;
        end
        xy = plate1.colonies(ii).data(:,1:2);
        xy = xy - mean(xy); %centers the colony at (0,0).
        subplot(4,4, counter);
        plot(xy(:,1), xy(:,2), 'k.');
        title(['cId' int2str(ii)]);
        counter = counter+1;
    end
end
%%
nCells = [plate1.colonies([coloniesInShape]).ncells];
toRemove = find(nCells < 800);
%messed up colonies - change the shape to 0.
toRemoveColonies = coloniesInShape(toRemove);
%%
toRemoveColonies = [2 ];
for ii = toRemoveColonies
    plate1.colonies(ii).shape = 0;
end
%%
%coloniesToCorrect = coloniesInShape;
coloniesToCorrect = [1 9 14 15];
plate1 = removeCellsNotInColony(plate1, coloniesToCorrect);
%% -------------------------------------------------
%% -------------------------- check fluorescence
% removing cells above a given fluorescence.
for columnNum = [5 6 8 10]
    plotHistogramOfExpressionLevelsAllColonies(plate1, shapeNum, columnNum)
end

%%
fluorescence = [5000 5000 10000 4000];
counter = 1;
for columnNum = [5 6 8 10]
    plate1 = removeCellsAboveFluorescence(plate1, coloniesInShape, columnNum, fluorescence(counter));
    counter = counter+1;
end
%%
save(outputFile, 'plate1', '-append');

%% -------------------------- make colony images
for ii = 1:nSamples
    rawImagesPath = [masterFolder filesep 'MMdirec' int2str(ii)];
    saveInPath = [masterFolder filesep 'colonyImages' filesep 'sample' int2str(ii)];
    mkdir(saveInPath);
    
    outputFile = outputFiles{ii};
    load(outputFile, 'plate1', 'acoords');
    makeColonyImages_mm(rawImagesPath, saveInPath, plate1, acoords, shapeNum);
end
%% -------------------------- make master output files
samplesToCombine = {[1 2], [3 4], 5, 6, 7, [8 9], [10 11]};
sampleNames =  strcat(strsplit(int2str([24:4:48]), ' '), 'h');

for ii = 1:length(samplesToCombine)
    oldOutputFiles = cell(1, length(samplesToCombine{ii}));
    for jj = 1:length(samplesToCombine{ii})
      oldOutputFiles{jj} = outputFiles{samplesToCombine{ii}(jj)};
    end
    newOutputFile = [masterFolder filesep 'masterOutputFiles' filesep ...
        'output' sampleNames{ii} '.mat'];
    
    makeMasterOutputFile(oldOutputFiles, newOutputFile);
end

%%


