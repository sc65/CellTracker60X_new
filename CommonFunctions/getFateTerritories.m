%%
binsize = 100;

densitylimit = 10;
chlabel = [{'Cdx2'}, {'Bra'}, {'Sox2'}];
channel = [8 6 7];
plotnum = 1;

shapenum = [16];


coloniesno = find([plate1.colonies.shape] == shapenum);
%coloniesno([2:5]) = [];

intensity_norm = 0;
avgOut = computeShapeAverages(plate1.colonies, shapenum, intensity_norm, binsize, channel);

%%
% Defining brachyury territories

%threshold = 0.4; % brachyury expression threshold

%%
fullColony = avgOut.density;
fullColony(fullColony>1) = 100;
%fullColony(any(isnan(fullColony), 2),:)=0;
%fullColony(:,any(isnan(fullColony),1)) = 0;

figure; imagesc(fullColony);


brachyuryValues = avgOut.markerAvgs(:,:,2);
brachyuryValues = brachyuryValues./normValues(2); % normalising w.r.t. circles

brachyuryRing = brachyuryValues;

threshold1 =2.0; % 0.4
brachyuryRing(brachyuryRing>=threshold1) = 50;

figure; imagesc(brachyuryRing);
ring = brachyuryRing==50;
fullColony(ring)= 200;

figure; imagesc(fullColony);
%%
f1 = triangle;
territoriesb = f1 == 200;
bbin = im2bw(territoriesb);
        bbin = bwareaopen(bbin, 100);
        %figure; imshow(bbin);
        
        [~, labels] = bwboundaries(bbin);
     %%   
        
        territoriesbc(labels ==2) = 25;
    %%
    square = f1;
    figure; imagesc(square);
    %%
    
    save('fateRegions.mat', 'square');

        



