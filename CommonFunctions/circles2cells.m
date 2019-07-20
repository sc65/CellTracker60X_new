function overlayImage2onImage1 (image1, image2)
%% example: to overlay fluorescent channel image (image2) on dapi (image1).


matCatREF = cat(3,image1+image2,image1+image2,image1);
%%
figure; imshow(matCatREF);
%%

dapiBalance = 0.5;
otherImgBalance = 1-dapiBalance;
imgDAPIref = im2double(squeeze(image1));
limsDAPIMAX = stretchlim(imgDAPIref);
imgDAPIref = dapiBalance*imadjust(imgDAPIref,limsDAPIMAX);

imgLblREF = im2double(squeeze(image2));
limsLblREF = stretchlim(imgLblREF);
imgLblREF = otherImgBalance*imadjust(imgLblREF,limsLblREF);
matCatREF = cat(3,imgDAPIref+imgLblREF,imgDAPIref+imgLblREF,imgDAPIref);
%%
figure; imshow(matCatREF);