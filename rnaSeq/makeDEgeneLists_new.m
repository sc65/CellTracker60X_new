%%
datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/datasets.mat';
load(datasetsFile);
geneIds_names = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/geneNames.txt');
%%
samplePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/for_rsem_ebseq/rawFiles/humanTSCells_trimesterI';
%% ------ get lineage specific genes
% 1) epiblast: de between epi&pe + de between ep&te, but not between
% epi&epi - highly expressed in epi compared to other two

%%
lineages = {'CT', 'EVT', 'ST'};
lineageColumns = {1, 2, 3};
sampleColumns = 1:3;
datasetId = 2;
fcCutoff = 20;
nCutoff = 100;
minReadCount = 10;
minLineageSamples = 1;
lineageGenes_fcCutoff = cell(1,numel(lineages));
lineageGenes_nCutoff = cell(1,numel(lineages));

for ii = 1:numel(lineages)
    %% ------------------
    % 1) extract de genes between lineages,  excludind de genes within
    % lineages
    
    % files to keep
    files1 = dir([samplePath filesep '*' lineages{ii} '*.de.txt']);
    genes1 = getGeneListsFromFiles(files1);
    
    files2 = dir([samplePath filesep lineages{ii} '*_' lineages{ii} '*.de.txt']);
    if ~isempty(files2)
        [~, idx1] = setxor({files1.name}, {files2.name});
        files1 = files1(idx1);
        genes2 = getGeneListsFromFiles(files2);
        [~, idx1] = setxor(genes1, genes2);
        genes3 = genes1(idx1);
    else
        genes3 = genes1;
    end
    
    %files with genes to exclude
    olIds = setxor(1:numel(lineages), ii); % other lineage ids
    files3 = dir([samplePath filesep lineages{olIds(1)} '*_' lineages{olIds(2)} '*.de.txt']);
    files4 = dir([samplePath filesep lineages{olIds(2)} '*_' lineages{olIds(1)} '*.de.txt']);
    oFiles = {files3, files4};
    oFiles = oFiles(~cellfun('isempty',oFiles));
    oGenes = cell(1,numel(oFiles));
    
    for jj = 1:numel(oFiles)
        oGenes{jj} = getGeneListsFromFiles(oFiles{jj});
    end
    oGenes = cat(1, oGenes{:});
    [~, idx1] = setxor(genes3, oGenes);
    genes3 = genes3(idx1);
%     
    % get file names
    [~, ~, idx2] = intersect(genes3, table2cell(geneIds_names(:,1)));
    genes3_new = geneIds_names(idx2,4);
    
    %% ---------------------
    % 2) extract genes high in the lineage (foldChange>4, readCount>=10 in
    % atleast two of the three lineage samples
    % a) get readCounts
    [geneList, idx1, ~] = intersect(datasets(datasetId).genes, table2cell(genes3_new));
    readCounts = datasets(datasetId).rawReads(idx1,sampleColumns);
    %%
    % b)compute fold change matrix. (m*n,
    % m:genes, n:foldchanges = sample1(fpkm+1)/sample2(fpkm+1)
    % sample1 has higher readcount than sample2
    v1 = lineageColumns{ii};
    v2 = setxor(sampleColumns, v1);
    [v3,v4] = ndgrid(v1,v2);
    sampleIds = [v3(:), v4(:)];
    
    foldChange = zeros(size(readCounts,1), size(sampleIds,1));
    for jj = 1:size(foldChange,2)
        counts = readCounts(:,[sampleIds(jj,:)])+1;
        fc = counts(:,1)./counts(:,2);
        %fc(fc<1) = 1./(fc(fc<1));
        foldChange(:,jj) = fc;
    end
    %% ----------------------
    % 3-5)
    % filter genes based on maximum fold change: fold change threshold = 2.
    % top 100 genes in each sample comparison
    
    genes1 = cell(1, size(foldChange,2));
    genes1_up = genes1; genes1_down = genes1;
    genes2_up = genes1; genes2_down = genes2_up;
    
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
        genes1_up{jj} = upGenes;
        genes1_down{jj} = downGenes;
        
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
        genes2_up{jj} = upGenes(idx1(1:nCutoff_up));
        genes2_down{jj} = downGenes(idx2(1:nCutoff_down));
    end
    %%
    deGenes_fcCutoff_up = unique(cat(1, genes1_up{:}));
    deGenes_fcCutoff_down = unique(cat(1, genes1_down{:}));
    deGenes_nCutoff_up = unique(cat(1, genes2_up{:}));
    deGenes_nCutoff_down = unique(cat(1, genes2_down{:}));
    
    %%
    % only keep genes with max readcount in that lineage, and readcounts>=10 in atleast two cell types of that lineage
    deGenes_high = {deGenes_fcCutoff_up, deGenes_nCutoff_up};
    deGenes_veryHigh = cell(1,2);
    for kk = 1:2
        [common, idx1, idx2] = intersect(datasets(datasetId).genes,deGenes_high{kk});
        readCounts = datasets(datasetId).rawReads(idx1,sampleColumns);
        [~, maxValueId] = max(readCounts,[],2);
        toKeep = ismember(maxValueId, lineageColumns{ii});
        readCounts_lineage = readCounts(:,lineageColumns{ii});
        deGenes_veryHigh{kk} = common(sum(readCounts_lineage>=minReadCount,2)>=minLineageSamples & toKeep);
    end
    lineageGenes_fcCutoff{ii} = deGenes_veryHigh{1};
    lineageGenes_nCutoff{ii} = deGenes_veryHigh{2};
end

%% -----------------------------------------------------------------------
%% -----------------------------------------------------------------------

geneList1= unique(cat(1,lineageGenes_fcCutoff{:}));
geneList2 = unique(cat(1, lineageGenes_nCutoff{:}));
geneLists = {geneList1, geneList2};
%%
geneList1 = cat(1, deGenes(1).lineageSpecificFc{:});

%%
datasetIdx1 = 4;
datasetIdx2 = 1;
samplesIdx1 = 1:numel(datasets(datasetIdx1).samples)-1;
samplesIdx2 = 1:numel(datasets(datasetIdx2).samples);

geneList2 = deGenes.ourCells;
plotCorrelationCoefficients(datasets(datasetIdx1), datasets(datasetIdx2), samplesIdx1, samplesIdx2, geneList2);
%%
ax = gca;
ax.YDisplayLabels = upper(strrep(datasets(datasetIdx1).samples(samplesIdx1), '_', '\_'));
ax.XDisplayLabels = upper(strrep(datasets(datasetIdx2).samples(samplesIdx2), '_', '\_'));
%%
ax = gca;
ax.FontSize = 30;

%%
saveInPath = '/Users/sapnachhabra/Desktop/figuresForPaper/figures/trophectoderm/rnaseq/correlationPlots_new';
saveAllOpenFigures(saveInPath);

%%
function geneList = getGeneListsFromFiles(files)
geneList = cell(1,numel(files));
for ii = 1:numel(files)
    file1 = readtable([files(ii).folder filesep files(ii).name]);
    geneList{ii} = table2cell(file1(:,1));
end
geneList = unique(cat(1, geneList{:}));
end