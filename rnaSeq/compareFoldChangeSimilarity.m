
%%
%rna-seq analyses.
%which embryonic cell lineage are hESCs treated with BMP mos similar to?

%%
data = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/humanEmbryoOurCells.csv');
%%
samples = data.Properties.VariableNames
%%
% our cells:
embryoCells = table2array(data(:, 2:12));
ourCells = table2array(data(:,13:16));

%%
% foldChange>0 - upregulated;
% foldChange<0 - downregulated

control1 = 9; %[9 10] [epiblast hESC]
control2 = 1; % plain media

fc1 = log2((embryoCells+1)./(embryoCells(:,control1)+1)); % +1 to include genes unexpressed in control
fc2 = log2((ourCells+1)./(ourCells(:,control2)+1));
%%
foldChange = [fc1 fc2];
foldChange(isinf(foldChange)|isnan(foldChange)) = 0; % remove nan inf

%%
genes = table2cell(data(:,1));
%%
% at least 2 fold high - foldChange>1
% tabulate upregulated genes in all conditions
genes_up = cell(1,15);
for ii = 1:15
    up = foldChange(:,ii) > 1;
    genes_up{ii} = genes(up);
    foldChange_up{ii} = foldChange(up,ii);
end

%%
% find overlap in upregulated genes between embryo cell types and
% hESC treatments

data1_idx= 1:15; % all cells
data2_idx = 13:15; % hESCs

commonGenes_up = cell(numel(data2_idx),numel(data1_idx)); 
commonGenes_fraction_up = zeros(numel(data2_idx), numel(data1_idx));
corrcoeff_up = zeros(numel(data2_idx), numel(data1_idx));
pValues_up = corrcoeff_up;

counter1 = 1;
for ii = data2_idx
    counter2 = 1;
    for jj = data1_idx
        [common, idx1, idx2] = intersect(genes_up{ii}, genes_up{jj});
        [cc, p] = corrcoef(foldChange_up{ii}(idx1),foldChange_up{jj}(idx2));
        corrcoeff_up(counter1, counter2) = cc(1,2);
        pValues_up(counter1, counter2) = p(1,2);
        commonGenes_fraction_up(counter1, counter2) = numel(common)/numel(genes_up{ii});
        geneTable = table(common, foldChange_up{ii}(idx1), foldChange_up{jj}(idx2));
        geneTable = sortrows(geneTable, 2, 'desc');
        commonGenes_up{counter1,counter2} = geneTable;
        counter2 = counter2+1;
    end
    counter1 = counter1+1;
end

%%
% find the most correlated cluster. 
% plot fold change values. 

data1_idx_names = samples(data1_idx+1);
data2_idx_names = samples(data2_idx+1);

[corrCoeff, idx] = max(corrcoeff_up(:,1:10),[],2);
for ii = 1:3
    figure;
    for jj = idx'
        table1 = commonGenes_up{ii,jj};
        scatter(table2array(table1(:,2)), table2array(table1(:,3)));
        xlabel(data2_idx_names(ii)); ylabel(data1_idx_names(jj)); title('FoldChanges');
    end
end

%%
%% -------------------------------------- 
%% downregulated genes


% at least 2 fold low : foldChange<-1
genes_low = cell(1,15);

for ii = 1:15
    low = foldChange(:,ii) < -1;
    genes_low{ii} = genes(low);
    foldChange_low{ii} = foldChange(low,ii);
end



data1_idx= 13:15;
data2_idx = [1:8 9 11:15];

commonGenes_low = cell(3,10); 
corrcoeff_low = zeros(numel(data1_idx), numel(data2_idx));
pValues_low = corrcoeff_low;
counter1 = 1;

for ii = data1_idx
    counter2 = 1;
    for jj = data2_idx
        [common, idx1, idx2] = intersect(genes_low{ii}, genes_low{jj});
        [cc, p] = corrcoef(foldChange_low{ii}(idx1),foldChange_low{jj}(idx2));
        corrcoeff_low(counter1, counter2) = cc(1,2);
        pValues_low(counter1, counter2) = p(1,2);
        
        geneTable = table(common, foldChange_low{ii}(idx1), foldChange_low{jj}(idx2));
        geneTable = sortrows(geneTable, 2);
        commonGenes_low{counter1,counter2} = geneTable;
        counter2 = counter2+1;
    end
    counter1 = counter1+1;
end
%%
% plot
[corrCoeff, idx] = max(corrcoeff_low(:,1:10),[],2);
for ii = 1:3
    figure;
    for jj = idx'
        table1 = commonGenes_low{ii,jj};
        scatter(table2array(table1(:,2)), table2array(table1(:,3)));
        xlabel(data2_idx_names(ii)); ylabel(data1_idx_names(jj)); title('FoldChanges');
    end
end

%% ----- save fold change tables with correct sample names
data1_idx_names = samples(data1_idx+1);
data2_idx_names = samples(data2_idx+1);
%%
saveInPath = 'foldChangeTables';
mkdir(saveInPath);

for ii = 1:3
    for jj = 1:10
        commonGenes_up{ii,jj}.Properties.VariableNames{2} = data1_idx_names{ii};
        commonGenes_up{ii,jj}.Properties.VariableNames{3} = data2_idx_names{jj};
        
        commonGenes_low{ii,jj}.Properties.VariableNames{2} = data1_idx_names{ii};
        commonGenes_low{ii,jj}.Properties.VariableNames{3} = data2_idx_names{jj};
        
        writetable(commonGenes_up{ii,jj}, [saveInPath filesep 'up_' int2str(ii) '_' int2str(jj) '_.csv'],...
            'Delimiter',',', 'QuoteStrings',true, 'WriteRowNames', false);
        
        writetable(commonGenes_low{ii,jj}, [saveInPath filesep 'down_' int2str(ii) '_' int2str(jj) '_.csv'],...
            'Delimiter',',', 'QuoteStrings',true, 'WriteRowNames', false);
    end
end

%%
%%



% similarity score based on
% 1) common genes
% 2) fold change values

%%









