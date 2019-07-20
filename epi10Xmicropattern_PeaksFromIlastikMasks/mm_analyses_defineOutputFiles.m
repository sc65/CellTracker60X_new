%% ------------------- define output files ---------------------
clearvars;
masterFolder = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/33h';
subFolders = {'t33_800_q2_500_q3_4', 't33_q1', 't33_q4'};
outputFileNum = [1 1 1];

outputFiles = cell(1,3);

for ii = 1:3
    outputFiles{ii} = [masterFolder filesep subFolders{ii} filesep 'outputFiles' filesep 'output_' ...
        int2str(outputFileNum(ii)) '.mat'];
end

%% ---------------------------- make colony images of good colonies -----------------------
%%
for ii = 1:3
    saveInPath1 = [masterFolder filesep  subFolders{ii} filesep ...
        'OriginalImagesGoodColonies_800_' int2str(outputFileNum(ii))];
    mkdir(saveInPath1);
    
    outputFile = outputFiles{ii};
    load(outputFile, 'plate1');
    
    for shapeNum = 2
        saveInPath = [saveInPath1 filesep 'Shape' int2str(shapeNum)];
        mkdir(saveInPath);
        colonyNum = find([plate1.colonies.shape]==shapeNum);
        if shapeNum == 4
            colonyNum = colonyNum(1:8);
        end
        saveOriginalImagesCorrectIndicesGoodColonies(outputFile,  saveInPath, colonyNum);
    end
end

%% --------------------------- making master output file ------------------------------
%%
oldOutputFiles = {outputFiles{1}}; 
newOutputFile = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/masterOutputFiles/800um_imagingSession2/output_33h.mat';

makeMasterOutputFile(oldOutputFiles, newOutputFile);



















