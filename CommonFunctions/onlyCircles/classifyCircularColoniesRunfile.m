%%

masterFolderPath = '/Volumes/SAPNA/170612_FISHmp';
samplesInfo = dir([masterFolderPath filesep 'RawData']);

counter = 1;
outputFiles = cell(1, length(samplesInfo));
%%
for ii = 6:length(samplesInfo)
    outputFilesInfo = dir([samplesInfo(ii).folder filesep samplesInfo(ii).name filesep ...
        'outputFiles' filesep '*.mat']);
    for jj = 1:length(outputFilesInfo)
        outputFile = [outputFilesInfo(jj).folder filesep outputFilesInfo(jj).name];
        outputFiles{counter} = outputFile;
        counter = counter+1;
        classifyCircularColoniesBasedOnRadii(outputFile);
    end
end
 clearvars -except outputFiles
%%






















