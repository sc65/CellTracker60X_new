counter = 1;
timepoints = [1  36 72 108 126];

binsize = 150;
rollsize = 15;

intensity = zeros(numel(timepoints),numel(0:rollsize:limit));
standard_error = intensity;

for t = timepoints
    
    cells_info = peaks{t};
    cells_info(cells_info(:,5)==0,:) = [];
    all_dists = bwdist(~ colony_mask);
    indices = sub2ind(size(colony_mask), floor(cells_info(:,2)), floor(cells_info(:,1)));
    
    dists = all_dists(floor(indices));
    
    
    
    limit = max(max(dists)) - binsize;
    % intensity = zeros(numel(timepoints),numel(0:rollsize:limit));
    % distances = intensity;
    q = 1;
    
    for ii = 0:rollsize:limit
        idx = dists>ii &  dists<ii+binsize;
        
        if sum(idx)>0
            intensity(counter, q) = mean(cells_info(idx, 6)./cells_info(idx, 5));
            standard_error(counter, q) = std(double(cells_info(idx, 6)./cells_info(idx, 5))/sqrt(length(idx)));
        end
        q = q+1;
    end
    counter = counter+1;
end


xaxis_values = linspace(0, max(max(dists))/1.55, length(intensity));
figure;

for i = 1:length(timepoints)
    errorbar(xaxis_values, intensity(i,:), standard_error(i,:), 'k-');
    hold on;
    plot(xaxis_values, intensity(i,:), 'Color', [rand(1,3)], 'LineWidth', 4);
end

legend('t = 1', 't=12',  't=24', 't=36', 't=42');
xlabel('Distance from the edge (\mum)');
ylabel('Radial Average');
title('\beta -catenin levels');
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
