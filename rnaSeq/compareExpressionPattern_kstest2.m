
%% ---- kstest2 rnaSeq human embryos, our dataset

embryoData = readtable('humaPreimaplantationEmbryos.xlsx');
%%
% find column ids for averaged data
columnIds = find(contains(embryoData.Properties.VariableNames, 'Average'));
embryoData = embryoData(:,[1 columnIds]);
%%
% find genes tabulated in both datasets
genes1 = table2cell(ourData(:,1));
genes2 = table2cell(embryoData(:,1));
%%
% remove rows with uncharacterized genes
ourData(cellfun('isempty', genes1),:) = [];
%%
genes1 = table2cell(ourData(:,1));
%%
[commonGenes, idx1, idx2] = intersect(genes1, genes2);
%%
allData = [cell2table(commonGenes), embryoData(idx2, [2:12]), ourData(idx1, [3:6])];
%%

similar = zeros(size(allData,2)-1);
%%
for ii = 2:size(allData,2)
    for jj = 2:size(allData,2)
        similar(ii-1,jj-1) = kstest2(table2array(allData(:,ii)), table2array(allData(:,jj)));
    end
end
%%
stemcellsMedia = allData(:,[1 11:13]);
%%
for ii = 2:size(stemcellsMedia,2)
    for jj = 2:size(stemcellsMedia,2)
        [similar_media(ii-1,jj-1), pValue(ii-1, jj-1)] = kstest2(table2array(stemcellsMedia(:,ii)), table2array(stemcellsMedia(:,jj)));
    end
end
%%
high = any(table2array(stemcellsMedia(:,2:4)) > 10,2);
stemcellsMedia_high = stemcellsMedia(high,:);
%%
data = stemcellsMedia_high;
for ii = 2:size(data,2)
    for jj = 2:size(data,2)
        [similar_media(ii-1,jj-1), pValue(ii-1, jj-1)] = kstest2(table2array(data(:,ii)), table2array(data(:,jj)));
    end
end
%%
writetable(allData, ['humanEmbryoOurCells.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);

