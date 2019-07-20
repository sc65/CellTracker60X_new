function barPlotAllPositions(functionToUse, samples)
%% check if cells in all positions behave similarly.
%--functionToUse: integer value corresponding to the function used - refer
%define functions.
%----Note: customise axis limits, subplot according to samples. 

if ~exist('samples', 'var')
    samples = {'Negative Control', 'No treatment', '3 hr', '6 hr' , '9 hr', '12 hr'};
end

[titles, functions] = defineFunctions();

%%
allMeans = zeros(6,8);
allStds = allMeans;

for ii = 1:length(samples)
    outputFile = ['output_' int2str(ii) '.mat'];
    load(outputFile);
    
    for jj = 1:length(peaks)
        allMeans(ii,jj) =  mean(functions(functionToUse(peaks{jj})));
        allStds(ii, jj) = std(functions(functionToUse(peaks{jj})));
    end
end

figure;
for ii = 2:6
    subplot(3,2,ii-1);
    h = barwitherr(allStds(ii,:), allMeans(ii,:));
    set(h, 'FaceColor', [0 0.5 0]);
    title(samples{ii});
    ylabel(titles(functionToUse));
    %ylim([0 1500]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
end

