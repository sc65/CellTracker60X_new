
function [nuclear_mask, cell_stats] = MakeNuclearMaskAndGetStats(mask, dapi_image)
%% processes nuclear mask from Ilastik and returns the new mask and some statistics for cells in the image

size = 2; %dilation radius - choose a value that ensures cell-cell separation
%while covering the original nuclei in DAPI image. 
outside = ~imdilate(mask,strel('disk',size)); %get region outside nuclei.

hx = fspecial('sobel'); %get the edges in the raw image. 
hy = hx';
Iy = imfilter(double(dapi_image), hy, 'replicate');
Ix = imfilter(double(dapi_image), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

basin = imimposemin(gradmag, mask | outside); %clean up the edges so that edges reference to only the actual edges of cells. 
L = watershed(basin); %apply watershed to separate the regions surrounded by the edges found above. 
nuclear_mask = L > 1; % get all the regions belonnging to cells. 

%figure; imshow(cat(3,newmask,im2double(imadjust(img1)),outside)); %check if you have a decent nuclei mask. 
cell_stats = regionprops(nuclear_mask,'Area','Centroid'); % get stats for the nuclear mask 
end