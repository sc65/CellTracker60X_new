
%%
% pools fpkm data for all genes expressed in at least one sample 

%%
rnaSeqFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaseq2/RNASeqDat.mat';
load(rnaSeqFile);
%%
for ii = 1:length(gene_names)
    if iscell(gene_names{ii})
        if ~isempty(gene_names{ii})
            gene_names2{ii} = gene_names{ii}{1};
        else
            gene_names2{ii} = '';
        end
 
    elseif isempty(gene_names{ii})
        gene_names2{ii} = '';
    else
        gene_names2{ii} = gene_names{ii};
    end
end
%%
badInds = find(all(alldat == 0,2)); % exclude genes unexpressed in all samples
goodInds = ~ismember([1:size(alldat,1)], badInds);
dataToUse = alldat(goodInds,:);

%% ------ %rnaseq1
% write a table, save as csv
genes = [gene_names2(goodInds)]';
geneIds = [gene_ids(goodInds)]';
media = dataToUse(:,4);
bmp = dataToUse(:,1);
bmpIwp = dataToUse(:,2);
bmpSb = dataToUse(:,3);
%%
fpkmTable = table(genes, geneIds, media, bmp, bmpIwp, bmpSb);
fpkmTable = sortrows(fpkmTable,1);
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable';
writetable(fpkmTable, [saveInPath filesep 'ourCells.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);

%% ------ rnaseq2
%
genes = [gene_names2(goodInds)]';
geneIds = [gene_ids(goodInds)]';
media = dataToUse(:,5);
bmp = dataToUse(:,1);
bmpIwp = dataToUse(:,2);
bmpSb = dataToUse(:,3);
PS = dataToUse(:,4);
%%
fpkmTable = table(genes, geneIds, media, bmp, bmpIwp, bmpSb, PS);
fpkmTable = sortrows(fpkmTable,1);
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable';
writetable(fpkmTable, [saveInPath filesep 'ourCells2.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);