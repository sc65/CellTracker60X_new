
time_points = [1 100];
allstats = getCellMigrationStats(peaks, colony_mask, time_points);

to_keep = ismember(squeeze(allstats(1,1,:)), cell_indices_t0);
cells_in_territory_new = allstats(:,:,to_keep);


% make the relevant plots.
figure;

% Plot1:  plot distance from the edge at t/distance from the edge at t0.

subplot(1,2,1);
ncells = size(cells_in_territory_new, 3);
x_values = (time_points(1):time_points(2))./3;

for jj = 1:ncells
    
    y_values = squeeze(cells_in_territory_new(:,5,jj))./squeeze(cells_in_territory_new(:,4,jj));
    hold on;
    plot(x_values, y_values,'Color', rand(1,3), 'LineWidth', 2);
    
end

xlabel('Time after Differentiation(hrs)');
ylabel('Distance from edge at t/Distance from the edge at t0');

ax = gca;
ax.FontSize = 12;


for jj = 1:ncells
    y_values(:,jj) = squeeze(cells_in_territory_new(:,5,jj))./squeeze(cells_in_territory_new(:,4,jj));
end


y_values2 = mean(y_values,2);
error = std(y_values,0, 2)./sqrt(22);

subplot(1,2,2);
errorbar(x_values, y_values2, error, '-ro');
hold on;
plot(x_values, y_values2, '-r', 'LineWidth', 2);

title(['t= ' int2str(time_points(1)/3) ':' int2str(time_points(2)/3)]);

xlabel('Time after Differentiation(hrs)');
ylabel('nuclear \beta catenin/RFP');

ax = gca;
ax.FontSize = 12;
hold off;