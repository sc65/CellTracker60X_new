%%
filterSize = 120;

ii = 1;
colonyPrefix = ['Colony_' int2str(ii)];
colony1_dapi = imread([colonyPrefix '_ch1.tif']);
colony1_smad2 = imread([colonyPrefix '.tif'], 4);
%figure; imshow(colony1_smad2,[]);

colony1_nuclearMask_old = readIlastikFile([colonyPrefix '_ch1_Simple Segmentation.h5']);
colony1_nuclearMask_new = readIlastikFile([colonyPrefix '_ch1_Simple Segmentation_new.h5']);
colony1_colonyMask = imread(['maskColony_' colonyPrefix '.tif']);

colony1_nuclearMask = colony1_nuclearMask_new;
colony1_nuclearMask = colony1_nuclearMask&colony1_colonyMask;
colony1_cytoplasmicMask = (~colony1_nuclearMask)&colony1_colonyMask;

colony_cyto = bsxfun(@times, colony1_smad2, cast(colony1_cytoplasmicMask,class(colony1_smad2)));
figure; imshowpair(colony1_smad2, colony_cyto);
figure; imshow(colony_cyto,[]);

colony_nuc = bsxfun(@times, colony1_smad2, cast(colony1_nuclearMask,class(colony1_smad2)));
figure; imshowpair(colony1_smad2, colony_nuc);

colony_nuc2cyto = nuc2cytoPixelProfile_colonyImage(colony1_smad2, colony1_nuclearMask, colony1_cytoplasmicMask, filterSize);
colony_ch2dapi = ch2dapiPixelProfile_colonyImage(colony1_smad2, colony1_dapi, colony1_nuclearMask, filterSize);

%figure; imshow(colony_nuc2cyto,[]);
%figure; imshow(colony_ch2dapi,[]); title(colonyPrefix);

%%

% figure; imshowpair(colony1_dapi, colony1_nuclearMask);
% figure; imshowpair(colony1_dapi, colony1_cytoplasmicMask);

colony_cyto = bsxfun(@times, colony1_smad2, cast(colony1_cytoplasmicMask,class(colony1_smad2)));
figure; imshowpair(colony1_smad2, colony_cyto);

colony_nuc = bsxfun(@times, colony1_smad2, cast(colony1_nuclearMask,class(colony1_smad2)));
figure; imshowpair(colony1_smad2, colony_nuc);
%%
filterSize = 100;
filter1 = ones(filterSize);

colony_nuc_nSum = imfilter(double(colony_nuc), filter1);
nuc_pixels = imfilter(double(colony1_nuclearMask), filter1);
colony_nuc_avg = double(colony_nuc_nSum)./double(nuc_pixels);
figure; imshow(colony_nuc_avg,[]);

filter1 = ones(filterSize);
colony_cyto_nSum = imfilter(double(colony_cyto), filter1);
cyto_pixels = imfilter(double(colony1_cytoplasmicMask), filter1);
colony_cyto_avg = double(colony_cyto_nSum)./double(cyto_pixels);
figure; imshow(colony_cyto_avg,[]);

%%
colony_nuc_cyto = colony_nuc_avg./colony_cyto_avg;
figure; imshow(colony_nuc_cyto,[]);

%%
dapi_nuc = bsxfun(@times, colony1_dapi, cast(colony1_nuclearMask,class(colony1_dapi))); % nuclear cast
dapi_nuc_nSum = imfilter(double(dapi_nuc), filter1); % neighbourhood sum
dapi_nuc_avg = double(dapi_nuc_nSum)./double(nuc_pixels);
figure; imshow(dapi_nuc_avg,[]);

colony_nuc_dapi = colony_nuc_avg./dapi_nuc_avg;
figure; imshow(colony_nuc_dapi,[]);
%%

