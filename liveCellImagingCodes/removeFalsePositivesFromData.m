function cells_in_territory = removeFalsePositivesFromData(cells_in_territory, false_positives)
%removes false positives cells (cecll_ids of those cells specified as an array) from the dataset. 

not_to_remove = ~ismember(squeeze(cells_in_territory(1,1,:)), false_positives);
cells_in_territory = cells_in_territory(:,:,not_to_remove);
end