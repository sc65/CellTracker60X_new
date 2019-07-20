%%

figure;
imshow(colonyImage,[]);
hold on;
plot(colonyCenter1(1), colonyCenter1(2), 'b*');
%imshow(image11);

stats = regionprops(image11, 'Centroid');
xy = cat(1, stats.Centroid);

plot(xy(:,1), xy(:,2), 'r*');

for ii = 1:size(xy,1)
    text(xy(ii,1), xy(ii,2), int2str(theta(ii)), 'Color', 'g' , 'FontSize', 12, 'FontWeight', 'bold');
end
%%
theta = atan2d(-xy(:,2) - -colonyCenter1(2), xy(:,1)-colonyCenter1(1));
%%
figure;
imshow(colonyMask);
hold on;

plot(colonyCenter2(1), colonyCenter2(2), 'b*');
stats = regionprops(image2, 'Centroid');
xy = cat(1, stats.Centroid);

plot(xy(:,1), xy(:,2), 'r*');

theta2 = atan2d(-xy(:,2) - -colonyCenter2(2), xy(:,1)-colonyCenter2(1));

for ii = 1:size(xy,1)
    text(xy(ii,1), xy(ii,2), int2str(theta2(ii)), 'Color', 'g' , 'FontSize', 12, 'FontWeight', 'bold');
end

