
%%
data1 = readtable('BMP_IWP2.csv'); nGenes = 1000;
te_high_1 = data1(table2array(data1(:,3)) > 1,:);
if ~isempty(nGenes)
    te_high_1 = te_high_1(1:nGenes,:);
end
pluripotent_high_1 = data1(table2array(data1(:,3)) < 1,:);
pluripotent_high_1 = sortrows(pluripotent_high_1, 3, 'asc');

if ~isempty(nGenes)
    pluripotent_high_1 = pluripotent_high_1(1:nGenes,:);
end
%%
data2 = readtable('de_humanEmbryo_TE_epi_blakeley.xlsx');
data3 = readtable('de_mouseEmbryo_TE_epi_balekeley.xlsx');
data4 = readtable('geneList_humanEmbryo_petropolous.xlsx');
%%
te_high_2 = data2(table2array(data2(:,3)) > 0,:);
epi_high_2 = data2(table2array(data2(:,3)) < 0,:);
te_high_3 = data3(table2array(data3(:,6)) < 0, :);
epi_high_3 = data3(table2array(data3(:,6)) > 0, :);
te_high_4 = data4(ismember(table2cell(data4(:,2)), 'TE'),:);
epi_high_4 = data4(ismember(table2cell(data4(:,2)), 'EPI'),:);
pe_high_4 = data4(ismember(table2cell(data4(:,2)), 'PE'),:);
%%
samples = {te_high_2, epi_high_2, te_high_3, epi_high_3, te_high_4, epi_high_4, pe_high_4};

genes_common_te = cell(1,numel(samples));
genes_common_pluripotent = cell(1,numel(samples));
for ii = 1:numel(samples)
    [genes_common_te{ii},~,~] = intersect(table2cell(te_high_1(:,1)), upper(table2cell(samples{ii}(:,1))));
    [genes_common_pluripotent{ii},~,~] = intersect(table2cell(pluripotent_high_1(:,1)), upper(table2cell(samples{ii}(:,1))));
end
%%
% make an fpkm table of all differentially expressed genes

masterDir = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/differentiallyExpreesed_comparedToMedia';
files = dir([masterDir filesep '*.csv']);
deGenes = cell(1,3);

for ii = 1:3
    data1 = readtable(files(ii).name);
    data1 = data1(table2array(data1(:,3)) > 1,:);
    deGenes{ii} = table2cell(data1(:,1));
end
%%
deGenes_all = unique([deGenes{1}; deGenes{2}; deGenes{3}]);
%%
allData = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/rnaSeq_forPaper.csv');
allGenes = table2cell(allData(:,1));
%%
[common, idx1, idx2] = intersect(allGenes, deGenes_all);
%%
deGeneData = [cell2table(common) allData(idx1,:)];
%%
deGeneData1 = deGeneData(:,[1 12:15]);
deGeneData1.Properties.VariableNames{1} = 'genes';
%%

writetable(deGeneData1, ['de_media.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);
%%
deGeneData1_zScore = zscore(table2array(deGeneData1(:,2:5)),0,2);  

[teGenes, ~,~] = intersect(table2cell(te_high_2(:,1)), table2cell(te_high_4(:,1))); 
[common1, ~, idx2] = intersect(teGenes, table2cell(deGeneData1(:,1)));
%%
figure; heatmap(table2array(deGeneData1(idx2,2:5)));
figure; heatmap(deGeneData1_zScore(idx2,:));








