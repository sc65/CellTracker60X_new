%% classify circular colonies, filter good colonies and make colony images.
clearvars;
masterFolder = '/Volumes/SAPNA/170825_smad2_bestSeeding_Idse';
nSamples = 11;
%%
for ii = 1:nSamples
    ii
    outputFile = [masterFolder filesep 'MMdirec' int2str(ii) filesep 'output1.mat'];
    classifyCircularColoniesBasedOnRadii(outputFile);
end
%%
sampleNum=1;
outputFiles = dir([masterFolder filesep samples{sampleNum} filesep 'outputFiles' filesep '*.mat']);
%%
close all;
fileNum = 2;
outputFile = [masterFolder filesep samples{sampleNum} filesep 'outputFiles' filesep outputFiles(fileNum).name];
load(outputFile)
%%
mkFullCytooPlot(outputFile,1);
%%
% fileNum = 1;
% outputFile = outputFiles{fileNum};
% load(outputFile);
figure;
shapeNum = 3;
coloniesInShape = find([plate1.colonies.shape]==shapeNum);
for ii = 1:length(coloniesInShape)
    subplot(5,4,ii);
    xy = plate1.colonies(coloniesInShape(ii)).data(:,1:2);
    xy(:,1) = xy(:,1) - mean(xy(:,1));
    xy(:,2) = xy(:,2) - mean(xy(:,2));
    plot(xy(:,1), xy(:,2), 'k.');
    title(['Colony' int2str(coloniesInShape(ii))]);
end
%%
% change shape of bad colonies to 0.
coloniesToChange = [44];
for ii = coloniesToChange
    plate1.colonies(ii).shape = 0;
end
%% remove cells that do not belong in the colony.
coloniesInShape = find([plate1.colonies.shape]==shapeNum);
coloniesToCorrect = 11;
plate1 = correctColony9(plate1, coloniesToCorrect);
%%
% removing cells above a particular threshold
for columnNum = [5 6 8 10]
    plotHistogramOfExpressionLevelsAllColonies (plate1, shapeNum, columnNum)
end
%%
coloniesInShape = find([plate1.colonies.shape]==shapeNum);
fluorescence = [5000];
counter = 1;
for columnNum = [8]
    plate1 = removeCellsAboveFluorescence(plate1, coloniesInShape, columnNum, fluorescence(counter));
    counter = counter+1;
end
%%
goodColonies = find([plate1.colonies.shape] > 0);
save(outputFile, 'plate1', 'goodColonies', '-append');
%% -----------------------------------------------------------------
load(outputFile, 'plate1', 'goodColonies');
%%
figure;
coloniesInShape = find([plate1.colonies.ncells]>70);
for ii = 1:length(coloniesInShape)
    subplot(8,9,ii);
    plot(plate1.colonies(coloniesInShape(ii)).data(:,1), plate1.colonies(coloniesInShape(ii)).data(:,2), 'k.');
    title(['Colony' int2str(coloniesInShape(ii))]);
end
%%
goodColonies = [15 22 116 140 171 251 255 269];
%%
plotnum = 1;
figure;
for ii = goodColonies
    subplot(6,4, plotnum);
    plotnum = plotnum+1;
    plot(plate1.colonies(ii).data(:,1), -plate1.colonies(ii).data(:,2), 'k.');
    title(['Colony' int2str(ii)]);
end

%%
%correct imagenumbers
%pick colonies with more than 4 imagenumbers corresponding to them.
%manually check if those imagenumbers are correct.
moreThan4rawImages = false(1,length(goodColonies));
for ii = 1:length(goodColonies)
    if length(plate1.colonies(goodColonies(ii)).imagenumbers) > 4
        moreThan4rawImages(ii) = 1;
    end
end
disp(['Check Colonies' strsplit(int2str(goodColonies(moreThan4rawImages)))]);

%% -----------------------------------------------------------------------------------------------
%% ---------------------------- make colony images of good colonies -----------------------
masterFolder = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/25h';
%%
for fileNum = 2
    saveInPath1 = [masterFolder filesep  samples{sampleNum} filesep ...
        'OriginalImagesGoodColoniesQ' int2str(fileNum)];
    mkdir(saveInPath1);
    
    outputFile = [masterFolder filesep samples{sampleNum} filesep 'outputFiles'...
        filesep outputFiles(fileNum).name];
    load(outputFile, 'plate1');
    
    for shapeNum = 3
        saveInPath = [saveInPath1 filesep 'Shape' int2str(shapeNum)];
        mkdir(saveInPath);
        colonyNum = find([plate1.colonies.shape]==shapeNum);
        if shapeNum == 4
            colonyNum = colonyNum(1:8);
        end
        saveOriginalImagesCorrectIndicesGoodColonies(outputFile,  saveInPath, colonyNum(end-4:end));
    end
end
%%