
%% figure1C

dataset1 = '/Volumes/sapnaDrive2/190319_trophectoderm/imagingSessions/imaging2'; % [bmp, bmp+iwp2, bmp+sb; sox2 nanog]
dataset2 = '/Volumes/SAPNA/190402_nodalkOutCells_control_nanog_sox2'; %[bmp, nodal KO; Nanog, sox2];

%%
% 1) dataset1
file1 = [dataset1 filesep 'metadata.mat'];
meta1 = load(file1);
%%
ch = 3; %nanog
samples1 = {'III_bmp', 'III_IWP2', 'III_SB'};
colonies1RA = cell(1, numel(samples1));

% extract individual colonies' RA
for ii = 1:3
    file1 = [dataset1 filesep 'processedData' filesep samples1{ii} filesep 'output.mat'];
    [colonies1RA{ii}, bins] = getColoniesRAfromOutputFile(file1, ch);
end
%%
% 2) dataset 2
file2 = [dataset2 filesep 'metadata.mat'];
meta2 = load(file2);
%%
ch = 3; %nanog
samples2 = {'Control_48h', 'NodalKO_48h'};
colonies2RA = cell(1,numel(samples2));
for ii = 1:2
    file1 = [dataset2 filesep 'processedData' filesep samples2{ii} filesep 'output.mat'];
    load(file1);
    [colonies2RA{ii}, ~] = getColoniesRAfromOutputFile(file1, ch);
    
end
%%
% check
for ii = 1:3
    rA1(ii,:) = mean(colonies1RA{ii});
    rA2(ii,:) = mean(colonies2RA{ii});
end
%%
rA1 = rA1./max(rA1(1,:));
rA2 = rA2./max(rA2(1,:));
%%
figure; hold on;
rA= [rA1; rA2(2,:)];
for ii = 1:size(rA,1)
    plot(xValues, rA(ii,:));
end
%%
% save
Fig1C.bmp_1 = colonies1RA{1};
Fig1C.bmpIwp2_1 = colonies1RA{2};
Fig1C.bmp_2 = colonies2RA{1};
Fig1C.NodalKO_2 = colonies2RA{2};
%%
saveInFolder = '/Volumes/sapnaDrive2/190713_FiguresData';
file = [saveInFolder filesep 'Figure1.mat'];
save(file, 'Fig1A', 'Fig1B', 'Fig1C', 'bins');

%% ----------------------------------------------------------------------------------------------
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

%%