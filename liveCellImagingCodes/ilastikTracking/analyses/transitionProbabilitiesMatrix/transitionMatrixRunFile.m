%%
outputFile = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/outputFiles/outputAll.mat';
load(outputFile);
colonyIdsToKeep = [2:7];

% filter cells in the colonies 2-7.
allColonyIds = cellfun(@(x) x(1,3), allColoniesCellStats);
cellsToRemove = ~ismember(allColonyIds, colonyIdsToKeep);
%
allColoniesCellStats(cellsToRemove) = [];
% %% smaple run
% timePoints = [80 164]; % time points during which cell transition has to be determined.
% %regionBounds = [0 77.2 194.73 400];
% regionBounds = [0:100:400];
% [transitionMatrix, nCellsInRegion] = makeTransitionMatrix(allColoniesCellStats, colonyCenters, umToPixel, regionBounds, timePoints);
%%
% 1) How do cells in the colony move in time?
% => How do transition probabilities vary across different regions in
% different time intervals?

%regionBounds = [0 77.2 194.73 400];
regionBounds = [0:100:400];
timePoints = [0 41 123 164];

nTimes = numel(timePoints)-1;
nRegions = numel(regionBounds)-1;

pIn = zeros(nTimes, nRegions-1);
pOut = pIn;
nIn =  pIn;
nOut = nIn;

pStay = zeros(nTimes, nRegions);
nStay = pStay;

pTransitions = cell(1,nTimes);

for ii = 1:nTimes
    
    [transitionMatrix, nCellsInRegion] = makeTransitionMatrix(allColoniesCellStats, colonyCenters, ...
        umToPixel, regionBounds, timePoints(ii:ii+1));
    
    pTransition = transitionMatrix./nCellsInRegion;
    pTransitions{ii} = pTransition; % for later usage.
    
    figure; imagesc(transitionMatrix); colorbar; caxis([0 20]);
    t1 = num2str(20+ floor((timePoints(ii)/6)));
    t2 = num2str(20+ floor((timePoints(ii+1)/6)));
    title(['t=' t1 ':' t2]);
    
    idx = (nRegions+1)*(1:nRegions-1); %linear index of matrix elements to keep.
    pIn(ii,:) = pTransition(idx);
    nIn(ii,:) = transitionMatrix(idx);
    
    transitionMatrix2 = transitionMatrix';
    pTransition2 = pTransition';
    pOut(ii,:) = pTransition2(idx);
    nOut(ii,:) = transitionMatrix2(idx);
    
    diff = nRegions+1;
    idx = 1+(0:nRegions-1)*diff;
    pStay(ii,:) = pTransition(idx);
    nStay(ii,:) = transitionMatrix(idx);
    
end
%% plotting probability vs time interval for each region.
figure;

for ii = 1:nRegions
    
    yValues = pStay(:,ii); %stay same
    xValues = [1:numel(timePoints)-1]';
    
    subplot(2,4,ii);
    plot(xValues, yValues, '-', 'Color', [0.9 0 0], 'LineWidth', 3);
    hold on;
    
    if ii<nRegions
        yValues = pIn(:,ii); %move to the region inside.
        plot(xValues, yValues, '-', 'Color', [0 0.4 0], 'LineWidth', 3);
    end
    
    if ii>1
        yValues = pOut(:,ii-1); %move to the region outide.
        plot(xValues, yValues, '-', 'Color', [0 0 0.8], 'LineWidth', 3);
    end
    
    ylim([0 1]);
    xlabel('Time Intervals');
    ylabel('Probability');
    title(['Region' int2str(ii)]);
    
    if ii == 2
        legend({'Stay there', 'Move in', 'Move out'});
    end
            
    ax = gca;
    ax.XTick = 1:nTimes;
    %ax.XTickLabel = {'I', 'II', 'III', 'IV'};
    ax.FontSize = 12; ax.FontWeight = 'bold';
    
end
%%
































