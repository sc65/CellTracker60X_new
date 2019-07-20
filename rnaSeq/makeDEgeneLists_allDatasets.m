%%

datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/datasets.mat';
load(datasetsFile);

geneIds_names = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/geneNames.txt');

%% ----------------------------------------------------------------------------------------------------------------
%% =============== Get differentially expressed genes in trophectoderm cells compared to anything else ============
%%
datasets_names = {'hESCs', 'preimplantationEmbryo', 'TSCells'};
filePaths = {'/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/allDeGenes', ...
    '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/for_rsem_ebseq/rawFiles/humanEmbryo',...
    '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/for_rsem_ebseq/rawFiles/humanTSCells'};
fileFinders = {'*_media.csv', '*te*.de.txt', '*CT*.de.txt'};
deGenes = struct;
%%
for ii = 1:numel(filePaths)
    files = dir([filePaths{ii} filesep fileFinders{ii}]);
    if ii == 2
        files(end-2:end) = []; % remove cde genes between TE samples
    elseif ii == 3
        files = files(1:3);
    end
    
    deGenes(ii).all = getGeneListsFromFiles(files);
    deGenes(ii).dataset = datasets_names{ii};
    
    if ii >1
        [common, idx1, idx2] = intersect(deGenes(ii).all, table2cell(geneIds_names(:,1)));
        newGenes = geneIds_names(idx2,4);
        deGenes(ii).all = sort(table2cell(newGenes));
    end
    
end
%%
%% -----------------------------------------------------------------------------------------------------------------------
%% ============== filter genes based on foldChange, first n most differentially expressed genes  =========================
%%
% 1) find genes in the corresponding dataset
% 2) make a foldchange matrix (rpkm/fpkm foldchanges for sampleCombinations with TE as one of the sample)
% 3) filter genes based on maximum foldchange/matrix
% 4) sort them (desc) based on maximum foldchange/matrix
% 5) extract the top n genes

datasetId = [4 1 2]; %datasets corresponding to sampleOrder in the structure deGenes
teColumnIds = {2:4; 7:9; 1}; %columns corresponding to trophoblast cell lineages
samplesColumnIds = {1:4, 1:9, 1:4}; % samples considered for de calculation
fcCutoff = 2; % foldChange cutoff
nCutoff = 100; % top n DE genes
%%
% 1)
for ii = 1:numel(deGenes) % for deGenes
    [geneList, idx1, ~] = intersect(datasets(datasetId(ii)).genes, deGenes(ii).all);
    readCounts = datasets(datasetId(ii)).rawReads(idx1,samplesColumnIds{ii});
    %%
    % 2)
    % a)get required combinations
    v1 = teColumnIds{ii};
    v2 = setxor(samplesColumnIds{ii}, v1);
    [v3,v4] = ndgrid(v1,v2);
    sampleIds = [v3(:), v4(:)];
    
    %%
    % b)compute fold change matrix. (m*n,
    % m:genes, n:foldchanges = sample1(fpkm+1)/sample2(fpkm+1)
    % sample1 has higher readcount than sample2
    
    foldChange = zeros(size(readCounts,1), size(sampleIds,1));
    for jj = 1:size(foldChange,2)
        counts = readCounts(:,[sampleIds(jj,:)])+1;
        fc = counts(:,1)./counts(:,2);
        %fc(fc<1) = 1./(fc(fc<1));
        foldChange(:,jj) = fc;
    end
    
    %%
    % 3-5)
    % filter genes based on maximum fold change: fold change threshold = 2.
    % top 100 genes in each sample comparison
    
    genes1 = cell(1, size(foldChange,2));
    genes2 = genes1;
    for jj = 1:size(foldChange,2)
        fc = foldChange(:,jj);
        fc1 = fc;
        fc1(fc1<1) = 1./(fc1(fc1<1));
        genes1{jj} = geneList(fc1 > fcCutoff);
        fc = fc(fc1>fcCutoff);
        
        upGenesFoldChange =  fc(fc>1);
        upGenes = genes1{jj}(fc>1);
        downGenesFoldChange = fc(fc<1);
        downGenes = genes1{jj}(fc<1);
        
        [upN, idx1] = sort(upGenesFoldChange,'desc');
        [downN, idx2] = sort(downGenesFoldChange, 'asc');
        
        if numel(idx1)<nCutoff
            nCutoff_up= numel(idx1);
        else
            nCutoff_up = nCutoff;
        end
        
        if numel(idx2)<nCutoff
            nCutoff_down = numel(idx2);
        else
            nCutoff_down = nCutoff;
        end
        genes2{jj} = cat(1, upGenes(idx1(1:nCutoff_up)), downGenes(idx2(1:nCutoff_down)));
    end
    deGenes_fcCutoff = cat(1, genes1{:});
    deGenes_nCutoff = cat(1, genes2{:});
    
    %%
    deGenes(ii).foldChangeN = unique(deGenes_fcCutoff);
    deGenes(ii).topN = unique(deGenes_nCutoff);
end



%% ------ functions
function geneList = getGeneListsFromFiles(files)
geneList = cell(1,numel(files));
for ii = 1:numel(files)
    file1 = readtable([files(ii).folder filesep files(ii).name]);
    geneList{ii} = table2cell(file1(:,1));
end
geneList = unique(cat(1, geneList{:}));
end
