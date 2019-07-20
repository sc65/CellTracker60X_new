
%% ----------------------------------------------------------------------------------
%% ----------------what are the cdx2+/-ve cells in bmp, +sb, +iwp2 treatments cases?

% 1) genes enriched in treatment conditions compared to control - n1,n2,n3
% 2) percent common genes n4%
% 3) 1) and 2) for depleted genes
% 4) gene set enrichment analyses for 1 and 3.
% 5) how similar are z-scores of enriched genes between the treatment
% conditions and embryo cells (human early, mouse E5.5-7.5)

%% -----------------------------------------------------------------------------------

deFilePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DEanalyses_media';
files = {'BMP.csv', 'BMP_IWP2.csv', 'BMP_SB.csv'};
%cId = 13:15;
counter1 = 1;

for ii = 1:3
    file1 = [deFilePath filesep files{ii}];
    data = readtable(file1);
    idx = table2array(data(:,3)) > 1;
    genes_up{ii} = table2cell(data(idx,1)); % significantly differentially enriched genes
    foldChange_up{ii} = table2array(data(idx,3));
    
    idx = table2array(data(:,3)) < 1;
    genes_down{ii} = table2cell(data(idx,1));
    foldChange_down{ii} = table2array(data(idx,3));   
end
%%
rawData = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/ourCells.csv');
allGenes = table2cell(rawData(:,1));
%%
% top 10 - up/down, rpkm values, media/treatment
for ii = 1:3
    figure;
    [~,idx] = sort(foldChange_up{ii}, 'desc');
    genes_up10{ii} = genes_up{ii}(idx(1:10))
    [common, ~, idx1] = intersect(genes_up10{ii}, allGenes);
    rpkm = table2array(rawData(idx1, [3 3+ii]));
    bar(rpkm);
    ax = gca; ax.XTickLabel = common;
end
%%
for ii = 1:3
    figure;
    [~,idx] = sort(foldChange_down{ii});
    genes_down10{ii} = genes_down{ii}(idx(1:10))
    [common, ~, idx1] = intersect(genes_down10{ii}, allGenes);
    rpkm = table2array(rawData(idx1, [3 3+ii]));
    bar(rpkm);
    ax = gca; ax.XTickLabel = common;
end
%%
% -- common de genes between three datasets
for ii = 1:3
    genes_de{ii} = [genes_up{ii}; genes_down{ii}];
    foldChange_de{ii} = [foldChange_up{ii}; foldChange_down{ii}];
end
%%

checkId = [1 2; 1 3; 2 3];
for ii = 1:size(checkId,1)
    [commonGenes{ii},~,~] = intersect(genes_de{checkId(ii,1)}, genes_de{checkId(ii,2)});
end

commonGenes{4} = intersect(genes_de{1}, intersect(genes_de{2}, genes_de{3}));
%%
A = cell2mat(cellfun(@length,  genes_de, 'UniformOutput', false));
I = cell2mat(cellfun(@length,  commonGenes, 'UniformOutput', false));

%%
fraction_common_BMP = I(1:2)./A(1)
fraction_common_iwp = I([1 3])./A(2)
fraction_common_sb = I([2 3])./A(3)
%%

% ---- how similar are expression values of commonly enriched genes?
[common, ~, idx1] = intersect(commonGenes{4}, allGenes);
rpkm = table2array(rawData(idx1, [3:6]));

[cc,p]= corrcoef(rpkm)

















