
%%
masterFolder = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison';

trophoblast_early = readtable([masterFolder filesep 'humanEmbryo.xlsx']);
trophoblast_late1 = readtable([masterFolder filesep 'trophoblastStemCells.xlsx']);
trophoblast_late2 = readtable([masterFolder filesep 'trophoblastOrganoids.xlsx']);
ourCells = readtable([masterFolder filesep 'rnaSeq_forPaper_withPS.xlsx']);
monkeyEmbryo = readtable([masterFolder filesep 'monkeyEmbryoStemCells_humanGenes.xlsx']);
amnionInVitro = readtable([masterFolder filesep 'humanAmnionInVitro.csv']);
fetus = readtable([masterFolder filesep 'humanFetus.csv']);
%%
datasets_all = {trophoblast_early, trophoblast_late1, trophoblast_late2, ourCells, monkeyEmbryo}; %, amnionInVitro, fetus};
%%
% for all datasets keep only the genes where at least 1 sample has fpkm>0
% fpkmThreshold = 0;
% for ii = 1:numel(datasets)
%     if ii == 4 || ii == 5
%         readCounts = table2array(datasets{ii}(:,3:end));
%     else
%         readCounts = table2array(datasets{ii}(:,2:end));
%     end
%     idx = any(readCounts > fpkmThreshold,2);
%     datasets{ii} = datasets{ii}(idx,:);
% end

%%
% ------ keep only mean values
% column Ids for gene names and mean values
%cId = {[1:10]; [1 26:35]; [1 14:17]; [1 11 12 14 13]; [1 3:17]}; % without PS
cId = {[1:10]; [1 26:35]; [1 14:17]; [1 11 12 14 13 15]; [1 3:17]; [1:3]; [1:10]}; % with PS

%%
% mean values
for ii = 1:numel(datasets_all)
    datasets_new{ii} = datasets_all{ii}(:, [cId{ii}]);
end
%%
ourSamples = {'mTeSR', 'BMP',  'BMP+SB', 'BMP+IWP2', 'PS'};
datasets_names = {'preimplantationEmbryo', 'TScells', 'TSorganoids', 'hESCs', 'monkeyEmbryo', 'amnion', 'fetus'};

%% -----------------------------------------------------------------------------------------------
%% ---------- make the gene list uniform across the dtasets before calculating zscores -----------
allGenes1 = cell(1, numel(datasets_new));
for ii = 1:numel(datasets_new)
    allGenes1{ii} = table2cell(datasets_new{ii}(:,1));
    find(contains(allGenes1{ii}, 'no_feature'))
end
%%
allGenes = table(unique(cat(1, allGenes1{:})));
%%
writetable(allGenes, 'allGenes.xlsx');
%%
%% ----------------------------------------------------------------------------------------------
datasets_new_uniform = cell(1, numel(datasets_new));
for ii = 1:numel(datasets_new)
    genes1 = table2cell(datasets_new{ii}(:,1));
    readCounts1 = table2array(datasets_new{ii}(:,2:end));
    readCounts_new = zeros(numel(allGenes), size(readCounts1,2));
    [common, idx1, idx2] = intersect(table2cell(allGenes), genes1);
    readCounts_new(idx1,:) = readCounts1(idx2, :);
    
    datasets_new_uniform{ii} = [allGenes, array2table(readCounts_new)];
    variableNames = datasets_new{ii}.Properties.VariableNames;
    for jj = 1:numel(variableNames)
        datasets_new_uniform{ii}.Properties.VariableNames{jj} = variableNames{jj};
    end
end

%% =============================================================================================
%% ---------------------- tranform read count values to z scores--------------------------------
%% fpkm histograms
%%
for ii = 1:numel(datasets_all)
    figure;
    readCounts = table2array(datasets_new_uniform{ii}(:,2:end));
    histogram(log2(readCounts+1), 'BinWidth', 1);  title(datasets_names{ii});
    xlabel('Read count (log2(fpkm+1))'); ylabel('Frequency'); xlim([-0.5 20]); %ylim([0 4.4e4]);
end
%%
for ii = 1:numel(datasets_all)
    figure; hold on;
    
    readCounts = table2array(datasets_new_uniform{ii}(:,2:end));
    readCounts_log = log2(readCounts+1);
    
    readCounts_zscore = zscore(readCounts, 0, 'all');
    datasets_new_zscore{ii} = readCounts_zscore;
    
    readCounts_log_zscore = zscore(readCounts_log, 0, 'all');
    datasets_new_log_zscore{ii} = readCounts_log_zscore;
    mean(readCounts_log_zscore, 'all')
    std(readCounts_log_zscore, [],'all')
    
    subplot(1,2,1);
    histogram(readCounts_zscore, 'BinWidth', 0.25);  title(datasets_names{ii});
    xlabel('fpkm zscore'); ylabel('Frequency'); %ylim([0 2.44e4]); xlim([-3.5 8]);
    
    subplot(1,2,2);
    histogram(readCounts_log_zscore, 'BinWidth', 0.25);  title(datasets_names{ii});
    xlabel('log2(fpkm+1) zscore'); ylabel('Frequency'); %ylim([0 2.44e4]); xlim([-3.5 8]);
end
%%

%% compare zscore similarity of top 100 de genes in hESCs with other samples

outputFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaseq_run2/DE_analyses_all/differentiallyExpreesed_comparedToMedia/deGenes.mat';
load(outputFile);

%% -------------------------------------------------------
%% -------------------------------------------------------
%% ------  save relevant data in a structure array -------
datasets = struct();
%%  --- fields
% 1)Name
% 2)Genes
% 3)samples
% 4)rawReads
% 5)normalizedReads_raw: zscores of fpkm values
% 6)normalizedReads_log: zscores of log2(fpkm) values
%%
for ii = 1:numel(datasets_new_uniform)
    datasets(ii).name = datasets_names{ii};
    datasets(ii).genes = table2cell(datasets_new_uniform{ii}(:,1));
    datasets(ii).samples = erase(datasets_new_uniform{ii}.Properties.VariableNames(2:end), '_mean');
    datasets(ii).rawReads = table2array(datasets_new_uniform{ii}(:,2:end));
    datasets(ii).normReads_fpkm = datasets_new_zscore{ii};
    datasets(ii).normReads_log = datasets_new_log_zscore{ii};
end

%%
datasetsFile = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/forFinalComparison/datasets.mat';
save(datasetsFile, 'datasets', '-append');
















