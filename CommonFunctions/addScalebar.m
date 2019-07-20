function image1 = addScalebar(image1, pixel_um, pixel_bits, scalebar_length)
%% adds scale bar of length scalebar_length (100um by default) on image1.
%--- pixel_um: conversion factor (pixel -> um)
%--- pixel_bit: no. of bits per pixel (8,12 or 16)

%% ------------------------------------------
if ~exist('scalebar_length', 'var')
    scalebar_length = 100; % in microns
end

if ~exist('pixel_bits', 'var')
    pixel_bits = 16; % assume a 16 bit image by default. 
end

scalebar_length = (scalebar_length)/pixel_um;

x1 = size(image1,2) - 1.2*scalebar_length;
y1 = size(image1,1) - 0.5*scalebar_length;

x2 = x1+scalebar_length;
y2 = y1+10; % width of scaleBar (10 pixels)

%figure; imshow(image1,[displayIntensity(1), displayIntensity(2)]);
%%
[X,Y] = meshgrid(floor(x1:x2), floor(y1:y2)); % pixel indices corresponding to scalebar
linearIdx = sub2ind(size(image1), Y(:), X(:));

if pixel_bits == 8
    imageWithScalebar = uint8(zeros(size(image1,1), size(image1,2)));
    imageWithScalebar([linearIdx]) = 2^pixel_bits-1;
else
    imageWithScalebar = uint16(zeros(size(image1,1), size(image1,2)));
    imageWithScalebar([linearIdx]) = 2^16-1;
end


imageWithScalebar = imdilate(imageWithScalebar, strel('disk', 3));

if isfloat(image1)
    imageWithScalebar = double(imageWithScalebar);
elseif islogical(image1)
    imageWithScalebar = logical(imageWithScalebar);
end

if size(image1,3) == 3
    image1 = image1+ cat(3,imageWithScalebar, imageWithScalebar, imageWithScalebar);
elseif size(image1,3) == 1
    image1 = image1+ imageWithScalebar;
else
    disp('Error!!! check image format');
end


%figure; imshow(image1);

end