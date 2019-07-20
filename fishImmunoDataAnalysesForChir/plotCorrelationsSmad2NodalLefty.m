function plotCorrelationsSmad2NodalLefty (allSamplesData, samplesToUse, samples)
% %%%% -------Inputs---------- 
%--functionToUse: integer value corresponding to the function used - refer
%define functions.
% Customise plot Parameters according to Data.

if ~exist('samples', 'var')
    samples = {'Control', '6 hr', '12 hr' , '18 hr', '24 hr ', '30 hr', '36 hr'};
end
    
[titles, functions] = defineFunctions();
figure;
counter = 1;

fun = [2 5 8];

for ii = 1:numel(samplesToUse)
    data = allSamplesData{samplesToUse(ii)};
    fun1 = functions{fun(1)};
    fun2 = functions{fun(2)};
    fun3 = functions{fun(3)};
    nucSmad2 = fun1(data);
    nucNodal = fun2(data);
    nucLefty = fun3(data);
    
    c1 = corr(nucLefty, nucSmad2);
    display(['Correlation between Lefty and smad2 is:' num2str(c1)]);
    
    subplot(numel(samplesToUse),2,counter);
    counter = counter+1;
    plot( nucSmad2, nucNodal, '.', 'MarkerSize', 12, 'Color', [0 0.4 0]);
    xlim([0 2e3]);
    ylim([0 2e3]);
    xlabel(titles{fun(1)});
    ylabel(titles{fun(2)});
    title(samples{ii});
    ax = gca;
    ax.FontSize = 14;
    ax.FontWeight = 'bold';
    
    c1 = corr(nucNodal, nucSmad2);
    display(['Correlation between Lefty and smad2 is:' num2str(c1)]);
    
    subplot(numel(samplesToUse),2,counter);
    counter = counter+1;
    plot(nucSmad2, nucLefty, '.', 'MarKerSize', 12, 'Color', [0 0.4 0]);
    ylim([0 5e3]);
    xlim([0 2e3]);
    xlabel(titles{fun(1)});
    ylabel(titles{fun(3)});
    title(samples{ii});
    ax = gca;
    ax.FontSize = 14;
    ax.FontWeight = 'bold';
end
    