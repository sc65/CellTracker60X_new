%read the raw images and masks.
sample = 'No Treatment';

img1 = imread('Notreatment_C0003.tif'); %DAPI channel  - used for segmentation
img2= imread('Notreatment_C0001.tif'); %SMAD2 channel. 

mask1  = readIlastikFile('/Notreatmentmask1.h5'); %nuclear mask.
mask2 = readIlastikFile('/Notreatmentmask2.h5'); %colony mask.

%%
%preprocess ilastik mask. 
mask1 = imfill(mask1,'holes');
mask1 = bwareaopen(mask1,100);

size = 3;
outside = ~imdilate(mask1,strel('disk',size)); %get region outside nuclei.

hx = fspecial('sobel'); %get the edges in the raw image. 
hy = hx';
Iy = imfilter(double(img1), hy, 'replicate');
Ix = imfilter(double(img1), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

basin = imimposemin(gradmag, mask1 | outside); %clean up the edges so that edges reference to only the actual edges of cells. 

L = watershed(basin); %apply watershed to separate the regions surrounded by the edges found above. 

newmask = L > 1; % get all the regions belonnging to cells. 

figure; imshow(cat(3,newmask,im2double(imadjust(img1)),outside)); %check if you have a decent nuclei mask. 

%%
% get stats for the nuclear mask 
stats = regionprops(newmask,img1,'Area','MeanIntensity','Centroid'); %Dapi
intensity1 = regionprops(newmask, img2, 'MeanIntensity', 'Centroid'); %SMAD2 nuclear intensity.
%% 
% make the cytoplasmic masks.
% start with voronoi of cells. 
stats = addVoronoiPolygon2Stats(stats,[2048 2048]);

cyto_mask = zeros(2048);
for ii = 1:length(stats)
cyto_mask(stats(ii).VPixelIdxList) = ii;
end

% correct the voronoi of edge cells with the help of mask 2
cyto_mask(~mask2 | newmask) = 0; 

figure; imshow(cyto_mask,[]); colormap('jet'); caxis([1 800]); %check if the cyto mask loooks decent.

newvpixels = regionprops(cyto_mask, 'PixelIdxList');

intensity2 = regionprops(cyto_mask, img2, 'MeanIntensity'); %SAMD2 cytoplasmic intensity.

%%
% make peaks
peaks = zeros(numel(stats), 7);

peaks(:,1:2) = cat(1,stats.Centroid);
peaks(:,3) = [stats.Area]';
peaks(:,4) = -1;

peaks(:,5) = [stats.MeanIntensity]';
peaks(:,6) = [intensity1.MeanIntensity]';
peaks(:,7) = [intensity2.MeanIntensity]';

%%
% scatter plots - smad2 nuc/cyto levels.
figure;
smad2_nuc_to_cyto = peaks(:,6)./peaks(:,7) ;

scatter(peaks(:,1), -peaks(:,2), 50, smad2_nuc_to_cyto, 'filled');
colorbar; 
caxis([0.8 2.0]);

set(gca, 'xTick', []);
set(gca, 'xticklabel', []);

set(gca, 'yTick', []);
set(gca, 'yticklabel', []);

title(sample);

set(gca, 'FontSize', 14, 'FontWeight', 'bold');







