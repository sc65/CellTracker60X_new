%%

% compare fold change in common/distinct genes

samples = {'BMP4_48h', 'BMP_IWP2_48h', 'BMP_SB_48h'};
%%
geneList = cell(1,3); foldChange = geneList;

for ii = 1:numel(samples)
    sample1 = readtable([samples{ii} '.csv']);
    geneList{ii} = table2cell(sample1(:,1));
    foldChange{ii} = table2cell(sample1(:,3));
end
%%
ii = 1;

while ii<=numel(samples)
    if ii == 1
        common = intersect(geneList{1}, geneList{2});
        ii = 3;
    else
        common = intersect(common, geneList{ii});
        ii = ii+1;
    end
end
%%
fc = cell(1,numel(samples));
for ii = 1:numel(samples)
    [~, ~, idx] = intersect(common, geneList{ii});
    fc1  = foldChange{ii};
    fc{ii} = fc1([idx]);
end

%%
genes = common;
bmp = cell2mat(fc{1});
bmpIWP2 = cell2mat(fc{2});
bmpSB = cell2mat(fc{3});

%%
commonGenes = table(genes, bmp, bmpIWP2, bmpSB);
writetable(commonGenes, ['DifferentiallyExpressed_common.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);
%%

commonGenes = sortrows(commonGenes, 2, 'Desc');
writetable(commonGenes, ['DifferentiallyExpressed_common_sortedBMP.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);





