%%

% Debugging error in primary filter.
for z= 1:size(pnuc,3)
    im = pnuc(:,:,z);
    logim2(:,:,z) = imfilter(im, h);
    
end


t = graythresh(logim2);
se = strel('disk',diskfilter);

   for z = 1:size(pnuc,3)
        
    logimsl = adapthisteq(logim2(:,:,z));
    
    figure; imshow(logimsl,[]);
    
    im1 = logimsl>bthreshfilter*t;
    
    figure; imshow(im1);
    
    im2 = imfill(im1, 'holes');
    figure; imshow(im2);
    
    im3 = imerode(im2, se);
    figure; imshow(im3);
    
    tmp = bwareaopen(im3,areafilter);
    figure; imshow(tmp);
    
    pmasks(:,:,z) = tmp;
    
    
   end