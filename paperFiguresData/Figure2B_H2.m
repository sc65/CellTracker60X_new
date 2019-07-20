
%% Figure 2B,H
saveInFile = '/Volumes/sapnaDrive2/190713_FiguresData/Figure2.mat';
load(saveInFile);

%%
masterFolder= '/Volumes/sapnaDrive2/190304_cellsInDish_BMP_SB_IWP2_kongData/1-4_media-BMP-BMPSB-BMPIWP2';
samples = {'mTeSR', 'BMP4', 'BMP4+SB', 'BMP4+IWP2'};

%%
sampleFolders = dir(masterFolder);
toKeep =  find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{sampleFolders.name},'UniformOutput',false))); % remove non-named folders
sampleFolders = sampleFolders(toKeep);
%%
fateMarkers = {'bra', 'sox2', 'cdx2', 'gata3', 'nanog', 'gata3_2', 'tfap2a' 'snail', 'otx2', 'isl1', 'hand1'};
%%
fateValues = cell(numel(fateMarkers), numel(samples));

tooHigh = [4000 50000];  % remove any row with any value higher than tooHigh intensities in last dataset are way off!
markerCombinations = [1:3; [4 0 0]; 5:7; 8:10; 11 0 0]; % in one outputfile
markerCounter = 1;

for ii = 1:numel(sampleFolders)
    outputFile = [sampleFolders(ii).folder filesep sampleFolders(ii).name filesep 'output.mat'];
    load(outputFile)
    
    counter2 = 1;
    channels = [2:2+sum(markerCombinations(ii,:)>0)-1];
    
    if ii ==2 || ii ==5
        tooHigh1 = tooHigh(2);
    else
        tooHigh1 = tooHigh(1);
    end
    for jj = [1 5 9 13] % new samples
        data1 = [cells(jj).intensity; cells(jj+1).intensity; cells(jj+2).intensity; cells(jj+3).intensity];
        idx = any(data1 > tooHigh1, 2);
        data1 = data1(~idx,:);
        markerCounter = markerCombinations(ii,1);
        for kk = channels
            fateValues{markerCounter,counter2} = data1(:,kk)./data1(:,1);
            markerCounter = markerCounter+1;
        end
        counter2 = counter2+1;
    end
end
%%
markerIds = [3 7 10];
fateValues1 = fateValues(markerIds,:);
%%
fateValues_avg = cellfun(@mean, fateValues1);
fateValues_stdDev = cellfun(@std, fateValues1);
fateValues_stdError = cellfun(@(x) std(x)./sqrt(numel(x)), fateValues1);
%%
% check
for ii = 1:3
    figure;
    data = fateValues_avg(ii,:);
    err = fateValues_stdDev(ii,:);
    hBar = barwitherr(err, data);
end
%%
% cdx2
Fig2B.cdx2.mtesr = fateValues1{1,1};
Fig2B.cdx2.bmp = fateValues1{1,2};
Fig2B.cdx2.bmpIwp2 = fateValues1{1,4};
Fig2B.cdx2.bmpSB = fateValues1{1,3};

% isl1
Fig2B.isl1.mtesr = fateValues1{3,1};
Fig2B.isl1.bmp = fateValues1{3,2};
Fig2B.isl1.bmpIwp2 = fateValues1{3,4};
Fig2B.isl1.bmpSB = fateValues1{3,3};

% tfap2a
Fig2H.regularCulture.mtesr = fateValues1{2,1};
Fig2H.regularCulture.bmp = fateValues1{2,2};
Fig2H.regularCulture.bmpIwp2 = fateValues1{2,4};
Fig2H.regularCulture.bmpSB = fateValues1{2,3};
%%
save(saveInFile, 'Fig2B', 'Fig2H', '-append');

