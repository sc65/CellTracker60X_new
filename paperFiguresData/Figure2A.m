%% --- Figure 2A, H (CDX2, ISL1, TFAP2A graphs)
%%
saveInPath = '/Volumes/sapnaDrive2/190713_FiguresData/Figure2.mat';
%%
dataset1 = '/Volumes/sapnaDrive2/190411_nanogCdx2/imaging2'; % cdx2
dataset2 = '/Volumes/sapnaDrive2/190319_trophectoderm/imagingSessions/imaging2'; % isl1
datasets = {dataset1, dataset2, dataset2};
ch = [2,4,4];
sampleIds = {[3 1 2], [1:3], [4:6]}; %[bmp, bmpIwp2, bmpSb];
%%
%for ii = 2
for ii = 1:numel(datasets)
    samplesFolder = [datasets{ii} filesep 'processedData'];
    samples = dir(samplesFolder);
    toKeep = find(~cell2mat(cellfun(@(c)strcmp(c(1),'.'),{samples.name},'UniformOutput',false))); % remove non-named folders
    samples = samples(toKeep);
    [~, idx] = natsortfiles({samples.name});
    samples = samples(idx);
    
    samples = samples(sampleIds{ii});
    
    for jj = 1:numel(samples)
        outputFile = [samplesFolder filesep samples(jj).name filesep 'output.mat'];
        [rA{ii,jj}, bins{ii}] =   getColoniesRAfromOutputFile(outputFile, ch(ii));
    end
end
%%
% check
for ii = 1:3
    rA1(ii,:) = mean(rA{1,ii});
    rA2(ii,:) = mean(rA{2,ii});
    rA3(ii,:) = mean(rA{3,ii});
end
%%
allRA = {rA1, rA2, rA3};
%%
for ii = 1:numel(allRA)
    figure; hold on;
    rA_new= allRA{ii};
    for jj= 1:size(rA_new,1)
        plot(xValues, rA_new(jj,:));
    end
end
%%
Fig2A = struct;
Fig2A.cdx2.bmp = rA{1,1};
Fig2A.cdx2.bmpIwp2 = rA{1,2};
Fig2A.cdx2.bmpSB = rA{1,3};

Fig2A.isl1.bmp = rA{2,1};
Fig2A.isl1.bmpIwp2 = rA{2,2};
Fig2A.isl1.bmpSB = rA{2,3};

Fig2H.micropattern.bmp = rA{3,1};
Fig2H.micropattern.bmpIwp2 = rA{3,2};
Fig2H.micropattern.bmpSB = rA{3,3};

%%
save(saveInPath, 'Fig2A', 'Fig2H');

%%
function [coloniesRA, bins] = getColoniesRAfromOutputFile(file, ch)

load(file, 'colonies', 'goodColoniesId');
bins = colonies(1).radialProfile.bins;

rA = zeros(numel(goodColoniesId),numel(bins)-1, numel(ch));
for ii = 1:numel(goodColoniesId)
    counter = 1;
    for kk = ch
        rA(ii,:,counter) = colonies(goodColoniesId(ii)).radialProfile.dapiNormalized.mean(kk,:);
        counter = counter+1;
    end
end
coloniesRA = rA;
end
