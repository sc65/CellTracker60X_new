%% track4 -
% 1) remove cells not in the colony
% 2) divide the colony into 2 parts - track each separately.
%%
colonyId = 10;
colonyCenter = [424 501];
colonyRadius = 700; % in microns
divisionDirection = 2; % orientation of division axis.
% 1 - horizontal axis divides the colony, 2 - vertical axis divides the colony.
% 3 - a combination, a pie represents part1, and the remaining represents part2 of colony.

divisionPoint = [426];
%%
newImagesPath = '/Volumes/SAPNA/170325LivecellImagingSession1_8_5/ImageParts';
newImages = cell(1,2);
mkdir([newImagesPath filesep 'colony' int2str(colonyId)]); % a new folder for each colony

for ii = 1:2
    newImages{ii} = [newImagesPath filesep 'colony' int2str(colonyId) filesep 'part_' int2str(ii) '.tif'];
end

rawImage = ['/Volumes/SAPNA/170325LivecellImagingSession1_8_5/images/Track' int2str(colonyId) 'ch1.tif'];
umToPixel = 0.82;

reader = bfGetReader(rawImage);
timePoints = reader.getSizeT;
%%
threshold = 0.004; % a threshold for binary conversion - input to function im2bw.
 % try multiple. If the cells are dim, decrease the threshold value to capture
 % them.
%%
for ii = 1:2
    for jj = 1:timePoints
        jj
        imagePlane = reader.getIndex(1-1, 1-1, jj-1)+1; %[z channel t]
        image1 = bfGetPlane(reader, imagePlane);
        
        image2 = im2bw(image1, threshold);
        image2 = bwareaopen(image2,60);
        %%
        stats = regionprops(image2, 'Centroid');
        xy = cat(1, stats.Centroid);
        
        dists = sqrt((xy(:,1)-colonyCenter(1)).^2 + (xy(:,2)-colonyCenter(2)).^2);
        
        if divisionDirection == 1
            inds1 = find(xy(:,2) > divisionPoint); %bottom points -below colonyCenter
            inds2 = find(xy(:,2) < divisionPoint); %top points
        elseif divisionDirection == 2
            inds1 = find(xy(:,1) > divisionPoint); %to the right of colonyCenter.
            inds2 = find(xy(:,1) < divisionPoint);
        elseif divisionDirection == 3
            inds1 = find(xy(:,2) < divisionPoint(2) & xy(:,1) < divisionPoint(1)); 
            inds2 = setxor(1:size(xy,1), inds1);
        end
        
        inds3 = find(dists < colonyRadius*umToPixel); %in the colony
        
        toKeep1 = intersect(inds2, inds3);
        toKeep2 = intersect(inds1, inds3);
        image2 = bwlabel(image2);
        
        if ii == 1
            image2 = ismember(image2, toKeep1);
        else
            image2 = ismember(image2, toKeep2);
        end
        image1(image2 == 0) = 0;
        %figure; imshow(image1,[]);
        
        
        if jj == 1
            imwrite(image1, newImages{ii});
        else
            imwrite(image1, newImages{ii}, 'writemode', 'append');
        end
    end
end
