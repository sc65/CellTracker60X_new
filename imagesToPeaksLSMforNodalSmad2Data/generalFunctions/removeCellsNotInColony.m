function plate1 = removeCellsNotInColony(plate1, colonyId, outputFile)
%removing cells which do not belong to the colony.
%plate1: object plate.
%colonyId: colony numbers that you want to work upon.
%% - modified the function to work for both peaks/plates.

%%
alpha_radius = 50; %for making alphashape. The distance should enable required separation
for ii = colonyId
    if iscell(plate1)
        allData = plate1{ii};
    else
        allData = plate1.colonies(ii).data;
    end
    
    xy = allData(:,1:2);
    figure;
    plot(xy(:,1), xy(:,2), 'k*'); %all the points in original colony.
    
    ashape = alphaShape(xy(:,1), xy(:,2), alpha_radius);
    points_in_shape =  xy(inShape(ashape,xy(:,1), xy(:,2), 1),:); %actual points in the colony.
    
    hold on;
    plot(points_in_shape(:,1), points_in_shape(:,2), 'r*');
    
    allData(~ismember(allData(:,1), points_in_shape(:,1)), :) = [];
    allData(~ismember(allData(:,2), points_in_shape(:,2)), :) = [];
    
    plot(allData(:,1), allData(:,2), 'b*');
    title(['Colony' int2str(ii)]);
    
    if iscell(plate1)
        plate1{ii} = allData;
    else
        plate1.colonies(ii).data = allData;
    end
end

if exist('outputFile', 'var')
    save(outputFile, 'plate1', '-append');
end
end