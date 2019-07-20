function kidsId = findCellIdsOfKids(allColoniesCellStats,parentCellId)
%% returns cell Ids corresponding to all posssible kids of the cell with Id the same as parentCellId.

lineageIds = cellfun(@(x)(x(1,4)), allColoniesCellStats); % all Lineage Ids.
colonyIds = cellfun(@(x)(x(1,3)), allColoniesCellStats);

parentLineageId = lineageIds(parentCellId);
possibleKids = find(lineageIds ==  parentLineageId);
possibleKids(ismember(possibleKids, parentCellId)) = []; % remove the parent cell Id.

parentColonyId = colonyIds(parentCellId);
kidsColonyIds = colonyIds(possibleKids);

if size(allColoniesCellStats{1},2) == 9
    colonyPartIds = cellfun(@(x)(x(1,9)), allColoniesCellStats);
    parentColonyPartId = colonyPartIds(parentCellId);
    kidsColonyPartIds = colonyPartIds(possibleKids);
    
    trueKids = kidsColonyIds == parentColonyId & kidsColonyPartIds == parentColonyPartId;
    
else
    trueKids = kidsColonyIds == parentColonyId;
end

kidsId = possibleKids(trueKids);


end