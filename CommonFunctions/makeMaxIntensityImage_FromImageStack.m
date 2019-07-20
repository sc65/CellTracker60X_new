
function image1_maxZ = makeMaxIntensityImage_FromImageStack(imagePath, imageInfo, imageNumbers)
%% given a set of images (corresponding to imagenumbers), this function returns the maximum intensity image.

image1_maxZ = zeros(imageInfo(1).Width, imageInfo(1).Height, 'uint16');

for ii = imageNumbers
    image1= imread(imagePath,'Index',ii,'Info',imageInfo);
    image1_maxZ= max(image1, image1_maxZ);
end

image1_maxZ = SmoothAndBackgroundSubtractOneImage(image1_maxZ);
end
