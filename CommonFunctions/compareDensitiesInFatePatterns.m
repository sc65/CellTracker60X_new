
%% are densities the same?

segmentedPixels = cell(1,3);
for ii = 1:3
    values = fatePattern(ii).density(:); 
    values = values(values>0);
    segmentedPixels{ii} = values;    
end
%%

toCompare = cell2mat({[1 2]; [1 3]; [2 3]});
legendLabels = {'Circle', 'Triangle', 'Pacman'};

for ii = 1:size(toCompare,1)
    figure; hold on;
    histogram(segmentedPixels{toCompare(ii,1)});
    histogram(segmentedPixels{toCompare(ii,2)});
    legend(legendLabels(toCompare(ii,:))); 
    xlabel('segmented pixel densities (a.u.)');
    ylabel('No. of pixels');
    ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
        
    [h, p] = kstest2(segmentedPixels{toCompare(ii,1)}, segmentedPixels{toCompare(ii,2)})

end
%%
saveInPath = '/Volumes/sapnaDrive2/180628_shapesChip1/segmentedPixels_density';
saveAllOpenFigures(saveInPath);
