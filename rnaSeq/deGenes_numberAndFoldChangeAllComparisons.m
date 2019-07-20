

%% de gene analyses within differnt treatment samples
%fold change and fpkm values of differntially expressed genes within each treatment case.

% all info
rawData = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/rnaSeq_forPaper.csv');
allGenes = table2cell(rawData(:,1));

% just sample aveages
cId = [1 11:14]; %onle gene names and mean expression values
rawData1 = rawData(:,cId);
sampleNames = erase(rawData1.Properties.VariableNames(2:end), '_avg');
%%

% de files
deFilesPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all';
deFiles = dir([deFilesPath filesep '*.csv']);
%%

% make new tables with just fpkm values of de genes
deTable = cell(1, numel(deFiles));
for ii = 1:numel(deFiles)
    data1 = readtable([deFiles(ii).folder filesep deFiles(ii).name]);
    
    % find column ids of samples tested
    samplesTested = strtok(deFiles(ii).name, '.');
    [sampleCompared, controlSample]  = strtok(samplesTested, '_');
    controlSample = erase(controlSample, '_');
    
    cId_1 = find(strcmp(sampleNames, sampleCompared))+1; % first column is for geneNames
    cId_2 = find(strcmp(sampleNames, controlSample))+1;
    
    % find row ids of deGenes
    [common, ~, idx2] = intersect(table2cell(data1(:,1)), allGenes);
    
    % get fold changes (up/down)
    readCounts = table2array(rawData1(idx2, [cId_1 cId_2]));
    foldChange = (readCounts(:,1)+1)./(readCounts(:,2)+1);
    idx = find(foldChange<1);
    foldChange(idx) = 1./foldChange(idx);
    
    deTable{ii} = [cell2table(common), rawData1(idx2, [cId_1 cId_2]), array2table(foldChange)];
end
%%

deTable2 = cell(1,6); % containing only genes that satisfy the fpkm, foldchange threshold
% fold Change distributions

fpkmThreshold = 1;
foldChangeThreshold = 2;

sampleLabels = {'BMP+IWP2:BMP', 'BMP+IWP2:mTeSR', 'BMP+SB:BMP', 'BMP+IWP2:BMP+SB', 'BMP+SB:mTeSR', 'BMP:mTeSR'};
toPlot = [[1 4 2]; [3 4 5]; [1 3 6]; [3 5 6]];
%toPlot = 1:6;

for  ii = 1:size(toPlot,1)
    figure; hold on;
    for jj = toPlot(ii,:)
        readCounts = table2array(deTable{jj}(:,2:3));
        idx1 = any(readCounts >= fpkmThreshold,2);
        foldChange = table2array(deTable{jj}(:,4));
        idx2  = foldChange>=foldChangeThreshold;
        data1 = deTable{jj}(idx1&idx2,:);
        
        deTable2{jj} = data1;
        
        data2 = log2(table2array(data1(:,4)));
        histogram(data2, 'BinWidth', 0.25, 'DisplayStyle', 'Stairs', 'LineWidth', 2, 'Normalization', 'Probability');
        xlim([0 14]); xlabel('log2(foldChange)'); ylabel('Fraction of genes');
    end
    
    legend(sampleLabels(toPlot(ii,:)));
    ax = gca; ax.FontSize = 24; ax.FontWeight = 'bold';
end
%%
saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/trophectoderm/rnaseq/foldChange';
saveAllOpenFigures(saveInPath);
%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/graphs/deGenes/deGenes_foldChange_allComparisons';
saveAllOpenFigures(saveInPath);
%%
%% -----------------------------------------------------------------------------------------
%%
%--------fold change bar plot
nFoldChange = cell2mat(cellfun(@(x) size(x,1), deTable2, 'UniformOutput', 0));
%%
plotOrder = [1 4 2 6 5 3];
figure; b = bar(nFoldChange(plotOrder)); b.FaceColor = [0.5 0.5 0.5];
ylabel('No. of genes'); xlim([0.5 7.0]);
ax = gca;
ax.XTickLabel = sampleLabels(plotOrder);
ax.FontSize = 20; ax.FontWeight = 'bold';

%%
%% -----------------------------------------------------------------------------------------
%%
% ----- de genes heat map
deGenes = table2cell([deTable2{2}(:,1); deTable2{5}(:,1); deTable2{6}(:,1)]);
%%
deGenes = unique(deGenes);
%%
[common, idx1,~] = intersect(allGenes, deGenes);
%%
allGenes_readCounts = table2array(rawData1(:,2:5));
allGenes_zscores_log = zscore(log2(allGenes_readCounts+1), 0, 'All');
allGenes_zscores = zscore(allGenes_readCounts,0,2);
%%
deGenes_zscores = allGenes_zscores(idx1,:);
deGenes_fpkm = rawData1(idx1,:);
%%
deGenes_zscores_table = [cell2table(common) array2table(deGenes_zscores)];
deGenes_zscores_sort = sortrows(deGenes_zscores_table,2, 'desc');
%%
columnOrder = [2 3 5 4];
data1 = table2array(deGenes_zscores_sort(:,columnOrder));
figure;
h = heatmap(data1, 'GridVisible', 'off');
xlabels = {'mTeSR', '+BMP4', '+BMP4+SB', '+BMP4+IWP2'};
colormap('jet');
%%
for ii = 1:4
    h.XDisplayLabels{ii} = xlabels{ii};
end
%%

% save de genes (comparedtoMedia) in a text file
filePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/De_analyses_all_foldChange/geneLists_deComparedToMedia';
samples = {'iwp2', 'sb', 'bmp'};
counter = 1;

for ii = [2 5 6]
    data1 = deTable2{ii};
    idx1 = table2array(data1(:,2)) > table2array(data1(:,3));
    upregulated = data1(idx1,1);
    downregulated = data1(~idx1,1);
    
    writetable(upregulated, [filePath filesep 'up_' samples{counter} '.txt'],'Delimiter',' ',...
        'QuoteStrings',false, 'WriteRowNames', false, 'WriteVariableNames', false);
    writetable(downregulated, [filePath filesep 'down_' samples{counter} '.txt'],'Delimiter',' ',...
        'QuoteStrings',false, 'WriteRowNames', false, 'WriteVariableNames', false);
    counter = counter+1;
end
%%

saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/De_analyses_all_foldChange/forPaper';
saveAllOpenFigures(saveInPath);

%%

deGenes_media_fpkm = deGenes_fpkm;
outputFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/De_analyses_all_foldChange/output.mat';
save(outputFile, 'deGenes_media_fpkm', 'deTable2', 'sampleLabels');










