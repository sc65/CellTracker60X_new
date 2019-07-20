
%%

% 1) how many genes are expressed in each condition?
% 2) how well does the gene expression pattern (gene z-scores) correlate across conditions?
% 3) how many genes are significantly differentially expressed across conditions?
% 4) what biological processes do the differentially expressed genes
% correspond to?

%%
%% ----------------- 1)
rawData = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/rnaSeq_forPaper.csv');
allGenes_1 = table2cell(rawData(:,1));
%%
cId = 3:14; fpkmThreshold = 0;
readCounts = table2array(rawData(:,cId));
expressedGenes = zeros(1,numel(cId));
%%
for ii = 1:size(readCounts,2)
    expressedGenes(:,ii) = sum(readCounts(:,ii) > fpkmThreshold);
end
figure;
bar([1:numel(expressedGenes)], expressedGenes);
xlabel('samples'); ylabel(['Expressed genes (fpkm>' int2str(fpkmThreshold) ')']);

%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/graphs';
saveAllOpenFigures([saveInPath filesep 'expressed genes count']);
%%
%-------- number of expressed genes remain constant--------
%%
fpkmThreshold = 0; samples = {'media', 'bmp', 'IWP2', 'SB'};
counter = 1;
for ii = 1:2:size(readCounts,2)-1
    figure; hold on;
    for jj = [ii ii+1] %-- replicates
        readCounts1 = readCounts(:,jj);
        readCounts1 (readCounts1<fpkmThreshold) = [];
        readCounts1 = log10(readCounts1+1);
        histogram(readCounts1, 'Normalization', 'probability'); xlabel('log10(fpkm+1)'); ylabel('Fraction of genes');
        
    end
    title(samples{counter}); counter = counter+1;
end
%%
fpkmThreshold = 1;
samples = {'media', 'bmp', 'IWP2', 'SB'};
counter = 1;
for ii = size(readCounts,2)-3:size(readCounts,2)
    figure;
    readCounts1 = readCounts(:,ii);
    readCounts1 (readCounts1<fpkmThreshold) = [];
    readCounts1 = log10(readCounts1);
    histogram(readCounts1, 'Normalization', 'probability'); xlabel('log10(fpkm)'); ylabel('Fraction of genes');
    title(samples{counter});
    counter = counter+1;
end
%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/graphs';
saveAllOpenFigures([saveInPath filesep 'expressed genes histograms']);
%%
%----------------- read count distributions look similar ------------------------
%%
%% ----------------- 2)
% extract genes expressed in at least one sample
cId = 3:14; fpkmThreshold = 0;
readCounts = table2array(rawData(:,cId));

idx = any(readCounts > fpkmThreshold,2);
readCounts = readCounts(idx,:);
allGenes = allGenes_1(idx);
%%
readCounts_log = log2(readCounts+1);

readCounts_zscore_all = zscore(readCounts,0,'all'); % across entire dataset
readCounts_zscore_log = zscore(readCounts_log,0,'all'); 
readCounts_zScore = zscore(readCounts,0,2); % gene-wise zscore
%%
figure; histogram(readCounts_log(:), 'BinWidth', 0.5);
figure; histogram(readCounts_zscore_all(:));

figure; histogram(readCounts_zscore_log(:), 'BinWidth', 0.2);
figure; histogram(readCounts_zScore(:), 'BinWidth', 0.2);

%%
figure;
scatter(readCounts(:,9), readCounts(:,10));
%%
% comparing raw counts - fpkm
kstest_results = zeros(size(readCounts,2));
pValue = kstest_results;
corrCoeff = pValue;

for ii = 1:size(kstest_results,1)
    for jj = 1:size(kstest_results,1)
        [kstest_results(ii,jj), pValue(ii,jj)] = kstest2(readCounts(:,ii), readCounts(:,jj));
        cc = corrcoef(readCounts(:,ii), readCounts(:,jj));
        corrCoeff(ii,jj) = cc(1,2);
    end
end
%%
figure; heatmap(kstest_results(1:8,1:8)); title('kstest');
figure; heatmap(kstest_results(9:12,9:12)); title('kstest');

figure; heatmap(corrCoeff(1:8,1:8)); title('correlation coefficient');
figure; heatmap(corrCoeff(9:12,9:12)); title('correlation coefficient');
%%

% comparing fold changes of avg counts
foldChange = log2((readCounts(:,9:12)+1)./(readCounts(:,9)+1));
%%
kstest_results = zeros(size(foldChange,2));
pValue = kstest_results;
corrCoeff = pValue;

for ii = 1:size(kstest_results,1)
    for jj = 1:size(kstest_results,1)
        [kstest_results(ii,jj), pValue(ii,jj)] = kstest2(readCounts(:,ii), readCounts(:,jj));
        cc = corrcoef(readCounts(:,ii), readCounts(:,jj));
        corrCoeff(ii,jj) = cc(1,2);
    end
end
%%
figure; heatmap(kstest_results(2:4,2:4)); title('kstest_foldChange');
figure; heatmap(corrCoeff(2:4,2:4)); title('correlationCoeff_foldChange');
%%
sampleIds = [2 3; 3 4; 2 4];
samples = {'media', 'bmp', 'bmp+iwp2', 'bmp+sb'};
for ii = 1:size(sampleIds,1)
    figure; scatter(foldChange(:,sampleIds(ii,1)), foldChange(:,sampleIds(ii,2)));
    xlabel(samples{sampleIds(ii,1)}); ylabel(samples{sampleIds(ii,2)});
    title('log2(foldChange)');
    
end
%%
saveAllOpenFigures([saveInPath filesep 'expressed genes expression similarity']);
%%
%-------- foldChanges compared of all expressed genes compared to the
% control sample are highly correlated correlation coefficient > 0.8

%%
% how about expression of highly variable genes - zscore > 1.5
zScoreThreshold = 1.5;
readCounts_zScore1= readCounts_zScore(:,9:12);
variableGenes_id = any(abs(readCounts_zScore1) > zScoreThreshold,2);
readCounts_zScore_variableGenes = readCounts_zScore1(variableGenes_id,:);
sampleIds = [1 2; 1 3; 1 4; 2 3; 3 4; 2 4]; samples = {'media', 'bmp', 'bmp+iwp2', 'bmp+sb'};
for ii = 1:size(sampleIds,1)
    figure;
    scatter(readCounts_zScore_variableGenes(:,sampleIds(ii,1)),  readCounts_zScore_variableGenes(:,sampleIds(ii,2)))
    xlabel(samples{sampleIds(ii,1)}); ylabel(samples{sampleIds(ii,2)});
end
%%
corrCoeff = zeros(4);
for ii = 1:4
    for jj = 1:4
        cc = corrcoef(readCounts_zScore1(:,ii), readCounts_zScore1(:,jj));
        corrCoeff(ii,jj) = cc(1,2);
    end
end
%%
figure; heatmap(corrCoeff); title('gene expression similarity of variable genes');
%%
saveAllOpenFigures([saveInPath filesep 'variable genes (zscore > 1.5) expression similarity']);

%% --------- highly variable genes have similar expression across bmp treatment samples than media.
%%
%% ------------------ 3)
% ratio of up vs downregulated genes
% compile top 100 up, down regulated genes (ranked by normalized fold change) across conditions (based on control)
% - heatmap, expression similarity. Which embryo lineage do those
% genes correspond to?

masterDir = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/differentiallyExpreesed_comparedToMedia';
files = dir([masterDir filesep '*.csv']);
files(4) = [];

upregulatedGenes = cell(1,numel(files));
downregulatedgenes = upregulatedGenes;
upDown = zeros(1, numel(files));
%%
for ii = 1:numel(files)
    data1 = readtable([masterDir filesep files(ii).name]);
    genes1 = table2cell(data1(:,1));
    %%
    % remove genes that don't clear the fpkm>1 cutoff
    idx1 = ~ismember(genes1, allGenes);
    data1(idx1,:) = [];
    genes1(idx1,:) = [];
    
    %%
    % save stats for comparison later
    data11 = table2array(data1(:,3:4));
    upregulatedGenes{ii} = data1(data11(:,1) > 1, [1 3 4]); % gene, fc
    upregulatedGenes{ii} = sortrows(upregulatedGenes{ii},2, 'desc');
    
    downregulatedGenes{ii} = data1(data11(:,1) < 1, [1 3 4]); % gene, fc
    downregulatedGenes{ii} = sortrows(downregulatedGenes{ii},2,'asc');
    %%
    upDown(ii) = size(upregulatedGenes{ii},1)./size(downregulatedGenes{ii},1);
end

%%
% extract top 100 differentially expressed genes
upregulatedGenes_top100 = [table2cell(upregulatedGenes{1}(1:100,1)); ...
    table2cell(upregulatedGenes{2}(1:100,1)); table2cell(upregulatedGenes{3}(1:100,1))];
upregulatedGenes_top100 = unique(upregulatedGenes_top100);

downregulatedGenes_top100 = [table2cell(downregulatedGenes{1}(1:100,1)), ...
    table2cell(downregulatedGenes{2}(1:100,1)), table2cell(downregulatedGenes{3}(1:100,1))];
downregulatedGenes_top100 = unique(downregulatedGenes_top100);
%%
cId = 9:12;
geneData = readCounts_zScore(:,cId);
% zscore table
[common, ~, idx2] = intersect(upregulatedGenes_top100, allGenes);
up_top100_zscore = [cell2table(common), array2table(geneData(idx2,:))];
up_top100_zscore = sortrows(up_top100_zscore,2, 'desc');

[common, ~, idx2] = intersect(downregulatedGenes_top100, allGenes);
down_top100_zscore = [cell2table(common), array2table(geneData(idx2,:))];
down_top100_zscore = sortrows(down_top100_zscore,2, 'desc');
%%
top100_zscore = [down_top100_zscore; up_top100_zscore];
%%
figure;
columnOrder = [2 3 5 4]; 
h = heatmap(table2array(top100_zscore(:,columnOrder)));
colormap('jet');
h.XDisplayLabels = {'mTeSR', '+BMP4',  '+BMP4+SB', '+BMP4+IWP2'};
ax = gca;
ax.FontSize = 30;

%%
% ---- differentially expressed genes share similar expression across differentiated conditions
%%
saveAllOpenFigures([saveInPath filesep 'deGenes100heatmap']);

%%
% save down_top100_zscore and up_top100_zscore in separate files in a format compatible with GSEA -
% [geneName description(NA)/ensembleID media bmp bmp+iwp2 bmp+sb]
gseaPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/gsea';
mkdir(gseaPath);

geneSets = {down_top100_zscore, up_top100_zscore};
gseaList = cell(1,2);
gseaList_variables = {'NAME', 'DESCRIPTION', 'media', 'bmp', 'bmpIwp2', 'bmpSb'};
gseaList_names = {'downregulatedComparedToMedia_top100', 'upregulatedComparedToMedia_top100'};

for ii = 1:2
    description = cell(size(geneSets{ii},1),1);
    description(:) = {'NA'};
    gseaList{ii} = [geneSets{ii}(:,1), cell2table(description), geneSets{ii}(:,2:5)];
    
    for jj = 1:6
        gseaList{ii}.Properties.VariableNames{jj} = gseaList_variables{jj};
    end
    writetable(gseaList{ii}, [gseaPath filesep gseaList_names{ii} '.txt'],'Delimiter','\t',...
        'QuoteStrings',true, 'WriteRowNames', false);
end

%%
% --- how many of the top100 up and downregulated genes overlap? what are
% they?

%[z1 z2 z3 z12 z13 z23 z123]
% [1 2 3] -> [bmp bmpIWP2 bmpSB];

up_top100_zscore_venn = zeros(1,7);
down_top100_zscore_venn = zeros(1,7);

up_top100_zscore_venn(1:3) = 100; down_top100_zscore_venn(1:3) = 100;

idx = {[1 2], [1 3], [2 3]};
counter = 4;
for ii = 1:3
    geneList1 = table2cell(upregulatedGenes{idx{ii}(1)}(1:100,1));
    geneList2 = table2cell(upregulatedGenes{idx{ii}(2)}(1:100,1));
    geneList3 = table2cell(downregulatedGenes{idx{ii}(1)}(1:100,1));
    geneList4 = table2cell(downregulatedGenes{idx{ii}(2)}(1:100,1));
    
    [upregulatedGenes_top100_common{ii},~,~] = intersect(geneList1, geneList2);
    [downregulatedGenes_top100_common{ii}, ~, ~] = intersect(geneList3, geneList4);
    
    up_top100_zscore_venn(3+ii) = numel(upregulatedGenes_top100_common{ii});
    down_top100_zscore_venn(3+ii) = numel(downregulatedGenes_top100_common{ii});
end

%%
[upregulatedGenes_top100_common{4},~,~] = intersect(upregulatedGenes_top100_common{1}, upregulatedGenes_top100_common{3});
up_top100_zscore_venn(7) = numel(upregulatedGenes_top100_common{4});

[downregulatedGenes_top100_common{4},~,~] = intersect(downregulatedGenes_top100_common{1}, downregulatedGenes_top100_common{3});
down_top100_zscore_venn(7) = numel(downregulatedGenes_top100_common{4});
%%
figure;
venn(up_top100_zscore_venn); title('Upregulated Genes');
figure; venn(down_top100_zscore_venn); title('Downregulated Genes')
%% ---------------------------------------------------------------------
%% --- write data in text files
%%
% save top 100 de genes in a text file
filePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/differentiallyExpreesed_comparedToMedia/top100_de_GeneLists';

for ii = 1:3
    top100_1 = upregulatedGenes{ii}(1:100,1);
    top100_2 = downregulatedGenes{ii}(1:100,1);
    writetable(top100_1, [filePath filesep 'up_' samples{ii+1} '.txt'],'Delimiter',' ',...
        'QuoteStrings',false, 'WriteRowNames', false, 'WriteVariableNames', false);
end
%%
writetable(cell2table(upregulatedGenes_top100_common{4}), [filePath filesep 'up_top100_common.txt'],'Delimiter',' ',...
    'QuoteStrings',false, 'WriteRowNames', false, 'WriteVariableNames', false);

writetable(cell2table(downregulatedGenes_top100_common{4}), [filePath filesep 'down_top100_common.txt'],'Delimiter',' ',...
    'QuoteStrings',false, 'WriteRowNames', false, 'WriteVariableNames', false);

%%
% save all up/downregulated gene information in an output file
outputFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/differentiallyExpreesed_comparedToMedia/deGenes.mat';

save(outputFile, 'upregulatedGenes', 'downregulatedGenes', ...
    'upregulatedGenes_top100_common', 'downregulatedGenes_top100_common', 'top100_zscore', 'top100_fpkm');
%%
%% --------------------------------------------------------------------
%%
% --- make fpkm table for top 100 genes, check correlation
[common, ~, idx2] = intersect(table2cell(top100_zscore(:,1)), allGenes);
top100_fpkm = [cell2table(common), array2table(readCounts(idx2,[9:12]))];
%%
top100_fpkm = sortrows(top100_fpkm, 2, 'desc');

%%
corrCoeff = zeros(4);
for ii = 1:4
    for jj = 1:4
        cc = corrcoef(table2array(top100_fpkm(:,ii+1)), table2array(top100_fpkm(:,jj+1)));
        corrCoeff(ii,jj) = cc(1,2);
    end
end
%%
figure;
h = heatmap(corrCoeff);
colormap(jet);

%%
% fpkm values of differentially expressed genes are highly correlated
% across differntiated samples

%%
corrCoeff = zeros(4);
for ii = 1:4
    for jj = 1:4
        cc = corrcoef(table2array(top100_zscore(:,ii+1)), table2array(top100_zscore(:,jj+1)));
        corrCoeff(ii,jj) = cc(1,2);
    end
end
figure; heatmap(corrCoeff); colormap(jet);

% zscore values of differentially expressed genes are highly correlated
% across samples.
% correlation is conserved but the values are lower (negative zscores
% messing things up I guess)

%%
% --- how high/low are the fold change values?
foldChangeThreshold = 2;

foldChange = (table2array(top100_fpkm(:,3:5))+1)./(table2array(top100_fpkm(:,2))+1);
foldChange1 = [top100_fpkm(:,1) array2table(foldChange)];

idx = any(foldChange > foldChangeThreshold |foldChange < 0.5 ,2);
foldChange1 = foldChange1(idx,:);
foldChange = foldChange(idx,:);
%%
foldChange_log = log2(foldChange);
%%
figure; hold on;
for ii = 1:3
    histogram(foldChange_log(:,ii), 'DisplayStyle', 'Stairs', 'LineWidth', 5);
end
xlabel('log2(FoldChange)'); ylabel('No. of genes'); legend(samples(2:4));
ax = gca; ax.FontSize = 25; ax.FontWeight = 'bold';
%%

%% --------------------------------------------------------------------------------------------------------------------------
%% -- 5) What is the read count of trophoblast genes?
%% What is their read count? How many of them show up in the de list?
%% ----------------------------------------------------------------------------------------------------------------------------
trophoblast_genes = {'TP63', 'GATA3', 'TEAD4', 'KRT7', 'ITGA6', ...
    'HAI1', 'CDX2', 'TFAP2A', 'TFAP2C', 'SPINT1', 'ELF5', 'CK7'}; % Cytotrophoblasts-stem cells of placenta, week 6-8 placenta 
%%
[common, idx1, idx2] = intersect(trophoblast_genes, allGenes);
%%
tg_readCount = readCounts(idx2,9:12);
geneOrder = [1 3 5 8 9 6 2 10 4 7];
tg_readCount = tg_readCount([geneOrder],:);

figure; 
b = bar(tg_readCount);
ax = gca; ax.XTickLabel = common(geneOrder);
ylabel('Read counts (fpkm)'); title('Trophoblast genes');

samples = {'mTeSR', '+BMP4', '+BMP4+IWP2', '+BMP4+SB'};
legend(samples);
ax.FontSize = 20; ax.FontWeight = 'bold';

%%
trophoblast_genes_readCount = [cell2table(common) array2table(readCounts(idx2,9:12))];

%%
top100_foldChange = foldChange1;
%%




    




















