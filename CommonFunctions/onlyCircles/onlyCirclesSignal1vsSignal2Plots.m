%%
% wrap up Circles- bCat, smad1, smad2.

% correlation plots.
outputFiles = {'/Volumes/SAPNA/170327CDX2Smad1/output.mat' ...
    , '/Volumes/SAPNA/170317CirclesBCatTSox2/Folder_20170317/output.mat'...
    , '/Volumes/SAPNA/170317CirclesSmad2TSox2/Folder_20170317/output.mat'};

fateColumnId = [6 10 8]; %[Cdx2, T, Sox2]
signalTransducerColumnId = [10 6 6]; %[smad1, bCat, smad2]
xlimits = [10 10 10];
ylimits = [20 20 20];
%%
for ii = 1:3
    load(outputFiles{ii});
    plates{ii} = plate1;
end
%%
for ii = 1:2
    figure;
    plate1 = plates{ii};
    
    for sh = [1:3]
        subplot(2,2, sh);
        hold on;
        sampleColony = find([plate1.colonies.shape] == sh);
        
        for jj = sampleColony
            data = plate1.colonies(jj).data;
            fateData = data(:, fateColumnId(ii))./data(:,5);
            signalTransducerData = data(:, signalTransducerColumnId(ii))./data(:,5);
            
            plot(signalTransducerData, fateData,  'k.', 'MarkerSize', 8);
            
        end
        %xlim([0 xlimits(ii)]);
        %ylim([0 ylimits(ii)]);
        hold off;
    end
    
end








