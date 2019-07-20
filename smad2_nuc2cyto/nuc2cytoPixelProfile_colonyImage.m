function colony_nuc2cyto = nuc2cytoPixelProfile_colonyImage(colony_smad2, nuclearMask, cytoplasmicMask, filterSize)
%% computes the ratio of average nuclear to cytoplasmic pixels in a sliding neighbourhood of the raw image.

%% smad2 image - nuclear and cytoplasmic casts.
colony_nuc = bsxfun(@times, colony_smad2, cast(nuclearMask,class(colony_smad2)));
colony_cyto = bsxfun(@times, colony_smad2, cast(cytoplasmicMask,class(colony_smad2)));

%% applying filter to the images and masks
filter1 = ones(filterSize);
colony_nuc_nSum = imfilter(double(colony_nuc), filter1);
nuc_pixels = imfilter(double(nuclearMask), filter1);
colony_nuc_avg = double(colony_nuc_nSum)./double(nuc_pixels);
%figure; imshow(colony_nuc_avg,[]);

colony_cyto_nSum = imfilter(double(colony_cyto), filter1);
cyto_pixels = imfilter(double(cytoplasmicMask), filter1);
colony_cyto_avg = double(colony_cyto_nSum)./double(cyto_pixels);
%figure; imshow(colony_cyto_avg,[]);

%% average nuclear to cytoplasmic pixel ratio
colony_nuc2cyto = colony_nuc_avg./colony_cyto_avg;
colony_nuc2cyto(isinf(colony_nuc2cyto)) = 0;
colony_nuc2cyto(isnan(colony_nuc2cyto)) = 0;

end
