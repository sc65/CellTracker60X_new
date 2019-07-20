%% ------------------------------- 
% find fold change of embryonic stages wrt to epiblast;
% fold change of treatments wrt media.

%%
alldata = readtable('/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/humanEmbryoOurCells.csv');
%%
% extract only fpkm values
data1 = alldata(:,2:16);
data1 = table2array(data1);

% compute fold change (w.r.t. epiblast case1; w.r.t. media case2)
fc = [data1(:,1:11)./data1(:,10) data1(:,12:15)./data1(:,12)];
%%
% extract genes that are expressed in epiblast and media
dat2 = data1(data1(:,10)&data1(:,12) > 0,:);
%%
fc = [dat2(:,1:11)./dat2(:,10) dat2(:,12:15)./dat2(:,12)];
%%

similar = zeros(15); pValue = similar;

%% ----- are they (our cells vs human embryo different lineages) significantly different?
for ii = 1:15
    for jj = 1:15
        [similar(ii,jj), pValue(ii,jj)] = kstest2(fc(:,ii), fc(:,jj));
        
    end
end

%% ------ how different are they?
% extract genes that are expressed in epiblast and media
expressedInEpiblast = alldata(table2array(alldata(:,10))&table2array(alldata(:,13)) > 0,:);
%%
data = table2array(expressedInEpiblast(:,2:16));
fc1 = data(:,1:11)./data(:,9);
fc2 = data(:,12:15)./data(:,12);
%%





