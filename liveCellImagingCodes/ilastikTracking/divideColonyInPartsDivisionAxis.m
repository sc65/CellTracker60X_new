%%
% divide a colony into 2 parts.
% division axis makes an angle theta with the horizontal.

%%
colonyId = 3;
colonyImage1 = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/images/Track' int2str(colonyId) 'ch1.tif']; %fluorescent
colonyImage2 = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/images/Track' int2str(colonyId) 'ch2.tif']; %brightfield
%%
newImagesPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/ImageParts';
newImages = cell(1,2);
mkdir([newImagesPath filesep 'colony' int2str(colonyId)]); % a new folder for each colony

for ii = 1:2
    newImages{ii} = [newImagesPath filesep 'colony' int2str(colonyId) filesep 'part_' int2str(ii) '.tif'];
end
%%
reader1 = bfGetReader(colonyImage1);
reader2 = bfGetReader(colonyImage2);
%%
timePoints = reader1.getSizeT;
%% overlay images for last time point
imagePlane = reader1.getIndex(1-1, 1-1, timePoints-1)+1; %[z channel t]
image1end = bfGetPlane(reader1, imagePlane);

imagePlane = reader2.getIndex(1-1, 1-1, timePoints-1)+1;
image2end = bfGetPlane(reader2, imagePlane);
%%
figure; imshowpair(image1end, image2end);
%% draw the division axis
hold on;
point1 = [82 725];
point2 = [616 389];
plot([point1(1) point2(1)], [point1(2) point2(2)], 'k-', 'LineWidth', 4);

%% find the angle it makes with the horizontal
theta = abs(atan2d(point2(2)-point1(2), point2(1) - point1(1))); %[0 180];

%% find the point of intersection of the division axis and the horizontal passing through the bottom-most point on the colony.
L1 = [point2(1) point1(1); point2(2)  point1(2)];
coefficients1 = polyfit([point1(1), point2(1)],[point1(2), point2(2)],1); 
%returns "a" and "b" in the equation y = ax+b.

%% find the point of intersection of the division axis with the tangent 
% passing through the bottom of the colony -> y = 909

referencePoint(2) = 909;
referencePoint(1) = (referencePoint(2)-coefficients1(2))/coefficients1(1);

%% for every timepoint, convert the image to binary, find the angle made by every cell
% (linesegment joining the center of the cell with point1) with the x axis -> theta1
% and classify them as either in part1 (theta1<theta) or
% part2 (theta1>theta).
threshold = 0.005;
colonyCenter = [358 569];
umToPixel = 0.82;

for ii = 1:2
    for jj = 1:timePoints
        jj
        imagePlane = reader1.getIndex(1-1, 1-1, jj-1)+1; %[z channel t]
        image1 = bfGetPlane(reader1, imagePlane);
        
        image2 = im2bw(image1, threshold);
        image2 = bwareaopen(image2, 50);
        %%
        stats = regionprops(image2, 'Centroid');
        xy = cat(1, stats.Centroid);
        
        dists = sqrt((xy(:,1)-colonyCenter(1)).^2 + (xy(:,2)-colonyCenter(2)).^2);
        theta1 = zeros(size(xy,1), 1);
        
        for kk = 1:size(xy,1)
            theta1(kk,1) = abs(atan2d(xy(kk,2)-referencePoint(2), xy(kk,1) - referencePoint(1)));
        end
        
        inds1 = find(theta1<theta); %to the right
        inds2 = find(theta1>theta); %to the left
        inds3 = find(dists < (410)*umToPixel); %in the colony
        
        toKeep1 = intersect(inds2, inds3);
        toKeep2 = intersect(inds1, inds3);
        image2 = bwlabel(image2);
        
        if ii == 1
            image2 = ismember(image2, toKeep1);
        else
            image2 = ismember(image2, toKeep2);
        end
        image1(image2 == 0) = 0;
        
        if jj == 1
            imwrite(image1, newImages{ii});
        else
            imwrite(image1, newImages{ii}, 'writemode', 'append');
        end
    end
end







