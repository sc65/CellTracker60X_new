function image1 = convertOneImage_RGBimage(rawImage1, color)
%% converts a grayscale image (rawImage1: matrix) into an rgb image of given color (color: string) 

y1 = size(rawImage1,1);
x1 = size(rawImage1,2);
zeroImage = uint16(zeros(y1, x1));

switch lower(color)
    case 'cyan'
        image1 = cat(3, zeroImage,  rawImage1, rawImage1);
        
    case 'gray'
        image1 = rawImage1;
        
    case 'green'
        image1 = cat(3,  zeroImage, rawImage1, zeroImage);

    case 'magenta'
        image1 = cat(3,  rawImage1, zeroImage, rawImage1);
        
    case 'red'
        image1 = cat(3,  rawImage1, zeroImage, zeroImage);
        
    case 'yellow'
        image1 = cat(3, rawImage1, rawImage1, zeroImage);       
end

end
