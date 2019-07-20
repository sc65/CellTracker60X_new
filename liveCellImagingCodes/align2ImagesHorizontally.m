function [aligned_image, overlap] = align2ImagesHorizontally(image1, image2, overlap)
%% a function to align two images

channels = 1:3; %[1 2 3] [gfp rfp brightfield] Use RFP channel.

if nargin==2
    for ch = 2%Use max z projection in channel2 to find overlap.
        
        img1 = image1(:,:,2);
        img2 = image2(:,:,2);
        
        cross_correlation = zeros(1,500);
        for ii = 1:500
            pixels1 = img1(:,(end-ii):end);
            pixels2 = img2(:,1:(1+ii));
            
            cross_correlation(ii) = mean2((pixels1-mean2(pixels1)).*(pixels2-mean2(pixels2)));
        end
        
        %subplot(1,3,ch);
        %plot(cross_correlation);
    end
    %%
    [~, overlap] = max(cross_correlation(1:250)); %find the overlap in the range 90:120.
    
end
aligned_image = uint16(zeros(size(image1,1), size(image1,2)+size(image2,2), 3));

for ch = channels
    img1 = image1(:,:,ch);
    img2 = image2(:,:,ch);
    
    aligned_image(:,1:2048,ch) = img1;
    aligned_image(:,2048-overlap+1:2048+1024-overlap, ch) = img2;
    
end





