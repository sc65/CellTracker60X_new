
%%
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/Lsm20X/allConditionsMoreImages/smad2_data/plate1';
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
%%
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
%% ----- Figure 6B
radialAverage = struct;
ch = 4;
radialAverage.IWP2_10h = squeeze(permute(coloniesRA{4}(ch,:,:), [1 3 2]));
radialAverage.IWP2_20h = squeeze(permute(coloniesRA{6}(ch,:,:), [1 3 2]));
radialAverage.IWP2_30h = squeeze(permute(coloniesRA{8}(ch,:,:), [1 3 2]));
radialAverage.IWP2_40h = squeeze(permute(coloniesRA{10}(ch,:,:), [1 3 2]));
%%

ch = 1;
rA1 = mean(radialAverage(ch).NoLDN);
rA2 = mean(radialAverage(ch).IWP2_10h);
rA3 = mean(radialAverage(ch).IWP2_20h);
rA4 = mean(radialAverage(ch).IWP2_30h);
rA5 = mean(radialAverage(ch).IWP2_40h);

rA_max = max(rA1);
figure; hold on;
allRA = {rA1, rA2, rA3, rA4, rA5};
for ii = 1:numel(allRA)
    plot(xValues, allRA{ii}/rA_max);
end
%%
Fig6B = radialAverage;
%%
%%
%% ----- Figure 6A
radialAverage = struct;
ch = 4;
radialAverage.NoLDN = squeeze(permute(coloniesRA{2}(ch,:,:), [1 3 2]));
radialAverage.LDN_0h = squeeze(permute(coloniesRA{11}(ch,:,:), [1 3 2]));
radialAverage.LDN_10h = squeeze(permute(coloniesRA{12}(ch,:,:), [1 3 2]));
radialAverage.LDN_15h = squeeze(permute(coloniesRA{13}(ch,:,:), [1 3 2]));
radialAverage.LDN_25h = squeeze(permute(coloniesRA{15}(ch,:,:), [1 3 2]));
radialAverage.LDN_35h = squeeze(permute(coloniesRA{16}(ch,:,:), [1 3 2]));
%%

ch = 1;
rA1 = mean(radialAverage(ch).NoLDN);
rA2 = mean(radialAverage(ch).LDN_0h);
rA3 = mean(radialAverage(ch).LDN_10h);
rA4 = mean(radialAverage(ch).LDN_15h);
rA5 = mean(radialAverage(ch).LDN_25h);

rA_max = max(rA1);

figure; hold on;
allRA = {rA1, rA2, rA3, rA4, rA5};
for ii = 1:numel(allRA)
    plot(xValues, allRA{ii}/rA_max);
end
%%
Fig6A = radialAverage;
%%
saveInFolder = '/Volumes/sapnaDrive2/190713_FiguresData';
file = [saveInFolder filesep 'Figure6.mat'];
save(file, 'Fig6A', 'Fig6B', 'bins');
%%
%% ---------- Figure 7
radialAverage = struct;
ch = 3;
radialAverage.Control = squeeze(permute(coloniesRA{2}(ch,:,:), [1 3 2]));
radialAverage.IWP2_0h = squeeze(permute(coloniesRA{3}(ch,:,:), [1 3 2]));
radialAverage.NodalKO = squeeze(permute(coloniesRA{19}(ch,:,:), [1 3 2]));

ch = 1;
rA1 = mean(radialAverage(ch).Control);
rA2 = mean(radialAverage(ch).IWP2_0h);
rA3 = mean(radialAverage(ch).NodalKO);

rA_max = max(rA1);

figure; hold on;
allRA = {rA1, rA2, rA3};
for ii = 1:numel(allRA)
    plot(xValues, allRA{ii}/rA_max);
end
%%
Fig7 = radialAverage;
%%
file = [saveInFolder filesep 'Figure7.mat'];
save(file, 'Fig7', 'bins');













