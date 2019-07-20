%% ---------------------------

% for snail, pool data from both imaging sessions for all samples

masterFolder = '/Volumes/sapnaDrive2/snail_check/April11-2019 20x sox2-nanog-oct4';
samplesFolder = [masterFolder filesep 'processedData']; % get sample names
samples = dir(samplesFolder);
toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
%%

%for ii = 1:numel(samples)
outputFile1 = [samplesFolder filesep samples(1).name '/output.mat'];
load(outputFile1, 'colonies', 'goodColoniesId');
colonies1 = colonies;
gIdx = goodColoniesId;

outputFile2 = [samplesFolder filesep samples(2).name '/output.mat'];
load(outputFile2, 'colonies', 'goodColoniesId');
colonies2 = colonies;
gIdx = [gIdx goodColoniesId+numel(gIdx)]

colonies3 = [colonies1, colonies2];

[rA{1}, cc(1,:)] = computeCombinedRadialAverage(colonies3, gIdx);
%end
%%
rA_max = max(rA{1}.dapiNormalized.mean,[],1);
rA_max_snail = rA_max(4);

%% -----------------------------------------------------------------------------
%% ----- copy relevant data in a separate output file - average radial
% profile - all channels, all conditions.

% 1) channelOrder
% 2) sampleOrder
% 3) radialProfile
%  ----- structure with mean, standard deviation, standard error (for all channels)

%% ----------------------------------------------------------------------------
channels = {'snail', 'nanog' 'sox2', 'oct4', 'ecadherin'};
%%
% ---- snail data
for ii = 1:4
    rP{ii,1}.mean(1,:) = [rA{ii}.dapiNormalized.mean(:,4)]';
    rP{ii,1}.std(1,:) = [rA{ii}.dapiNormalized.std(:,4)]';
    rP{ii,1}.stdError(1,:) = [rA{ii}.dapiNormalized.stdError(:,4)]';
end
%%
colonyCounter(:,:,1) = cc;
%%
% add sox2, nanog data
samplesFolder = [masterFolder filesep 'snail_sox2_nanog/processedData'];
for ii = 1:numel(samples)
    outputFile1 = [samplesFolder filesep samples(ii).name '/output.mat'];
    load(outputFile1, 'colonies', 'goodColoniesId');
    [rA{ii}, cc(ii,:)] = computeCombinedRadialAverage(colonies, goodColoniesId);
end
%%
counter = 2;
columnsToAdd = [2 3]; %[nanog sox2];

for jj = columnsToAdd
    for ii = 1:4
        rP{ii,counter}.mean = [rA{ii}.dapiNormalized.mean(:,jj)]';
        rP{ii,counter}.std = [rA{ii}.dapiNormalized.std(:,jj)]';
        rP{ii,counter}.stdError = [rA{ii}.dapiNormalized.stdError(:,jj)]';
    end
    colonyCounter(:,:,counter) = cc;
    counter = counter+1;
end

%%

% add oct4 ecadherin data
samplesFolder = [masterFolder filesep 'snail_ecadh_oct4/processedData'];
for ii = 1:numel(samples)
    outputFile1 = [samplesFolder filesep samples(ii).name '/output.mat'];
    load(outputFile1, 'colonies', 'goodColoniesId');
    [rA{ii}, cc(ii,:)] = computeCombinedRadialAverage(colonies, goodColoniesId);
end
%%
counter = 4;
columnsToAdd = [2 3]; %[oct4 ecadherin];

for jj = columnsToAdd
    for ii = 1:4
        rP{ii,counter}.mean = [rA{ii}.dapiNormalized.mean(:,jj)]';
        rP{ii,counter}.std = [rA{ii}.dapiNormalized.std(:,jj)]';
        rP{ii,counter}.stdError = [rA{ii}.dapiNormalized.stdError(:,jj)]';
    end
    colonyCounter(:,:,counter) = cc;
    counter = counter+1;
end
%%
masterOutputFile = [masterFolder filesep 'output_rA.mat'];
radialProfile = rP;
samples = [{samples.name}'];
%%
save(masterOutputFile, 'radialProfile', 'colonyCounter', 'channels', 'samples', 'bins');






















