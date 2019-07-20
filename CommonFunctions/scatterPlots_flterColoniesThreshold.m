
%% filter good colonies

% ------- scatter plot 
shapeId = 6;
coloniesInShape = find([plate1.colonies.shape] == shapeId);
ch = [6 8 10]; axisLimits = [100 200 200];
counter1 = 1;

for ii = coloniesInShape
    plate1 = removeCellsNotInColony(plate1, ii);
end
%%
fateValues  = cell(numel(channels),length(coloniesInShape));

for jj = ch
    counter2 = 1;
    
    figure; hold on;
    for ii = coloniesInShape
        data = plate1.colonies(ii).data;
        xy = data(:,1:2);
        xy = bsxfun(@minus, xy, mean(xy));
        fate1 = data(:,jj);
        fateValues{counter1, counter2} = fate1;
        
        subplot(4,5,counter2);
        scatter(xy(:,1), xy(:,2), 10, fate1, 'filled'); title(['Colony' int2str(ii)]); caxis([0 axisLimits(counter1)]);
        counter2 = counter2+1;
    end
    counter1 = counter1+1;
end
%%
% ------- intensity histograms
for ii = 1:3
    f1{ii} = cat(1, fateValues{ii,:});
    figure; histogram(f1{ii});
end
%% 
% ------ find threshold for cutoff. 

tooHigh = [150 500 1000];
%% 
% --------- remove cells with intensities above threshold, run scatter plot
% again. 
for ii = coloniesInShape
    data = plate1.colonies(ii).data;
    fate1 = data(:,[ch]);

    toRemove = fate1(:,1)>tooHigh(1)|fate1(:,2)>tooHigh(2)|fate1(:,3)>tooHigh(3);
    data(toRemove,:) = [];
    plate2.colonies(ii).data = data;
    
end
%%
outputFile = '/Volumes/sapnaDrive2/180628_shapesChip1/output.mat';
save(outputFile, 'plate1', '-append');
%%

saveInPath = '/Volumes/sapnaDrive2/180628_shapesChip1/scatterPlots';
saveAllOpenFigures(saveInPath);


