
%% compare z score values

data = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/humanEmbryoOurCells.csv');
samples = data.Properties.VariableNames;
allGenes = table2cell(data(:,1));
%%

embryoCells = table2array(data(:, 2:12));
ourCells = table2array(data(:,13:16));

e1 = zscore(embryoCells,[],2);
c1 = zscore(ourCells,[],2);

%%
% normalize gene expression range across samples in embryo cells and
% our cells to make the range of gene expression same.
%
% e1 = (embryoCells - mean(embryoCells,2))./std(embryoCells,[],2);
% c1 = (ourCells - mean(ourCells,2))./std(ourCells,[],2);
% zscores = [e1 c1];
% zscores(isinf(zscores)|isnan(zscores)) = 0;

%%
deFilePath = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/DEanalyses';
files = {'BMP4_48h.csv', 'BMP_IWP2_48h.csv', 'BMP_SB_48h.csv'};
cId = 13:15;
counter1 = 1;

for fileId = 1:3
    file1 = [deFilePath filesep files{fileId}];
    data = readtable(file1);
    genes1 = table2cell(data(:,1)); % significantly differentially expressed genes
    [common, idx1, idx2] = intersect(genes1, allGenes);
    %%
    ec1 = [e1 c1];
    ec1 = ec1(idx2,:); % extract those genes from all samples
    %%
    counter2 = 1;
    for ii = [12 cId(fileId)]
        for jj = 1:15
            [cc, p] = corrcoef(ec1(:,ii),ec1(:,jj));
            corrCoeff(counter2,jj, counter1) = cc(1,2);
            pValues(counter2,jj, counter1) = p(1,2);
        end
        counter2 = counter2+1;
    end
    counter1 = counter1+1;
end
%%
data1_idx = 12:15;
data2_idx = 1:11;

data1_idx_names = samples(data1_idx+1);
data2_idx_names = samples(data2_idx+1);

[cc, idx] = max(corrCoeff(:,1:10),[],2);

for ii = 1:4
    figure;
    
    jj = idx(ii);
    scatter(ec1(:,data1_idx(ii)), ec1(:,jj));
    xlabel(data1_idx_names(ii)); ylabel(data2_idx_names(jj)); title('zscore');
    
end




