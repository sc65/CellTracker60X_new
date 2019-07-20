%% for all control conditions (40h, no inhibitor), plot expression histograms, maxRA, nColonies.

%%
clearvars;
rawImagesPath = '/Volumes/SAPNA/171017_96wellPlateNew/tiffFiles';
conditions = [21];

peaks1 = cell(1,numel(conditions));
nColonies = zeros(1,numel(conditions));
rawImages = cell(1,numel(conditions));
maxRA = zeros(numel(conditions),3);

counter = 1;

for ii = conditions
    if ii < 48
        outputFile = [rawImagesPath filesep 'Condition' int2str(ii)...
            filesep 'output.mat'];
    else
        outputFile = [rawImagesPath filesep  'plate_2ndHalf' filesep 'Condition' int2str(ii)...
            filesep 'output.mat'];
    end
    
    load(outputFile);
    peaks1{counter} = peaks;
    nColonies(1,counter) = size(peaks,2);
    rawImages{counter} = rawImages1;
    maxRA(counter,:) = maxRA1;
    
    counter = counter+1;
end
save('controls2.mat', 'conditions', 'rawImages', 'maxRA');
%% expression histograms
nChannel1 = 0;
binSize = 100;
coloniesToUse = 1:size(peaks,2);
tooHigh = [12e3, 3e3, 8e3,8e3];
yLimits = [0.06, 0.7, 0.35, 0.45];  

counter = 1;
for channel = [5 6 8 10]
    figure;
    for ii = 1:5
        peaks = peaks1{ii};
        coloniesToUse = 1:size(peaks,2);
        subplot(3,2,ii);
        plotHistogramOfExpressionLevelsGivenColonies (peaks, coloniesToUse, channel, nChannel1, binSize);
        title(['Condition' int2str(conditions(ii))]);
        xlim([0 tooHigh(counter)]);
        ylim([0 yLimits(counter)]);
    end 
    counter = counter+1;
end

%%  Do max RA'a differ?
maxRA1 = maxRA';
figure; bar(maxRA1);

channelLabels = {'CDX2', 'Sox2', 'T'};
xlabel('Channels');

ax = gca;
ax.XTickLabel = channelLabels;

%% Cell density - the culprit!
nCells = cell(1,5);

for ii = 1:numel(conditions)
    [nCells1, ~] = cellfun(@size, peaks1{ii}, 'UniformOutput', false);
    nCells{ii} = cell2mat(nCells1);
end
%%
figure; hold on;
for ii = 1:numel(conditions)
    plot([1:size(nCells{ii},2)], nCells{ii}, 'Marker', '*','MarkerSize', 12);
end
ylabel('Ncells');
xlabel('colonies');
legend(strcat('Condition', strsplit(int2str(conditions), ' ')));

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
%%

avgCells = cellfun(@mean, nCells);
figure; bar(avgCells);
ylabel('Ncells');
xlabel('Condition');

ax = gca;
ax.XTickLabel = strcat('C:', strsplit(int2str(conditions), ' '));
ax.FontSize = 12;
ax.FontWeight = 'bold';















