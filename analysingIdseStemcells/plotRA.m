
%%
masterFolder = '/Volumes/sapnaDrive2/181206_patterning_differentConditions/imaging2/finalImages/tiffFiles';

metaData = [masterFolder filesep 'Condition1' filesep 'metaData.mat'];
load(metaData);

colorFile = '/Users/sapnachhabra/Desktop/CellTrackercd/CellTracker60X/colorblind_colormap/goodColors_new.mat';
load(colorFile);

%%
conditionId = [1 6 9]; nColonies = zeros(1, numel(conditionId));
DAPIChannel = 1;
colSize = 350; % radius in um
ch = [3]; counter= 1;

figure; hold on;

colors = cell2mat({[0.7 0 0.2]; [0 0.6 0]; [0.2 0 0.6]});

for ii = conditionId
    outputFile = [masterFolder filesep 'Condition' int2str(ii) filesep 'colonies.mat'];
    load(outputFile);
    
    inds = [colonies.radiusMicron] == colSize;
    inds(badColoniesId) = 0; % remove bad colonies.
    
    colonies1 = colonies(inds);
    disp(['Condition' int2str(ii)]);
    [colonies1.ID]
    
    r = imfilter(colonies1(1).radialProfile.BinEdges,[1 1]/2)*meta.xres;
    r(1) = colonies1(1).radialProfile.BinEdges(1)*meta.xres;
    r = r(1:end-1);
    r1 = abs(r-r(end)); % edge distance
    
    colCat = cat(3,colonies1(:).radialProfile);
    nucAvgAll = mean(cat(3,colCat.NucAvg),3);
    nucAvgStd = std(cat(3,colCat.NucAvg),0,3);
    nucAvgStdError = nucAvgStd./sqrt(sum(inds));
    
    nucAvgAllNormalized = bsxfun(@rdivide, nucAvgAll, nucAvgAll(:,DAPIChannel));
    nucAvgStd = bsxfun(@rdivide, nucAvgStd, nucAvgAll(:,DAPIChannel));
    nucAvgStdError = bsxfun(@rdivide, nucAvgStdError, nucAvgAll(:,DAPIChannel));
    
    if exist('maxValue', 'var')
        nucAvgAllNormalized = nucAvgAllNormalized./maxValue;
        nucAvgStdError =  nucAvgStdError./maxValue;
    end
    %
    nColonies(counter) = sum(inds);
    
    for chansToPlot = ch
        plot(r1,nucAvgAllNormalized(:,chansToPlot), 'Color', colors(counter,:,:), 'LineWidth', 4);
%         errorbar(r1,nucAvgAllNormalized(:,chansToPlot), nucAvgStdError(:,chansToPlot), ...
%             'Color', colors(counter,:,:), 'LineWidth', 1);
        counter = counter+1;
    end
end
legend(strcat('Condition', strsplit(int2str(conditionId), ' ')));
%%
xlabel('Distance from edge (\mum)'); ylabel('Sox2 (a.u.)');
xlim([0 410]); ylim([0 1.1]);
ax = gca; ax.FontSize = 24; ax.FontWeight = 'bold';
