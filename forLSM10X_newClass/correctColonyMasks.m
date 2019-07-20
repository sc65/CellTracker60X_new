

clearvars;
masterFolder = '/Volumes/SAPNA/190712_bCatNogginLDN';
metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);
%%
samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
[~, idx] = natsortfiles({samples.name});
samples = samples(idx);
%%
close all;
for ii = 1:8
    image1 = imread(['Colony' int2str(ii) '_ch3.tif']);
    image1 = imadjust(image1);
    mask1 = imread(['Colony' int2str(ii) '_colonyMask.tif']);
    mask1 = imerode(mask1, strel('disk', 3));
    
    imwrite(mask1, ['Colony' int2str(ii) '_colonyMask.tif']);
    figure; imshowpair(image1, mask1); title(['Colony' int2str(ii)]);
    
end