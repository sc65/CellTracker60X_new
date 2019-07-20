
%%

% filter good colonies
% 1) dapi image
% 2) t, cdx2, sox2 plots

%
masterFolder = '/Volumes/SAPNA/190107_96wellPlate/tiffFiles';
conditionIds = [1:80]; colSize = 350;
%%
conditionId = conditionIds(33);
close all;
%%

outputFile = [masterFolder filesep 'Condition' int2str(conditionId) filesep 'colonies.mat'];
load(outputFile);

inds = [colonies.radiusMicron] == colSize;
colonies1 = colonies(inds);

%% -----------------------------------------------
% 1)
idx = 1:4:sum(inds);
for ii = 1:numel(idx)
    figure; hold on; count = 1;
    
    if ii<numel(idx)
        idx2 = idx(ii):idx(ii+1)-1;
    else
        idx2 = idx(ii):sum(inds);
        
    end
    for jj = idx2
        filepath = [masterFolder filesep 'Condition' int2str(conditionId) ...
            filesep 'colonies' filesep colonies1(jj).filename];
        dapiImage = imadjust(imread(filepath, 1));
        subplot(2,2,count);
        imshow(dapiImage,[]);
        title(['Colony' int2str(colonies1(jj).ID)]);
        count = count+1;
    end
end
%%
badColoniesId = [1 16];

%% ------------------------------------------------
% 2)
ch = 3; % channel used for filter
r = imfilter(colonies1(1).radialProfile.BinEdges,[1 1]/2)*meta.xres;
r(1) = colonies1(1).radialProfile.BinEdges(1)*meta.xres;
r = r(1:end-1);
r1 = abs(r-r(end)); % edge distance

figure;

idx = 1:4:sum(inds); % 4 colonies/plot
for ii = 1:numel(idx)
    subplot(4,3,ii); hold on;
    
    if ii<numel(idx)
        idx2 = idx(ii):idx(ii+1)-1;
    else
        idx2 = idx(ii):sum(inds); 
    end
    
    for jj = idx2
        brachyury = colonies1(jj).radialProfile.NucAvg(:,ch);
        plot(r1, brachyury);
    end
    legend (strcat('Colony', strsplit(int2str(cat(2, colonies1(idx2).ID)),' ')));
end

%%
badColoniesId = [badColoniesId 12];
%%
save(outputFile, 'badColoniesId', '-append');
%%









