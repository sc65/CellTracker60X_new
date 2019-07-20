%%

rA = cell(1,numel(samples));
nColonies = zeros(1,numel(samples));
%%
figure; hold on;
sIds = [1 3];
for ii = sIds
    ii
    %for ii = 1:numel(samples)
    %for ii = 1:numel(samples)
    outputFile = [samplesFolder filesep samples(ii).name filesep 'output.mat'];
    load(outputFile, 'colonies', 'goodColoniesId', 'xValues', 'radialProfile_avg');
    
    for jj = 1:numel(colonies)
        rA1(jj,:) = colonies(jj).radialProfile.dapiNormalized.mean(3,:);
    end
    
    rA_all_mean = mean(rA1);
    if ii == 1
        rA_max = max(rA_all_mean);
    end
    rA_all_std = std(rA1)./sqrt(numel(colonies));
    
    radialProfile_avg.dapiNormalized.mean(3,:) = rA_all_mean;
    radialProfile_avg.dapiNormalized.std(3,:) = std(rA1);
    radialProfile_avg.dapiNormalized.stdError(3,:) = rA_all_std;
    save(outputFile, 'radialProfile_avg', '-append'); 
    
    rA_all_mean = rA_all_mean./rA_max;
    rA_all_std = rA_all_std./rA_max;
    %errorbar(xValues, rA_all_mean, rA_all_std, 'Color', colors(ii,:), 'LineWidth', 2);
    
end
% legend(sampleLabels(sIds));
% xlabel('Distance from edge (\mum)'); ylabel('Intensity (a.u.)');
% ax = gca; ax.FontSize = 25; ax.FontWeight = 'bold';