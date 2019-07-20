
%%
% --- similarity amongst different treatments - media, bmp treatments
%%
% 1) kstest2
file1 = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/rnaSeqExperiments/rnaSeq_datasets_fpkmTable/rnaSeq_forPaper.csv';
allData = readtable(file1);
%%
readCounts = table2array(allData(:,3:end));
%%
kstest_results = zeros(12);
pValue = kstest_results;
corrCoeff = pValue;

for ii = 1:size(kstest_results,1)
    for jj = 1:size(kstest_results,1)
        [kstest_results(ii,jj), pValue(ii,jj)] = kstest2(readCounts(:,ii), readCounts(:,jj));
        cc = corrcoef(readCounts(:,ii), readCounts(:,jj));
        corrCoeff(ii,jj) = cc(1,2);
    end
end
%%
h = heatmap(corrCoeff(9:12, 9:12));
%%
% --- all replicates except iwp2 sample are significantly similar (kstest = 0)
% --- read counts in all samples is highly correlated (corrcoeff > 0.92)
%%

% plot readcounts1 vs other
readCounts = table2array(allData(:,11:end));
readCounts_zScores = zscore(readCounts,0,2);
checkId = [1 2; 1 3; 2 3];

for ii = 1:size(checkId,1)
    figure; scatter(readCounts_zScores(:,checkId(ii,1)), readCounts_zScores(:,checkId(ii,2)));
end


