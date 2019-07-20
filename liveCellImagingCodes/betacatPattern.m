% close all;
clearvars;
rawImage = '/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/colony3small_composite.tif';
colonyMask = imread('/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/colony3small_colonymask.tif');
membraneMasks = readIlastikFile('/Volumes/SAPNA/161014LiveCellLaserScanning/FV10__20161012_180616/fullColonies/colony3/colony3smallMembraneSimple Segmentation.h5');
membraneMasks = membraneMasks & colonyMask; % remove dead cells outside the boundary.
%%
dists = bwdist(~colonyMask);
binsize = 50;%Rerun
rollsize = 20;

processT = @(t) (t-1).*3 + 1;%% convert hour to timepoint
timepoints = processT([1 36:42]); %in hour 

label = cell(1, length(timepoints));

for ii = 1:numel(timepoints)
    label{ii} = [num2str(((timepoints(ii)-1)/3) + 1) 'h'];
end

limit = max(max(dists)) - binsize;
intensity = zeros(numel(timepoints),numel(0:rollsize:limit)); %everything excluding membrane pixels.
standard_deviation = intensity;

membraneIntensity = intensity;

filereader = bfGetReader(rawImage);
counter = 1;
for t = timepoints
    z  = 1;
    ch = 2;
    q = 1;
    iplane = filereader.getIndex(z-1, ch-1, t-1)+1;
    image1 = bfGetPlane(filereader, iplane);
    
    %figure; imshow(image1,[]);
    %title(['t=' int2str(t)]);
    
    %compute distance transform i.e. distance of each pixel within the colony
    %from the colony boundary
    
    for ii = 0:rollsize:limit
        idx = dists>ii &  dists<ii+binsize;
        membraneIdx = getMembranePixels(idx, membraneMasks(:,:,t));
        idx = removeMembranePixels(idx, membraneMasks(:,:,t));
        intensity(counter,q) = mean(image1(idx));
        standard_deviation(counter, q) = std(double(image1(idx)))/sqrt(length(idx));
        membraneIntensity(counter,q) = mean(image1(membraneIdx));
        q = q+1;
    end
    counter = counter+1;
end

xaxis_values = linspace(0, max(max(dists))/1.55, length(intensity));
colormat = [0 0.5 0; rand(length(timepoints)-2,3); 1 0 0] ;

figure;
betaCatT0mean = min(intensity(1,:));

% plot all time points in one graph
for i = 1:length(timepoints)
    %errorbar(xaxis_values, intensity(i,:), standard_deviation(i,:), 'k-');
    hold on;
    plot(xaxis_values, intensity(i,:)./betaCatT0mean, 'Color', [colormat(i,:)], 'LineWidth', 4);
    %plot(xaxis_values, membraneIntensity(i,:)./min(membraneIntensity(1,:)), 'Color', [colormat(i,:)], 'LineWidth', 4);
end
xlabel('Distance from the edge (\mum)');
ylabel('Radial Average (A.U.)');
legend(label);
title('\beta -catenin levels');
xlim([0 410]);
ylim([0 4.2]);
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';

%% start with 2 timepoints in one graph. Add one new timepoint on every subsequent graph.
% mark the point of maximum expression

toPlot = 2:numel(timepoints);
%toPlot = [2 numel(timepoints)]; % only for 24 and 42h data.
for ii = toPlot
    figure; hold on;
    timepoints1 = 1:ii;
    %timepoints1 = [1 2 ii]; % only for 24 and 42h data
    
    for jj = timepoints1
        plot(xaxis_values, intensity(jj,:)./betaCatT0mean, 'Color', [colormat(jj,:)], 'LineWidth', 4);
        
        if jj>1
            [maxValue, position] = max(intensity(jj,:)./betaCatT0mean);
             xValue = xaxis_values(position);
             plot([xValue xValue], [0 maxValue],  '-.', 'Color', [colormat(jj,:)], 'LineWidth', 2);
        end
          
        xlabel('Distance from the edge (\mum)');
        ylabel('Radial Average (A.U.)');
        title('\beta -catenin levels');
        
        xlim([0 410]);
        ylim([0 4.2]);
        ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
    end
end



















