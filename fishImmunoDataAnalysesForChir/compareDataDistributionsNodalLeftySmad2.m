function compareDataDistributionsNodalLeftySmad2(allSamplesData, functionsToUse, samples, samplesToCompare, colors)
%% plots overlapping cell distributions, of the sample pairs listed in samplesToCompare.
%%%%----------Inputs-----------
% make sure the current folder contains the output files.
% --- allSamplesData - a cell array, every cell represents a different
% condition.
% --- functionsToUse - various possible interesting data to consider for
% plotting. refer the function defineFunctions. 
% ----samples - cell array of sample names.
%%%%---------------------------

[titles, functions] = defineFunctions();
xAxislimit = [2500 2000 4500]; %[tprotein nodalmRNA tmRNA]; %specify axis limits in the order of functionToUse.
yAxislimit = [0.5 1 1];
binWidths = [200 300 20];

if ~exist('samples', 'var')
    samples = {'Negative Control', 'No treatment', '3 hr', '6 hr' , '9 hr', '12 hr'};
end

if ~exist('samplesToCompare', 'var')
    samplesToCompare = {[2 3:6], [2 3], [3 4], [4 5], [5 6], [2 6]};
end


%% plot
for ii = 1:length(functionsToUse)
    for jj = 1:length(samplesToCompare)
        toCompare = samplesToCompare{jj};
        data1 = cell(1, length(toCompare));
        
        figure;
 
        hold on;
        
        for kk = 1:length(toCompare)
            data = allSamplesData{toCompare(kk)};
            fun = functions{functionsToUse(ii)};
            data1{kk} = fun(data);
            histogram(data1{kk}, 'BinWidth', binWidths(ii), 'Normalization', 'Probability', ...
                'DisplayStyle','stairs', 'LineWidth', 2, 'EdgeColor', colors{kk})         
        end
        
        
        legend(samples(toCompare), 'Box', 'off');
        xlabel([titles(functionsToUse(ii)) '(A.U.)']);
        ylabel('pdf');
        xlim([0 xAxislimit(ii)]);
        ylim([0 yAxislimit(ii)]);
        ax = gca;
        ax.FontSize = 14;
        ax.FontWeight = 'bold';
    end
end












