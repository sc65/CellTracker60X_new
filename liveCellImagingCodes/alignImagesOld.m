function img4 = horizontalAlignmentImages(img1_position, img2_position)

channels = 2; %[1 2 3] [gfp rfp brightfield] Use RFP channel.
timepoint = 1;


%reading images and making max Z projections.
img1path = [sprintf('Track%03d/Image%03d', img1_position), sprintf('_%02d.oif', timepoint)];
img1reader = bfGetReader(img1path);

img2path = ['Track%/Image0002' sprintf('_%02d.oif', timepoint)];
img2reader = bfGetReader(img2path);
%%
figure;
counter = 1;

for ch = channels
    
    img1 = MakeMaxZmovies(img1reader, ch, timepoint);
    img2 = MakeMaxZmovies(img2reader, ch, timepoint);
    
    %try the regular overlap method. -> calculate pixel differences
    %check cross correlations
    
    %diffs = zeros(1,500);
    cross_correlation = zeros(1,500);
    for ii = 1:500
        pixels1 = img1(:,(end-ii):end);
        pixels2 = img2(:,1:(1+ii));
        %diffs(ii) = sum(sum(abs(pixels1-pixels2)))/ii;
        cross_correlation(ii) = mean2((pixels1-mean2(pixels1)).*(pixels2-mean2(pixels2)));
    end
    subplot(1,3, counter); plot(cross_correlation);
    counter = counter+1;
    title(['channel' int2str(ch)]);
    xlabel('Overlap');
    
    ax = gca;
    ax.FontSize = 14;
end
%%
%cross_correlation in channel 2 shows a peak at overlap of 109.
overlap = 117;
img3 = uint16(zeros(1024, 2048, 3));

for ch = channels
    img1 = MakeMaxZmovies(img1reader, ch, timepoint);
    img2 = MakeMaxZmovies(img2reader, ch, timepoint);
    
    img3(:,1:1024,ch) = img1;
    img3(:,1024:1024+1024-overlap, ch) = img2(:,overlap:end);
    
end


img3 = uint16(img3);
img4 = cat(3,  imadjust(img3(:,:,2)),imadjust(img3(:,:,1)) ,zeros(size(img3(:,:,1))));

figure; imshow(img4,[]);



