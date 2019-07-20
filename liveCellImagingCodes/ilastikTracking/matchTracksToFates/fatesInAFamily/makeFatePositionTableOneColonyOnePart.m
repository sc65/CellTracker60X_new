function [sisterFatePositionTable, neighbourFatePositionTable] = makeFatePositionTableOneColonyOnePart(outputFilesPath, colonyId, partId, ltCheck)
%% ---------------- Inputs ----------------
% ltCheck :- lineage-divisionTime Matrix, output from function makeLineageDivisionTimeMatrix
%% ---------------- Output ----------------
% fatePositionTable :- Each row represents a sister cell combination.
% Columns  - [t/Venus cdx2/Venus divisionTime(hr post treatment)
% distanceB/Wsisters] - t/Venus, cdx2/Venus represent difference in sister
% cells fate levels.
%%
outputFile = [outputFilesPath filesep 'outputColony'...
    int2str(colonyId) '_' int2str(partId) '.mat'];
load(outputFile, 'matchedCellsfateData', 'allCellStats', 'goodCells', 'umToPixel');

matchedCellsfateData(matchedCellsfateData(:,6)==0,:) = [];
nCells = size(ltCheck,1);
sisterFatePositionTable = zeros(nCells, 5);
neighbourFatePositionTable = zeros(nCells, 5);
counter = 1;
% get the sister cells
for kk = 1:nCells
    toCheck = ltCheck(kk,2:end); %exclude the track Ids.
    sister = find(all(abs(bsxfun(@minus, ltCheck(:,2:end), toCheck))<(10^-10),2)); % same start-end time points.
    sister = sister(~ismember(sister, kk));
    %%
    % difference in fate levels
    % time of formation
    % distance at end
    %%
    selfId = ltCheck(kk,1);
    selfFateData = matchedCellsfateData(matchedCellsfateData(:,1) == selfId,:);
    fate11 = selfFateData(:,4)/selfFateData(:,3); % T/Venus
    fate12 = selfFateData(:,5)/selfFateData(:,3); % cdx2/Venus
    
    sisterId = ltCheck(sister,1);
    if ~isempty(sisterId)
        sisterFateData = matchedCellsfateData(matchedCellsfateData(:,1) == sisterId,:);
        fate21 = sisterFateData(:,4)/sisterFateData(:,3); % T/Venus
        fate22 = sisterFateData(:,5)/sisterFateData(:,3); % cdx2/Venus
        
        f1 = abs(fate21-fate11);
        f2 = abs(fate22-fate12);
        %%
        t0 = 20 + ltCheck(kk,3)*10/60; %in hrs post treatment.
        
        xy1 = allCellStats{selfId}(end, 1:2);
        xy2 = allCellStats{sisterId}(end, 1:2);
        
        d0 = sqrt((xy1(1)-xy2(1))^2 + (xy1(2) - xy2(2))^2);
        d0 = d0/umToPixel;
        
        sisterFatePositionTable(counter,:) = [f1 f2 t0 d0 selfId];
        neighbourFatePositionTable(counter,:) = getClosestNeighbourInfoForFatePositionData(allCellStats, matchedCellsfateData, ltCheck, selfId, sisterId, fate11, fate12, umToPixel); 
        counter = counter+1;
    end
end
sisterFatePositionTable = sisterFatePositionTable(1:counter-1, :);
% [~, uniqueRows] = unique(sisterFatePositionTable(:,[1:4]), 'rows');
% sisterFatePositionTable = sisterFatePositionTable(uniqueRows,:);

neighbourFatePositionTable = neighbourFatePositionTable(1:counter-1,:);

end
