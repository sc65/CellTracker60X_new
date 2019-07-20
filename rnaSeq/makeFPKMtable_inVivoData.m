
%% --------------------------- trophoblast organoids
masterFolder = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/trophoblastOrganoids';
files = dir([masterFolder filesep '*.txt*']);
%%
% 1) unzip files
for ii = 1:numel(files)
    file1 = gunzip(files(ii).name, '.');
end
%%
% 2) read files
files = dir([masterFolder filesep '*.txt']);
allFiles = cell(1, numel(files));

for ii = 1:numel(files)
    allFiles{ii} = readtable(files(ii).name);
end
%%
geneList1 = table2cell(allFiles{1}(:,1));
%%
% 3) check if gene lists are in the same order
for ii = 1:12
    [~, idx1, idx2] = intersect(geneList1, table2cell(allFiles{ii}(:,1)));
    
    if ~(sum(idx1-idx2) == 0)
        disp(ii);
    end
end
%%  the lists are same.
%%
% combine replicates 
sampleIds = [1 4 8 11];
nReplicates = [3 4 3 2];

for ii = 1:12
    data1(:,ii) = table2array(allFiles{ii}(:,2));
end
%%
newFile = [cell2table(geneList1), array2table(data1)];
%%
variableNames = {'genes', 'CT_1', 'CT_2', 'CT_3',...
    'organoids_1', 'organoids_2', 'organoids_3', 'organoids_4', ...
    'ST_1', 'ST_2', 'ST_3', ...
    'fibroblasts_1', 'fibroblasts_2'};
for ii = 1:13
    newFile.Properties.VariableNames{ii} = variableNames{ii};
end
%%
CT_mean = mean(data1(:,1:3),2);
organoids_mean = mean(data1(:,4:7),2);
ST_mean = mean(data1(:,8:10),2);
fibroblasts_mean = mean(data1(:,11:12),2);

newFile2 = [newFile array2table([CT_mean organoids_mean ST_mean fibroblasts_mean])];  

%%
addedVariables = {'CT_mean', 'organoids_mean', 'ST_mean', 'fibroblasts_mean'};
for ii = 1:4
    newFile2.Properties.VariableNames{13+ii} = addedVariables{ii};
end
%%
filePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/trophoblastOrganoids.xlsx';
writetable(newFile2, filePath, 'WriteRowNames', false);
    
%% -------------------------------------------------------------------
%% human pre implantation embryo
data1 = readtable('HumanEmbryo.xlsx');
%%
% extract relevant rows
geneInfo = data1(18:end,:);

%%
% extract relevant columns
samples = {'Epi_E5', 'Epi_E6', 'Epi_E7', 'PE_E5', 'PE_E6', 'PE_E7', 'TE_E5', 'TE_E6', 'TE_E7'}; 
%%
% epiblast day5-7 genes read counts
genes = geneInfo(:,28);
counts = str2double(table2array(geneInfo(:,[40 53 66])));
epi = [genes array2table(counts)];
variableNames = {'epi_genes', 'epi_E5', 'epi_E6', 'epi_E7'};
for ii = 1:4
    epi.Properties.VariableNames{ii} = variableNames{ii};
end
    
%%
% add pe+te day5-7
variableNames = {'pe_genes', 'pe_E5', 'pe_E6', 'pe_E7', 'te_E5', 'te_E6', 'te_E7'};
genes2 = geneInfo(:,112);

counts = str2double(table2array(geneInfo(:,[124 137 150 125 138 151])));
pe = [genes2 array2table(counts)];

for ii = 1:7
   pe.Properties.VariableNames{ii} = variableNames{ii};
end
%%
% combine epi, pe, te tables
[common, idx1, idx2] = intersect(table2cell(epi(:,1)), table2cell(pe(:,1)));
%%
embryo = [cell2table(common) epi(idx1,2:end) pe(idx2,2:end)];
%%
filePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/try1.xlsx';
writetable(embryo, filePath,'Sheet',1,'WriteRowNames', false);

%% --------------------------------------------------------------------
%% ------------------- human trophoblast stem cells
data11 = readtable('humanTrophoblastStemCells.xlsx');

%%
genes = data11(:,1);
%%
readCounts_log = table2array(data11(:,3:end));
%%
readCounts_fpkm = (2.^(readCounts_log)) - 1;
%%
figure; histogram(readCounts_fpkm);
%%
variableNames = data11.Properties.VariableNames([1 3:end]);
%%
trophoblastStemCells = [genes array2table(readCounts_fpkm)];
%%
for ii = 1:25
    trophoblastStemCells.Properties.VariableNames{ii} = variableNames{ii};
end
%%
% add mean counts for each cell type
samples = {'CT_mean', 'EVT_mean', 'ST_mean', 'Stroma_mean', 'TSCT_mean', ...
    'EVT_TSCT_mean', 'ST_3d_TSCT_mean', 'TSblast_mean'...
    'EVT_TSblast_mean', 'ST_3d_TSblast_mean'};
cId = {1:3; 4:6; 7:9; 10:11; 12:13; 14:15; 17:18; 19:20; 21:22; 23:24};

for ii = 1:numel(samples)
   readCount_mean(:,ii) = mean(readCounts_fpkm(:,[cId{ii}]),2);
end

%%
data2 = [trophoblastStemCells array2table(readCount_mean)];
%%
counter = 1;
for ii = 26:35
    data2.Properties.VariableNames{ii} = samples{counter};
    counter = counter+1;
end

%%

filePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/trophoblastStemCells.xlsx';
writetable(data2, filePath, 'WriteRowNames', false);
%%
%% ---------------------------------- monkey embryo data -----------------------------------------
%% ------------------------------------------------------------------------------------------------
%% ------- A developmental coordinate of pluripotency among mice, monkeys and humans, Nakamura et al

file1 = readtable('GSE74767_SC3seq_Cy_ProcessedData.txt');
readCounts = str2double(table2array(file1(:,3:end)));
%%
[~,sheetName]=xlsfinfo('nature19096-s1.xlsx');
%%
sheetId = 3;
file2 = readtable('nature19096-s1.xlsx','Sheet', sheetName{sheetId});
%%

sampleId_cellType = file2(1:422,[1 3]); % only monkey
names = table2cell(sampleId_cellType(:,2));
names = strrep(names, '-', '_');
names = strrep(names, '/', '_');
%%
[~, idx1, idx2] = intersect(file1.Properties.VariableNames(3:end), table2cell(sampleId_cellType(:,1)));
%%
cellTypes = cell(1,length(idx1));
%%
cellTypes(idx1) = names(idx2);
uniqueCellTypes = unique(cellTypes, 'stable');
%%

% find ids corresponding to each cell type, get the average expression for
% all genes, and save
avgReadCounts = zeros(size(file1,1), length(uniqueCellTypes));
%%
for ii = 1:length(uniqueCellTypes)
idx1 =ismember(cellTypes, uniqueCellTypes{ii});
avgReadCounts(:,ii) = mean(readCounts(:,idx1),2);
end
%%

variableNames = ['Gene', uniqueCellTypes];
%%
data = [file1(:,2) array2table(avgReadCounts)];
%%
for ii = 1:size(data,2)
    data.Properties.VariableNames{ii} = variableNames{ii};
end
%%
% find the homologous human gene for all monkey genes and add in separate
% column

[~,sheetName]=xlsfinfo('nature19096-s2.xlsx');
sheetId = 1;
file2 = readtable('nature19096-s2.xlsx','Sheet', sheetName{sheetId});
%%
hGenes_mGenes = file2(2:end,[2 4]);
%%
[~, idx1, idx2] = intersect(table2cell(file1(:,2)), table2cell(hGenes_mGenes(:,2)));
%%
notMatched = hGenes_mGenes(setxor([1:size(hGenes_mGenes,1)], idx2),:);
% this is correct
%%
data2 = [hGenes_mGenes(idx2,1), data(idx1,:)];
%%
data2 = sortrows(data2,1);
%%

data2.Properties.VariableNames{1} = 'humanGene';
data2.Properties.VariableNames{2} = 'monkeyGene';
%%
data = sortrows(data,1);
%%
writetable(data, 'monkeyEmbryoStemCells.csv','Delimiter',',',...
        'QuoteStrings', true, 'WriteRowNames', false);
%%
data2 = sortrows(data2,2);
filePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/monkeyEmbryoStemCells_humanGenes.xlsx';
writetable(data2, filePath, 'WriteRowNames', false);
    
    
%% -------------------------------------------------------------------------------------
%% ----------------------------- human amnion in vitro fu paper ------------------------
% read file
data1 = readtable('GSE89479_hPSC_amnion_processed_data.xls');
%%
% take mean read count across replicates 
hESCs_rpkm = mean(str2double(table2array(data1(2:end, 2:4))),2);
amnion_rpkm = mean(str2double(table2array(data1(2:end, 5:7))),2);
%%
% create new table
data2 = [data1(2:end,1), array2table([hESCs_rpkm amnion_rpkm])];
%%
data2.Properties.VariableNames{1} = 'genes';
data2.Properties.VariableNames{2} = 'hPSCs';
data2.Properties.VariableNames{3} = 'amnion';

writetable(data2, 'humanAmnionInVitro.csv','Delimiter',',',...
'QuoteStrings', true, 'WriteRowNames', false);

%% ------------------------------------------------------------------------------------
%% ----------------------------- human amnion in vivo keygenes paper ------------------
data1 = readtable('GSE66302_Roost_et_al_Raw_Reads (1).txt');
%%
% extract amnion data
samples = data1.Properties.VariableNames;
%%
idx = contains(samples, 'Amnion');
amnionData = data1(:,[idx]);
%%
w9 = mean(table2array(amnionData(:,[2 6])),2);
w16 = mean(table2array(amnionData(:,[1 3 4])),2);
w22 = mean(table2array(amnionData(:,[5 7])),2);
amnionReads = [w9 w16 w22];
%%
% placenta
idx = contains(samples, 'Placenta');
placentaData = data1(:,[idx]);
%%
p_w9 = mean(table2array(placentaData(:,[3 6])),2);
p_w16 = mean(table2array(placentaData(:,[1 2 4])),2);
p_w22 = mean(table2array(placentaData(:,[5 7])),2);
placentaReads = [p_w9 p_w16 p_w22];
%%
% maternal endometrium
idx = contains(samples, 'Mother');
motherData = data1(:,[idx]);
%%
% replace gene ids by gene names
geneIdNames = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/geneNames.txt');
[common, idx1, idx2] = intersect(table2cell(geneIdNames(:,1)), table2cell(data1(:,1)));
%%
% create new table
data2 = [geneIdNames(idx1,4), array2table([amnionReads(idx2,:) placentaReads(idx2,:)]), motherData(idx2,:)];
%%
data2 = sortrows(data2, 1);
%%
variables = {'genes', 'amnion_w9', 'amnion_w16', 'amnion_w22',...
    'placenta_w9', 'placenta_w16', 'placenta_w22'};
%%
for ii = 1:7
    data2.Properties.VariableNames{ii} = variables{ii};
end
%%
writetable(data2, 'humanFetus.csv','Delimiter',',',...
'QuoteStrings', true, 'WriteRowNames', false);
















