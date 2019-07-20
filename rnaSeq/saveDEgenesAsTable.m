
%% ------------------------------------------------------------------------------------

% most upregulated/downregulated genes in all treatment samples compared to the control
% what are the common/different genes?
% what do those genes do in the mouse embryo/stem cells?
% is any difference between trohpectoderm and extra-embryonic mesoderm
% genes in the three samples?

%%
geneFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/geneNames.txt';
geneInfo = readtable(geneFile);

% extract unique gene names, ids
[geneNames, geneIds] = unique(geneInfo(:,4));
geneInfoNew = geneInfo([geneIds],:);
geneInfoNew = table2cell(geneInfoNew);

%%
sampleDir = '.';
samples = {'BMP', 'BMP_IWP2', 'BMP_SB'};

for ii = 1:numel(samples)
    saveFileWithGeneNames(sampleDir, samples{ii}, geneInfoNew);
    % one file with genenames added to ebseq results
    % one file with genenames and read count values
end

%%
function saveFileWithGeneNames(sampleDir, sampleName, geneInfoNew)

sample1 = [sampleName '_geneMat.de.txt'];
expressionList = readtable([sampleDir filesep sample1]);

%% add geneNames to exxpression list, sort(high to low fold change), save.
expressionList_geneIds(:,1) = cellfun(@(c) extractBefore(c, '.'), table2cell(expressionList(:,1)), 'UniformOutput', false);
[~,idx1, idx2] = intersect(expressionList_geneIds(:,1), geneInfoNew(:,1));

% add
expressionList([idx1],8) = geneInfoNew([idx2],4);

% keep only gene Ids that were matched to a gene name
expressionListNew = table2cell(expressionList(idx1, [1 8 4 2])); %[name, id, foldchange, pvalue)

% make a table, sort, save
gene = expressionListNew(:,2);
geneId = expressionListNew(:,1);
foldChange =cell2mat(expressionListNew(:,3));
pValue = cell2mat(expressionListNew(:,4));
expressionListNew_table = table(gene, geneId, foldChange, pValue);
expressionListNew_table = sortrows(expressionListNew_table, 3, 'asc'); % sort based on p values 
writetable(expressionListNew_table, [sampleDir filesep sampleName '.csv'],'Delimiter',',',...
    'QuoteStrings',true, 'WriteRowNames', false);
end



