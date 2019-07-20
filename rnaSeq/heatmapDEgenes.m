%%

% heatmap of top 100 differentially enriched genes in all treatments
% compared to pluripotent state. 

rawData = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/rnaSeq_forPaper.csv');
cId = 11:14; % columns corresponding to treatment samples (media, bmp, iwp2, sb)

readCounts = table2array(rawData(:,cId));
readCount_zScore = zscore(table2array(rawData(:,cId)),0,2);
allGenes = table2cell(rawData(:,1));
%%
% de compared to control
deFilePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/comparedToMedia';
files = dir(['*.csv']);

genes_de = cell(1,numel(files)); 
fpkm_de = genes_de;
fpkm_cut = 10;

for ii = 1:numel(files)
    file1 = [files(ii).folder filesep files(ii).name];
    data = readtable(file1);
    genes_de{ii} = table2cell(data(:,1)); 
    pValue_de{ii} = table2array(data(:,4));
    
    %filter based on fpkm
    [~, idx1, idx2] = intersect(allGenes, genes_de{ii});
    genes_de{ii} = genes_de{ii}(idx2); pValue_de{ii} = pValue_de{ii}(idx2); % to match the new order in intersection
    fpkm_de{ii} = readCounts(idx1,[1 1+ii]);  % [media, sample]
    idx = any(fpkm_de{ii} > fpkm_cut,2);
    genes_de{ii} = genes_de{ii}(idx);
    fpkm_de{ii} = fpkm_de{ii}(idx,:);
    pValue_de{ii} = pValue_de{ii}(idx,:);
     
    %write fpkm values
    genes = genes_de{ii};
    samples{1} = 'media';
    samples{2}= strtok(files(ii).name,'.');
    
    table1 = [cell2table(genes), array2table(fpkm_de{ii})];
    for jj = 2:3
        table1.Properties.VariableNames{jj} = samples{jj-1};
    end
    
    fileName = strtok(files(ii).name,'.');
    writetable(table1, [fileName '.txt'],'Delimiter','\t',...
    'QuoteStrings',true, 'WriteRowNames', false);
    
end
%%
% percent common genes
sampleIds = [1 2; 1 3; 2 3];
commonGenes = cell(1,3); percentCommon = zeros(1,3);
for ii = 1:size(sampleIds,1)
    geneSet = unique([genes_de{sampleIds(ii,1)}; genes_de{sampleIds(ii,2)}]);
    [commonGenes{ii},idx1,~] = intersect(genes_de{sampleIds(ii,1)}, genes_de{sampleIds(ii,2)});
    percentCommon(ii) = numel(idx1)./length(geneSet);
end
%%
% prcent_common_all
geneSet =  unique([genes_de{1}; genes_de{2}; genes_de{3}]);
[commonDeGenes,idx1,~] = intersect(intersect(genes_de{1}, genes_de{2}), genes_de{3});
percentCommon_all = numel(idx1)./length(geneSet);
%%
% plot z score of a subset of de genes with log2 foldChange in (fpkm+1) > 1 in a heatmap

foldChange_cut = 1;

genes_de_all = unique([genes_de{1}; genes_de{2}; genes_de{3}]);
[~, idx1,~] = intersect(genes_de_all, allGenes);
readCounts_de = readCounts(idx1,2:end);
foldChange = log2((readCounts_de+1)./(readCounts_de(:,1)+1));
%%
idx = any(abs(foldChange) > foldChange_cut,2);
readCount_zScore_de = readCount_zScore(idx,:);
readCount_zScore_de = sortrows (readCount_zScore_de,'desc');
%%

for ii = 1:3
    for jj = 1:3
        cc = corrcoef(foldChange(:,ii), foldChange(:,jj));
        corrCoeff1(ii,jj) = cc(1,2);
    end
end
%%
for ii = 1:4
    for jj = 1:4
        cc = corrcoef(readCount_zScore_de(:,ii), readCount_zScore_de(:,jj));
        corrCoeff2(ii,jj) = cc(1,2);
    end
end
%%
 h = heatmap(readCount_zScore_de);

%%
genes_up_all = [genes_up{1}; genes_up{2}; genes_up{3}];
%%
[common, ~, ~] = intersect(genes_up{1}, intersect(genes_up{3}, genes_up{2}));
different = setxor(genes_up_all, common);
genes_up_all = [different; common];

%%
genes_down_all = [genes_down{1}; genes_down{2}; genes_down{3}];
[common, ~, ~] = intersect(genes_down{1}, intersect(genes_down{3}, genes_down{2}));
different = setxor(genes_down_all, common);
genes_down_all = [different; common];
%%
genes_de = [genes_down_all; genes_up_all];
%%
[common, idx1, idx2] = intersect(genes_de, allGenes);
readCount_de = table2array(rawData(idx2,cId));
readCount_zScore_de = readCount_zScore(idx2,:);
%%
genes_de_all = gene_de(idx1,:);
writetable(allData, ['humanEmbryoOurCells.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);

%%
h = heatmap(readCount_zScore_de);



