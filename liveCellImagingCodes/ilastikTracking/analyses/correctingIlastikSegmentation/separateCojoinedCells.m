%% separate the cells - classified as merged cells by ilastik tracking software.
% for now, just pick cell ids you want to apply watershed on.
image11 = image1;
%%image11 = imresize(image11, [2048, 2048]);

figure;
imshow(image11);

stats = regionprops(image11, 'Centroid');
xy = cat(1, stats.Centroid);

hold on;
plot(xy(:,1), xy(:,2), 'r*');

for ii = 1:size(xy,1)
    text(xy(ii,1), xy(ii,2), int2str(ii), 'Color', [0 0.5 0], 'FontSize', 14, 'FontWeight', 'bold');
end
%%
cellIds = [6]; %input to watershed

image12 = bwlabel(image11);
image4 = ismember(image12, cellIds);

figure; imshow(image4);

image11 = image11-image4;
figure; imshow(image11);
%%
i1 = imfill(image4, 'holes');
%%

image5 = bwdist(~i1);
figure; imshow(image5,[]);
image6 = -(image5);

L = watershed(image6);
i1(L==0) = 0;

figure; imshow(i1);
%%
image11 = image11+i1;
figure; imshow(image11);
%%




