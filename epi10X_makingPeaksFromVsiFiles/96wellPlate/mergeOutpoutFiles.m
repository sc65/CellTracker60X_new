
%% combine good colonies from 2 outputFiles and calculate average radial average
clearvars; close all;

controlFile = [masterFolder filesep 'control1.mat'];
load(controlFile);

masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1';
conditions = [4 5];

rAcolonies_all = cell(1, length(conditions));
nPixels_all = rAcolonies_all;
rawImages_all = rAcolonies_all;

counter = 1;
for ii = conditions
   outputFile1 =  [masterFolder filesep 'tiffFiles' filesep 'Condition' int2str(ii) filesep 'output.mat'];
   load(outputFile1, 'rA_colonies', 'nPixels', 'colonyIds_good', 'rawImages_good');
   
   rAcolonies_all{counter} = rA_colonies(:,[colonyIds_good],:);
   nPixels_all{counter} = nPixels(:, [colonyIds_good]);
   rawImages_all{counter} = rawImages_good;
   
   counter = counter+1;
end

%%
rA_colonies_new = cat(2, rAcolonies_all{:});
nPixels_new = cat(2, nPixels_all{:});
rawImages_new = cat(1, rawImages_all{:});
%%
[rA_all, rA_all_stdError] = calculateAverage_rA_givenColonies_rA(rA_colonies_new, nPixels_new);

%%
xValues = (bins(1:end-1)+bins(2:end))./2;
rA_all_norm = rA_all./max(rA_all,[],1);
rA_all_stdError_norm = rA_all_stdError./max(rA_all,[],1);

figure; hold on;
for ii = 1:3
    errorbar(xValues', rA_all_norm(:,ii), rA_all_stdError_norm(:,ii));
end
%%
maxRa = max(rA_all,[],1);
channels = {'T', 'Sox2', 'Cdx2'};

conditions = [4 5];
save(controlFile, 'maxRa', 'channels', 'conditions', 'rA_all', 'rA_all_stdError_norm', '-append');
%%

