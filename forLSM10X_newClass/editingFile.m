
%%
close all;
for ii = 5
    image1 = imread(['colony' int2str(ii) '_ch2.tif']);
    image2 = imadjust(image1);
    mask1 = imread(['colony' int2str(ii) '_colonyMask.tif']);
    %figure; imshowpair(image2, mask1);
    mask2 = imdilate(mask1, strel('disk', 2));
    figure; imshowpair(image2, mask2);
    %imwrite(mask2, ['colony' int2str(ii) '_colonyMask.tif']);
end
%%
mask2(1117:1119,:) = 0;
%%
figure; hold on;
for ii = 1:3
    outputFile = [samples(ii).name filesep 'output.mat'];
    load(outputFile);
    for jj = 1:5
    rA1(jj,:) = colonies(jj).radialProfile.notNormalized.mean(2,:);
    end
   
    rA_mean = mean(rA1,1);
    
     if ii == 1
        rA_max = max(rA_mean);
     end
     
    rA_mean = rA_mean/rA_max;
    rA_std = std(rA1,[],1)./rA_max;
    
    rA_stdError = rA_std./sqrt(5);
    errorbar(xValues, rA_mean, rA_stdError);
end
%%
