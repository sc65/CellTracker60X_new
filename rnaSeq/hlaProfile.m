%%
% 1) plot raw counts of HLA classI, and HLA class II proteins
%%
datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/datasets.mat';
load(datasetsFile);
%%
hlaGenes = {'HLA-A', 'HLA-B', 'HLA-C', 'HLA-E', 'HLA-F', 'HLA-G', 'HLA-DRB1', 'HLA-DRB5', 'HLA-DRB6'};
%%
checkGenes = {'SOX2', 'NANOG', 'CDX2', 'GATA3', 'GATA6', 'FOXA2', 'SOX17'};
%%

for ii = 1:numel(datasets)
    [geneList, ~, idx1] = intersect(hlaGenes, datasets(ii).genes);
    geneList
    readCounts = datasets(ii).rawReads(idx1,:);
    figure; hold on;
    for jj = 1:numel(hlaGenes)
        subplot(3,3,jj);
        bar(readCounts(jj,:));
        title(geneList{jj});
    end
end
%%
% per gene
genesToPlot = hlaGenes;
for ii = 1:numel(datasets)-1
    [geneList, ~, idx1] = intersect(genesToPlot, datasets(ii).genes);
    readCounts = datasets(ii).normReads_log(idx1,:);
    %readCounts = zscore(readCounts, 0, 2);
    figure; hold on;
    bar(readCounts);
    %     for jj = 1:numel(checkGenes)
    %         subplot(3,2,jj);
    %         bar(readCounts(jj,:));
    %         title(common{jj});
    %     end
    ax = gca;
    ax.XTick = 1:numel(geneList);
    ax.XTickLabel = geneList;
    legend(strrep(datasets(ii).samples, '_', ':'));
end

%%
% per sample
peGenes = {'FOXA2', 'SOX17', 'GATA6', 'TBXT', 'GATA3'};
genesToPlot = peGenes;
for ii = 1:numel(datasets)-1
    [geneList, ~, idx1] = intersect(genesToPlot, datasets(ii).genes);
    readCounts = datasets(ii).rawReads(idx1,:);
    %readCounts = zscore(readCounts, 0, 2);
    figure; hold on;
    bar(readCounts');
    %     for jj = 1:numel(checkGenes)
    %         subplot(3,2,jj);
    %         bar(readCounts(jj,:));
    %         title(common{jj});
    %     end
    ax = gca;
    ax.XTick = 1:numel(datasets(ii).samples);
    ax.XTickLabel = strrep(datasets(ii).samples, '_', ':');
    ylabel('readcount');
    legend(geneList);
end

%% ------------------------------------------------------------------------
%%
%-------- graph1: hla upregulated in evt - HLA-C, HLA-E, HLA-G;
% hla downregulated in ct, evt: HLAL-A, HLA-B, HLA-F, HLA-DR
%-------- samplesToPlot: humanEmbryo: epi, TE; humanTScells:
%CT,ST,EVT,Stroma; ourCells:media,BMP,BMP+SB,BMP+IWP2


geneOrder = [1 2 4:6 8 3 7 9];
datasetId = [1 2 4];
sampleId = {[1:3 7:9]; [1:4]; [1:4]};
genesToPlot = hlaGenes;

counter = 1;
for ii = datasetId
    [geneList, ~, idx1] = intersect(genesToPlot, datasets(ii).genes);
    readCounts = datasets(ii).rawReads(idx1,sampleId{counter});
    readCounts = readCounts(geneOrder,:);
    geneList = geneList(geneOrder,:);
    
    figure; hold on;
    bar(readCounts);
    ylabel('readcount');
    legend(strrep(datasets(ii).samples(sampleId{counter}), '_', ':'));
    counter = counter+1;
    
    ax = gca; ax.XTick = 1:numel(geneList); ax.XTickLabel = geneList;
    ax.FontSize = 20; ax.FontWeight = 'bold';
end
%%
% 2 graphs- negative HLA, positive HLA
% all TS populations - CT, EVT, TE-E5,6,7, BMP, BMP+SB, BMP+IWP2
hlaHigh = {'HLA-C', 'HLA-E', 'HLA-G'};
hlaLow = {'HLA-A', 'HLA-B', 'HLA-DRB1', 'HLA-DRB5', 'HLA-DRB6', 'HLA-F'};
geneLists = {hlaHigh, hlaLow};
datasetId = [1 2 4];
sampleId = {[7:9]; [1:4]; [1:4]};

sampleLabels = cell(1, numel(cat(2,sampleId(:))));

columnId = 1; counter = 1;
for ii = datasetId
    sampleLabels(columnId:columnId+numel(sampleId{counter})-1) = strrep(datasets(ii).samples(sampleId{counter}), '_', ':') ;
        columnId = columnId+numel(sampleId{counter});
        counter = counter+1;
end
%%
columnId = 1;
for ii = 1:numel(geneLists)
    counter = 1;
    figure; hold on;
    readCounts = zeros(numel(geneLists{ii}), numel(cat(2,sampleId{:})));
    for jj = datasetId
        [genes1, ~, idx1] = intersect(geneLists{ii}, datasets(jj).genes);
        readCounts1 = datasets(jj).normReads_log(idx1,sampleId{counter});
        readCounts(:,columnId:columnId+numel(sampleId{counter})-1) = readCounts1;
        columnId = columnId+numel(sampleId{counter});
        counter = counter+1;
    end
    bar(readCounts);
    ax = gca; ax.XTick = 1:numel(cat(2,geneLists{:})); ax.XTickLabel = geneLists{ii};
    ax.FontSize = 20; ax.FontWeight = 'bold';
    legend(sampleLabels);
 
end
%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/graphs/HLA';
saveAllOpenFigures(saveInPath);

%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/graphs/lineageMarkers';
saveAllOpenFigures(saveInPath);
%%


















