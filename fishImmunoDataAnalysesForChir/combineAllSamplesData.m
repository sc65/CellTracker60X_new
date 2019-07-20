function combineAllSamplesData(nSamples)
%% combine data for all positions in one timepoint.
% nSamples - number of different samples/conditions.

allSamplesData = cell(1,nSamples);
imagesPath = allSamplesData;

for ii = 1:nSamples
    ii
    outputFile = ['output_' int2str(ii) '.mat'];
    load(outputFile);
    data = cat(1, peaks{:});
    allSamplesData{ii} = data;
    imagesPath{ii} = oneSamplePath;
    
end

save('allSamplesData.mat', 'allSamplesData', 'imagesPath');