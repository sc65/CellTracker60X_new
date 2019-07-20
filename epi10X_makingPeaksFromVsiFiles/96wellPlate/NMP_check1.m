
%% I) Is the fraction of T+,Sox2+ cells higher on early inhibition of BMP signaling?

% 1) Positive expression:- Mean+/- 2std : across all good colonies in that
% treatment condition. Save the histograms to check if there are
% differences across conditions.
% 2) Extract T+ pixels -> n1
% 3) extract T+ and Sox2+ pixels -> n2 (n2<n1)
% 4) Does n2/n1 change?


%% --------- sample1: 10h LDN treatment.

load('output.mat');

% 1)

brachyuryValues = cell(1,numel(colonyIds_good));
sox2Values = brachyuryValues;

counter = 1;
for ii = colonyIds_good
    nuclearMask = masks{ii} & colonyMasks{ii};
    
    for jj = 1:3
        images(:,:,jj) = imread([rawImages1(ii).folder filesep rawImages1(ii).name],jj);
        images(:,:,jj) = SmoothAndBackgroundSubtractOneImage(images(:,:,jj));
        images(:,:,jj) = bsxfun(@times, images(:,:,jj), cast(nuclearMask,class(images(:,:,jj))));
    end
    
    brachyuryImage = double(images(:,:,2))./double(images(:,:,1));
    sox2Image = double(images(:,:,3))./double(images(:,:,1));
    
    brachyuryImage(isnan(brachyuryImage)) = 0; % remove nan
    sox2Image(isnan(sox2Image)) = 0;
    
    brachyuryValues{counter} = brachyuryImage(:);
    sox2Values{counter} = sox2Image(:);
    counter = counter+1;
end
%%
brachyuryValues_all = double(cat(1, brachyuryValues{:}));
sox2Values_all = double(cat(1, sox2Values{:}));
%%

figure; subplot(1,2,1);  histogram(brachyuryValues_all, 'BinWidth', 0.05); title('T');
subplot(1,2,2);  histogram(sox2Values_all,  'BinWidth', 0.05); title('Sox2');
%%

brachyury_positive_high = mean(brachyuryValues_all) + 2* std(brachyuryValues_all);
brachyury_positive_low = mean(brachyuryValues_all);

sox2_positive_high = mean(sox2Values_all) + 2* std(sox2Values_all);
sox2_positive_low = mean(sox2Values_all);
%%

% 2) 

brachyuryPositive = zeros(1,numel(colonyIds_good));
brachyurySox2Positive = brachyuryPositive;
brachyurySox2Positive_fraction = brachyuryPositive;


counter = 1;
for ii = colonyIds_good
    nuclearMask = masks{ii} & colonyMasks{ii};
    
    for jj = 1:3
        images(:,:,jj) = imread([rawImages1(ii).folder filesep rawImages1(ii).name],jj);
        images(:,:,jj) = SmoothAndBackgroundSubtractOneImage(images(:,:,jj));
        images(:,:,jj) = bsxfun(@times, images(:,:,jj), cast(nuclearMask,class(images(:,:,jj))));
    end
    
    brachyuryImage = double(images(:,:,2))./double(images(:,:,1));
    sox2Image = double(images(:,:,3))./double(images(:,:,1));
    
    brachyuryImage(isnan(brachyuryImage)) = 0; % remove nan
    sox2Image(isnan(sox2Image)) = 0;
    
    bra_positive = brachyuryImage > brachyury_positive_low & brachyuryImage <= brachyury_positive_high;
    sox2_positive = sox2Image > brachyury_positive_low & sox2Image <= sox2_positive_high;
    bra_sox2_positive =  bra_positive & sox2_positive;
    
    brachyuryPositive(counter) = numel(find(bra_positive)); % n1
    brachyurySox2Positive(counter) = numel(find(bra_sox2_positive)); %n2
    
   brachyurySox2Positive_fraction(counter) =     brachyurySox2Positive(counter)./ brachyuryPositive(counter);
   counter = counter+1;
     
end

























