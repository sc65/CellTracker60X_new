%% ---- combine fpkm tables rnaseq1, rnaseq2

data1 = readtable('ourCells.csv');
data2 = readtable('ourCells2.csv');
%%
% find common geneIds
genesId1 = table2cell(data1(:,2));
genesIds2 = table2cell(data2(:,2));
[commonGeneIds, idx1, idx2] = intersect(genesId1, genesIds2);
%%
% combine read count data
readCountData = [table2array(data1(idx1,3:end)), table2array(data2(idx2,3:end))];
%%
% change column order : media_1, media_2, bmp_1, bmp_2, bmpIwp2_1,
% bmpIwp2_2, bmpSB_1, bmpSB_2, ps_1
%[1 5 2 6 3 7 4 8 9];
%%
columnOrder = [1 5 2 6 3 7 4 8 9];
readCountData = readCountData(:, columnOrder);
fpkmTable = [data1(idx1,1), table(commonGeneIds), array2table(readCountData)];
%%

samples = {'media_1', 'media_2', 'bmp_1', 'bmp_2', ...
    'bmpIwp2_1', 'bmpIwp2_2', 'bmpSb_1', 'bmpSb_2', 'ps'};

counter = 1;
for ii = 3:11
    fpkmTable.Properties.VariableNames{ii} = samples{counter};
    counter = counter+1;
end
%%
fpkmTable = sortrows(fpkmTable,1);
%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable';
writetable(fpkmTable, [saveInPath filesep 'ourCells_all.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);
%%

% -- extract all data for media bmp, +iwp, +sb condition; 
% tabulate mean expression in  separate columns

for ii = 1:4
    meanCount(:,ii) = mean(readCountData(:,ii*2-1:ii*2),2);
end
%%
readCountData_new = [readCountData(:,1:8), meanCount];
%%
fpkmTable2 = [data1(idx1,1), table(commonGeneIds), array2table(readCountData_new)];

samples_new = ['geneIds', samples(1:8), 'media_avg', 'bmp_avg', 'bmpIwp2_avg', 'bmpSb_avg'];
counter = 1;
for ii = 2:14
    fpkmTable2.Properties.VariableNames{ii} = samples_new{counter};
    counter = counter+1;
end
%%
fpkmTable2 = sortrows(fpkmTable2,1);
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable';
writetable(fpkmTable2, [saveInPath filesep 'rnaSeq_forPaper.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);








