%%
masterFolder = '/Volumes/SAPNA/170703_FISH_nodal_IF_t_bCat/25_29_33_37_47h/20X_LSM/rawData/';
samples = {'t25_q1', 't29_q1_2', 't33_q1', 't33_q4', 't37_q3', 't37_q4'};

%for ii = 5
for ii = 5:length(samples)
    outputFiles = dir([masterFolder filesep samples{ii} filesep 'outputFiles' filesep '*.mat']);
    for jj = 1:numel(outputFiles)
        
        saveInPath1 = [masterFolder filesep  samples{ii} filesep ...
            'OriginalImagesGoodColoniesQ' int2str(jj)];
        mkdir(saveInPath1);
        
        outputFile = [masterFolder filesep samples{ii} filesep 'outputFiles' filesep outputFiles(jj).name];
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
end

%% make new output files with input combined from all output files for 1 colony.
samples = {'29h', '33h', '37h'};
for ii = 1:length(samples)
    parentDirectory = samples(ii);
    newOutputFile = ['output_', samples{ii}, '.mat'];
    makeMasterOutputFile(parentDirectory, newOutputFile);
end
%%


























