function plotCorrelationCoefficients(dataset1, dataset2, sampleIds1, sampleIds2, geneList)
%% ----- function to plot similarity matrix
% -- inputs: datasets, sampleIds, geneList
% -- output: similarity matrix
%%
% extract read count values
reads1 = zeros(numel(geneList), numel(sampleIds1));
reads2 = zeros(numel(geneList), numel(sampleIds2));

[common1, idx1, idx21] = intersect(geneList, dataset1.genes);
reads1(idx1,:) =  dataset1.normReads_log(idx21, sampleIds1);
%reads1 = zscore(reads1, 0, 2);

[common2, idx1, idx22] = intersect(geneList, dataset2.genes);
reads2(idx1,:) =  dataset2.normReads_log(idx22, sampleIds2);
%reads2 = zscore(reads2, 0, 2);

if sum(idx21-idx22)
    sprintf('Error!!');
end

% compute correlation coefficients
ccMatrix = zeros(numel(sampleIds1), numel(sampleIds2));
for ii = 1:numel(sampleIds1)
    for jj = 1:numel(sampleIds2)
        cc = corrcoef(reads1(:,ii), reads2(:,jj));
        ccMatrix(ii,jj) = round(cc(1,2),2);
    end
end

% plot
figure;
h = heatmap(ccMatrix); colormap('jet');
%caxis([-0.3 0.53]);
h.YDisplayLabels = strrep(dataset1.samples(sampleIds1), '_', ':');
h.CellLabelColor = 'none';
h.XDisplayLabels = strrep(dataset2.samples(sampleIds2), '_', ':');
ax = gca; ax.FontSize = 25;
end
