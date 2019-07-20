function plotTrends (allSamplesData, functionToUse,  samplesToCompare, colorArray, normaliseTo, xTickLabels)
%% plots the mean values with errorbars(std deviation) across different timePoints.
%%%% -------Inputs----------
%-- functionToUse: integer value corresponding to the function used - refer
%define functions.
%-- normaliseTo: value to which all other values are normalised, usually
%mean of the control sample.

% Customise plot Parameters according to Data.

%------------------------------
if ~exist('xTickLabels', 'var')
    xTickLabels = {'Control', '03' , '06', '09', '12'};
end
xValues = 1:length(xTickLabels);


[titles, functions] = defineFunctions();
fun = functions{functionToUse};

combinedMeans = zeros(1,numel(samplesToCompare));
combinedStds = zeros(1,numel(samplesToCompare));
sampleCount = 1;

for ii = samplesToCompare
    data = allSamplesData{ii};
    
    if isempty(normaliseTo)
        if ii==samplesToCompare(1) % t=0 data.
            normaliseTo = mean(fun(data));
        end
    end
    
    combinedMeans(1,sampleCount) = mean((fun(data)./normaliseTo));
    combinedStds(1,sampleCount) = std((fun(data)./normaliseTo));
    sampleCount = sampleCount+1;
end

%xValues= [0 3 6 9 12];

%figure;
errorbar(xValues, combinedMeans, combinedStds, 'LineWidth', 1, 'Color', colorArray);
hold on;
plot(xValues, combinedMeans,  '-+', 'LineWidth', 3, 'Color', colorArray);

xlim([0.5 max(xValues) + 0.5]);
xlabel('Time(hr) after treatment');
ylabel(titles(functionToUse));
ax = gca;
ax.XTick = xValues;
ax.XTickLabels = xTickLabels;
ax.FontSize = 14;
ax.FontWeight = 'bold';

