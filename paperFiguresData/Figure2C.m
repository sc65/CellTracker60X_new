%%

%% -------- Figure  2C, D, E

saveInFile = '/Volumes/sapnaDrive2/190713_FiguresData/Figure2.mat';
%%
datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/allDeGenes/deGenes.mat';
load(datasetsFile);
%%
sL = {'BMP4+IWP2:BMP4', 'BMP4+IWP2:mTeSR', 'BMP4+SB:BMP4', 'BMP4+IWP2:BMP4+SB', 'BMP4+SB:BMP4+mTeSR', 'BMP4:mTeSR'};
Fig2C.samplesCompared = sL;
Fig2C.genesFoldChange = deTable2;

save(saveInFile, 'Fig2C', '-append');
%%

datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/datasets.mat';
load(datasetsFile);
%%
saveInFile = '/Volumes/sapnaDrive2/190713_FiguresData/SupplementaryTable2.xls';
DifferentiallyExpressed_top100 = deGenes(1).ourCells;
writetable(table(DifferentiallyExpressed_top100),saveInFile,'Sheet',1)

lineageSpecific = unique(cat(1, deGenes(1).lineageSpecificFc{:}));
writetable(table(lineageSpecific),saveInFile,'Sheet',2);
