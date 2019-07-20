%%
clearvars;
masterFolder = '/Volumes/SAPNA/170825_smad2_bestSeeding_Idse/LsmData_30X/alignedImages';
outputFiles = cell(1, 7);

counter = 1;
for ii = 24:4:48
    outputFiles{counter} = [masterFolder filesep int2str(ii) 'h' filesep 'output_' int2str(ii) 'h.mat'];
    counter = counter+1;
end

%%
