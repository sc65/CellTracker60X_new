
%%
samples = dir('.');
samples(1:3) = [];

%%
%for ii = 21
for ii = 3:numel(samples)
    rmdir([samples(ii).name filesep 'coloniesRA'], 's');
    rmdir([samples(ii).name filesep 'radialAveragePlots'], 's');
    files1 = dir([samples(ii).name filesep '*Segmentation_*.h5']);
    for jj = 1:numel(files1)
        delete([samples(ii).name filesep files1(jj).name]);
    end
    delete([samples(ii).name filesep 'output1.mat']);

end
%%