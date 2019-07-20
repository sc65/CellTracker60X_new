function [aligned_image, overlap] = verticalAlignmentImages(img1, img2, overlap)
% aligning images vertically.

channels = [1 2 3]; %[1 2 3] [gfp rfp brightfield]

if nargin == 2
    for ch = 2
        ch_img1 = img1(:,:,ch);
        ch_img2 = img2(:,:,ch);
        
        %check cross correlations
        cross_correlation = zeros(1,500);
        for ii = 1:500
            pixels1 = ch_img1((end-ii):end, :);
            pixels2 = ch_img2(1:(1+ii), :);
            
            cross_correlation(ii) = mean2((pixels1-mean2(pixels1)).*(pixels2-mean2(pixels2)));
        end
        
    end
    [~, overlap] = max(cross_correlation(90:120)); %find the overlap in the range 90:120. 
    overlap = overlap + 90 -1;
end
aligned_image = uint16(zeros(size(img1,1)+size(img2,1), size(img1,2), 3));

for ch = channels
    ch_img1 = img1(:,:,ch);
    ch_img2 = img2(:,:,ch);
    
    aligned_image(1:1024,:,ch) = ch_img1;
    aligned_image(1024:1024+1024-overlap,:, ch) = ch_img2(overlap:end,:);
    
end


end

