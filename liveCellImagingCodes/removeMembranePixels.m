
function idx = removeMembranePixels(idx, membraneMask)
%remove indices that belong to the membrane. 

truePixels  = find(idx);
stats = regionprops(membraneMask, 'PixelIdxList');
membranePixels = cat(1, stats.PixelIdxList);

[~, common] = intersect(truePixels, membranePixels); 
idx(truePixels(common)) =  0;

end