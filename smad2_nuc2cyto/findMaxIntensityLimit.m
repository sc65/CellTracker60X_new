function intensities_max = findMaxIntensityLimit(samplesPath, channels)

%% ---- find intensity limits for all channels using the control sample
allColonies = dir([samplesPath filesep 'Colony_*.tif']);
allColonies = allColonies(1:2:end); % exclude nuclear channel files

intensities_max = zeros(1,numel(channels));
%%
counter = 1;
for ii = channels
    intensities_high = zeros(1, 1e3); n1 = 1; n2 = 100;
    for jj = 1:numel(allColonies)
        image1 = imread([allColonies(jj).folder filesep allColonies(jj).name],ii);
        intensities1 = image1(:);
        intensities1 = sort(intensities1);
        intensities_high(n1:n2) = intensities1(end-99:end); % max 100 values
        n1 = n2+1;
        n2 = n1+100-1;
    end
  
    intensities_high = intensities_high(1:find(intensities_high,1,'last'));
    %figure; histogram(intensities_high);
    intensities_high = sort(intensities_high);
    intensities_max(counter) = intensities_high((0.5*numel(intensities_high)));
    counter = counter+1;
end






