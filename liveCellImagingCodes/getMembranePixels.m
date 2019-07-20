function membraneIdx = getMembranePixels(idx, membraneMask)
%from all inices, extract indices that belong only to the membrane. 

truePixels  = find(idx);
stats = regionprops(membraneMask, 'PixelIdxList');
membranePixels = cat(1, stats.PixelIdxList);

[~, common] = intersect(truePixels, membranePixels); 
membraneIdx = truePixels(common);

end