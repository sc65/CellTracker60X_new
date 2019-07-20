
%%
geneFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/geneNames.txt';
geneId_names = readtable(geneFile);
%%
humanEmbryoData = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/humanEmbryo.xlsx');
%%

% extract geneIds for genes in file1, and save two text files (epi_e5, te_e7)
[common, idx1, idx2] = intersect(table2cell(humanEmbryoData(:,1)), table2cell(geneId_names(:,4)));
%% --------------------------------------------------------------------------------------------
%%
% --- write text file using matlab
fileDir = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/for_rsem_ebseq/rawFiles/humanEmbryo';
mkdir(fileDir);
genes = table2cell(geneId_names(idx2,1));
sampleNames = humanEmbryoData.Properties.VariableNames;
pairs = nchoosek([2:10],2);

for ii = 1:size(pairs,1)
    readCounts = table2array(humanEmbryoData(idx1,[pairs(ii,1) pairs(ii,2)]));
    sample1 = strrep(sampleNames{pairs(ii,1)}, '_', '');
    sample2 =  strrep(sampleNames{pairs(ii,2)}, '_', '');
    fileID = fopen([fileDir filesep sample1 '_' sample2 '.txt'],'w');
    fprintf(fileID,'"%s"\t',sample1);
    fprintf(fileID,'"%s"\n',sample2);
    for jj = 1:size(readCounts,1)
        fprintf(fileID, '"%s"\t %f\t %f\n', genes{jj}, readCounts(jj,1), readCounts(jj,2));
    end
    fclose(fileID);
end
%% -------------------------------------------------------------------------------------------
%% ------ human TS cells
%%
tsCells = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/trophoblastStemCells.xlsx');
%%
[common, idx1, idx2] = intersect(table2cell(tsCells(:,1)), table2cell(geneId_names(:,4)));
%%
sampleNames = {'CT', 'EVT', 'ST', 'Stroma', 'TsCT', 'TSBlast'};
columnIds = [2,5,8,11,13,20];
nReplicates = [3,3,3,2,2,2];

fileDir = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/for_rsem_ebseq/rawFiles/humanTScells';
mkdir(fileDir);
%%
genes = table2cell(geneId_names(idx2,1));
pairs = nchoosek([columnIds],2);

for ii = 1:size(pairs,1)
    ii
    % get readcounts for both samples, all replicates
    nReplicates1 = nReplicates(columnIds == pairs(ii,1));
    nReplicates2 = nReplicates(columnIds == pairs(ii,2));
    cIds = [pairs(ii,1):pairs(ii,1)+ nReplicates1-1 pairs(ii,2):pairs(ii,2)+nReplicates2-1];
    readCounts = table2array(tsCells(idx1,cIds));
    
    % get sampleNames
    sample1 = strrep(sampleNames{columnIds == pairs(ii,1)}, '_', '');
    sample2 =  strrep(sampleNames{columnIds == pairs(ii,2)}, '_', '');
    
    % write sampleNames
    fileID = fopen([fileDir filesep sample1 '_' sample2 '.txt'],'w');
    for jj = 1:nReplicates1
        fprintf(fileID,'"%s"\t',[sample1 '_' int2str(jj)]);
    end
    for jj = 1:nReplicates2
        fprintf(fileID,'"%s"\t', [sample2 '_' int2str(jj)]);
    end
    
    fprintf(fileID,'\n');
    
    % write genes, readcounts
    for kk = 1:size(readCounts,1)
        fprintf(fileID, '"%s"\t', genes{kk});
        for ll = 1:size(readCounts,2)
            fprintf(fileID, '%f\t', readCounts(kk,ll));
        end
        
        fprintf(fileID,'\n');
    end
    fclose(fileID);
end

































