function classifyCircularColoniesBasedOnRadii(outputFile)
%%
% Based on colony radius, classify the circles into shapes 1-4, from the
% largest to the smallest.

% shape1 - radius = 500 um, range = 450 - 550 um
% shape2 - radius = 400 um, range = 360 - 440 um
% shape3 - radius = 250 um, range = 225 - 275 um
% shape4 - radius = 100 um, range = 90 - 110 um
% shape5 - radius = 50 um, range = 45 - 55 um

%%
load(outputFile, 'plate1', 'userParam');
coloniesToClassify = find([plate1.colonies.ncells] > 50); % classify only the colonies with at least 50 cells.

for ii = 1:length(coloniesToClassify)
    radius = plate1.colonies(ii).radius/userParam.umtopxl; %convert to um
    
    if radius<550 && radius>450
        plate1.colonies(ii).shape = 1;
        
    elseif radius<440 && radius>360
        plate1.colonies(ii).shape = 2;
        
    elseif radius<275 && radius>225
        plate1.colonies(ii).shape = 3;
    
    elseif radius<110 && radius>90
        plate1.colonies(ii).shape = 4;
        
    elseif radius<55 && radius>45
        plate1.colonies(ii).shape = 5;
    else
        plate1.colonies(ii).shape = 0;
    end
end

save(outputFile, 'plate1', '-append');

        
end    
    