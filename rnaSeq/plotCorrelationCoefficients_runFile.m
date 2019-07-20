

%%
datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/datasets.mat';
load(datasetsFile);
%%

%geneList = datasets(1).genes;
geneList1 = unique(cat(1, deGenes(2).all));
geneList2 = unique(cat(1, deGenes(2).foldChangeN));
geneList3 = unique(cat(1, deGenes(2).topN));
geneLists = {geneList1, geneList2, geneList3};
%%
% --- modify geneLists to include only expressed genes (readCount>1 in
% atleast 1 sample in every dataset)
datasetId = [1:4];
sampleId = {1:9, 1:10, 1:4, 1:4};
expressedGenes = geneLists;
for ii = 1:numel(geneLists)
    for jj  = datasetId
        [common, idx1, idx2] = intersect(datasets(jj).genes, geneLists{ii});
        readCounts = datasets(jj).rawReads(idx1,sampleId{jj});
        list1 = geneLists{ii}(sum(readCounts,2) > 0);
        if jj == 1
            newList = list1;
        else
            [common, ~,~] = intersect(newList, list1);
        end
    end
    expressedGenes{ii} = common;
end


%%
datasetIdx1 = 1;
datasetIdx2 = 1;
samplesIdx1 = 1:numel(datasets(datasetIdx1).samples);
samplesIdx2 = 1:numel(datasets(datasetIdx2).samples);

for ii = 1
    plotCorrelationCoefficients(datasets(datasetIdx1), datasets(datasetIdx2), samplesIdx1, samplesIdx2, geneLists{ii});
end

%%
saveInPath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/graphs/correlationCoefficientsNew/allDeGenes';
saveAllOpenFigures(saveInPath);
