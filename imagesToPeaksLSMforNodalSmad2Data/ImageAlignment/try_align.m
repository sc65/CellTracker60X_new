% read the image grid in a cell array
img{1,1} = imread('Image0070_01.tif');
img{1,2} = imread('Image0071_01.tif');
img{2,1} = imread('Image0082_01.tif');
img{2,2} = imread('Image0083_01.tif');
%%  align within each row
[fi1, rs(1), cs(1)] = alignTwoImagesFourier(img{1,1},img{1,2},4,200);
[fi2, rs(3), cs(3)] = alignTwoImagesFourier(img{2,1},img{2,2},4,200);
%% pad fi1 so they are the same number of columns
fi1 = [fi1, zeros(1040,1)];
%% align again
fi = alignTwoImagesFourier(fi1,fi2,1,200);
%%
% Check if the above algorithm works for colony 8
colonyNum = 8;
imageNumbers = plate1.colonies(colonyNum).imagenumbers;

row1 = [8,9,10];
row2 = [18 19 20];
%%
colonynum = 8;
outputfile = 'output_1.mat';
colonyImage = assembleColonyLSM(outputfile, 8);
%%
im1 = cat(3, zeros(size(colonyImage(:,:,1))), imadjust(colonyImage(:,:,3)), imadjust(colonyImage(:,:,1)));
im2 = cat(3, imadjust(colonyImage(:,:,2)), zeros(size(colonyImage(:,:,1))),  imadjust(colonyImage(:,:,1)));
im3 = cat(3, imadjust(colonyImage(:,:,2)),  imadjust(colonyImage(:,:,3)), imadjust(colonyImage(:,:,1)));

figure; imshow(im1,[]);
figure; imshow(im2,[]);
figure; imshow(im3,[]);
%%
imwrite(uint16(colonyImage), 'colony8.tif');
