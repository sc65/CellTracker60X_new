
%% ------ analyzing bCat live cell movies
% ------- How does inhibition of Wnt and Nodal signaling affect the level and range of beta-catenin
% signaling activity?
% 1) save non-membrane movies all colonies
% 2) plot radial average, individual colonies all timepoints
% 3) plot average radial average for one condition
% 4) plot front movement, position for all conditions

%%
% read files
masterFolder = '/Volumes/sapnaDrive2/190605_bCatLiveCell';
colonyMask_timepoints = [1 12]; % specify imaging break points

metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);
samplesFolder = [masterFolder filesep 'processedData'];
samples = dir(samplesFolder);

toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
samples = samples(toKeep);
[~, idx] = natsortfiles({samples.name});
samples = samples(idx);

%%
ch = find(cell2mat(cellfun(@(c)strcmp(c,'BETACATENIN'),upper(meta.channelNames),'UniformOutput',false)));
% make colonyMaksId array - to know when to use which mask
timeIds = [colonyMask_timepoints meta.nTime+1];
counter = 1;
for ii = 1:numel(timeIds)-1
    colonyMasksId(:, counter:timeIds(ii+1)-1) = ii;
    counter = timeIds(ii+1);
end
%% ------------- 1) nonMembrane movies
for ii = 1:size(samples,1)
    tic;
    disp(['Sample ' int2str(ii)]);
    outputFile = [samples(1).folder filesep samples(ii).name filesep 'output.mat'];
    load (outputFile);
    
    nColonies = numel(colonies);
    for jj = 1:nColonies
        makeNonMembraneMovies(colonies(jj), meta, ch, colonyMask_timepoints, colonyMasksId)
    end
    
    toc;
end
%% ----------------------------------------------------------------
%% ------------- 2) individual colonies, rA plots
timepoints_h = [24:34 35.5 36.5:59.5]; 
timepoints_id = 1:10:meta.nTime;
xValues = (bins(1:end-1)+bins(2:end))/2;
colors = colorcube(meta.nTime);
%%
for ii = 6
    close all;
%for ii = 1:size(samples,1)
    disp(['Sample ' int2str(ii)]);
    samplePath = [samples(1).folder filesep samples(ii).name];
    outputFile = [samplePath filesep 'output.mat'];
    load (outputFile);
    nColonies = numel(colonies);
    
    for jj = 1:nColonies
        rA1 = squeeze(colonies(1).radialProfile.notNormalized.mean);
 
        for kk = timepoints_id
            figure; hold on;
            if kk == timepoints_id(end)
                t_all = kk:meta.nTime;
            else
                t_all = kk:kk+10;
            end
            for ll = t_all
                if ll < t_all(6)
                    lineWidth = 2;
                else
                    lineWidth = 5;
                end
                plot(xValues, rA1(:,ll)', 'LineWidth', lineWidth);
            end
            ylim([100 450]);
            legend(strcat(strsplit(num2str(timepoints_h(t_all)), ' '), ' h'));
            xlabel('Distance from edge (\mum)');
            ylabel('beta-catenin levels (a.u.)');
            title(['colony' int2str(jj)]);
            ax = gca; ax.FontSize = 20; ax.FontWeight = 'bold';
        end
    end
    saveInPath = [samplePath filesep 'coloniesRA'];
end
saveAllOpenFigures(saveInPath);

%%