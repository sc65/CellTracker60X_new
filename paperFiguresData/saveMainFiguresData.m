
%% ----------- save all the data used to make graphs in a separate .mat file for each figure
%% ----------- transfer raw data in figure order to raid array, and also list original location in a file folder

% path to save data
saveInFolder = '/Volumes/sapnaDrive2/190713_FiguresData';

%%
%% ---------------- Figure 1,8,9,6,7 (brachyury, sox2, cdx2 fates; smad2/smad1 signals)

masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate1';
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
toKeep = [1 5 8:15 24:31];
samples = samples(toKeep); %[BMP4 BMP4+IWP2 NODAL-/-]
%%
% save rA values
rA = cell(1,numel(samples)); coloniesRA = rA;
nColonies = zeros(1,numel(samples));

outputFile = [samplesFolder filesep samples(1).name filesep 'output.mat'];
load(outputFile, 'colonies');
bins = colonies(1).radialProfile.bins;
nCh = meta.nChannels;

for ii = 1:numel(samples)
    outputFile = [samplesFolder filesep samples(ii).name filesep 'output.mat'];
    load(outputFile, 'colonies', 'radialProfile_avg', 'goodColoniesId', 'xValues');
    nColonies(ii) = numel(goodColoniesId);
    rA{ii} = radialProfile_avg;
    c1 = zeros(nCh, numel(bins)-1, numel(goodColoniesId));
    for jj = 1:numel(goodColoniesId)
        c1(:,:,jj) = colonies(goodColoniesId(jj)).radialProfile.dapiNormalized.mean;
    end
    coloniesRA{ii} = c1;
end
%%
%% ----------------------- Figure 1A, B
radialAverage = struct;
ch = [2:3];
for ii = 1:2
    radialAverage(ii).bmp = squeeze(permute(coloniesRA{2}(ch(ii),:,:), [1 3 2]));
    radialAverage(ii).bmpIwp2 = squeeze(permute(coloniesRA{11}(ch(ii),:,:), [1 3 2]));
    radialAverage(ii).NodalKO = squeeze(permute(coloniesRA{1}(ch(ii),:,:), [1 3 2]));
end
%%
% check:
ch = 2;
rA1 = mean(radialAverage(ch).bmp);
rA2 = mean(radialAverage(ch).bmpIwp2);
rA3 = mean(radialAverage(ch).NodalKO);

rA_max = max(rA1);
figure; hold on;
allRA = {rA1, rA2, rA3};
for ii = 1:3
    plot(xValues, allRA{ii}/rA_max);
end
%%
Fig1A = radialAverage(1);
Fig1B  = radialAverage(2);
%%
figureFile = [saveInFolder filesep 'Figure1.mat'];
save(figureFile, 'Fig1A', 'Fig1B');
%%

%% ----------------- Figure 8, CDX2, SOX2
radialAverage = struct;
ch = [4 3]; % [cdx2 sox2]
for ii = 1:2
    radialAverage(ii).LDN_0h = squeeze(permute(coloniesRA{3}(ch(ii),:,:), [1 3 2]));
    radialAverage(ii).LDN_10h = squeeze(permute(coloniesRA{4}(ch(ii),:,:), [1 3 2]));
    radialAverage(ii).LDN_20h = squeeze(permute(coloniesRA{6}(ch(ii),:,:), [1 3 2]));
    radialAverage(ii).LDN_30h = squeeze(permute(coloniesRA{8}(ch(ii),:,:), [1 3 2]));
    radialAverage(ii).LDN_40h = squeeze(permute(coloniesRA{10}(ch(ii),:,:), [1 3 2]));
end
%%
% check:
ch = 1;
rA1 = mean(radialAverage(ch).LDN_0h);
rA2 = mean(radialAverage(ch).LDN_10h);
rA3 = mean(radialAverage(ch).LDN_20h);
rA4 = mean(radialAverage(ch).LDN_30h);
rA5 = mean(radialAverage(ch).LDN_40h);

rA_max = max(rA1);
figure; hold on;
allRA = {rA1, rA2, rA3, rA4, rA5};
for ii = 1:numel(allRA)
    plot(xValues, allRA{ii}/rA_max);
end
%%
Fig8.cdx2 = radialAverage(1);
Fig8.sox2  = radialAverage(2);
%%
figureFile = [saveInFolder filesep 'Figure8.mat'];
save(figureFile, 'Fig8', 'bins');

%% -------------- Figure 9, Brachyury
ch = 2;
radialAverage.LDN_0h = squeeze(permute(coloniesRA{3}(ch,:,:), [1 3 2]));
radialAverage.LDN_10h = squeeze(permute(coloniesRA{4}(ch,:,:), [1 3 2]));
radialAverage.LDN_20h = squeeze(permute(coloniesRA{6}(ch,:,:), [1 3 2]));
radialAverage.LDN_30h = squeeze(permute(coloniesRA{8}(ch,:,:), [1 3 2]));
radialAverage.LDN_40h = squeeze(permute(coloniesRA{10}(ch,:,:), [1 3 2]));
%%
Fig9A = radialAverage;
%%
ch = 2;
radialAverage.IWP2_0h = squeeze(permute(coloniesRA{11}(ch,:,:), [1 3 2]));
radialAverage.IWP2_15h = squeeze(permute(coloniesRA{13}(ch,:,:), [1 3 2]));
radialAverage.IWP2_20h = squeeze(permute(coloniesRA{14}(ch,:,:), [1 3 2]));
radialAverage.IWP2_25h = squeeze(permute(coloniesRA{15}(ch,:,:), [1 3 2]));
radialAverage.IWP2_40h = squeeze(permute(coloniesRA{18}(ch,:,:), [1 3 2]));

Fig9B = radialAverage;
%%
ch = 1;
rA1 = mean(radialAverage(ch).IWP2_0h);
rA2 = mean(radialAverage(ch).IWP2_15h);
rA3 = mean(radialAverage(ch).IWP2_20h);
rA4 = mean(radialAverage(ch).IWP2_25h);
rA5 = mean(radialAverage(ch).IWP2_40h);

rA_max = max(rA1);
figure; hold on;
allRA = {rA1, rA2, rA3, rA4, rA5};
for ii = 1:numel(allRA)
    plot(xValues, allRA{ii}/rA_max);
end
%%
figureFile = [saveInFolder filesep 'Figure9.mat'];
save(figureFile, 'Fig9A', 'Fig9B', 'bins');


%%

ch = 2;
radialAverage.SB_0h = squeeze(permute(coloniesRA{11}(ch,:,:), [1 3 2]));
radialAverage.SB_15h = squeeze(permute(coloniesRA{13}(ch,:,:), [1 3 2]));
radialAverage.SB_20h = squeeze(permute(coloniesRA{14}(ch,:,:), [1 3 2]));
radialAverage.SB_25h = squeeze(permute(coloniesRA{15}(ch,:,:), [1 3 2]));
radialAverage.SB_35h = squeeze(permute(coloniesRA{18}(ch,:,:), [1 3 2]));














