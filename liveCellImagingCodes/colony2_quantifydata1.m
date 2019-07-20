%%
% filter cells -at least those in territory 1.

%%
% find cells in territory1.
territory_boundaries = [0 100 250 400]; %distance from the edge(in um)
umtopixel = 1.55;

ii = 1;

mindistance = territory_boundaries(ii)*umtopixel;
maxdistance = territory_boundaries(ii+1)*umtopixel;

%select cells whose distance from the edge fall between mindistance and
%maxdistance at t0.
distance_from_edge_t0 = squeeze(allstats(1,2,:));

condition_to_satisfy = distance_from_edge_t0 > mindistance & distance_from_edge_t0 < maxdistance;
cells_in_territory = allstats(:,:, condition_to_satisfy);

cell_indices = squeeze(cells_in_territory(1,1,:));
%%
% find indices of false positives.
% remove those cells from the list.
false_positives = [334 384 367];
not_to_remove = ~ismember(squeeze(allstats(1,1,:)), false_positives);
allstats = allstats(:,:,not_to_remove);
%%
% for timepoints>1
% Define territories based on t0.

cell_indices_t0 = squeeze(cells_in_territory_cleaned(1,1,:));
%%
tic;
time_points = [1 100];


allstats = getCellMigrationStats(peaks, colony_mask, time_points);
toc;


to_keep = ismember(squeeze(allstats(1,1,:)), cell_indices_t0);
cells_in_territory_new = allstats(:,:,to_keep);


% make the relevant plots.
figure;

% Plot1:  plot distance from the edge at t/distance from the edge at t0.

subplot(1,2,1);
ncells = size(cells_in_territory_new, 3);
x_values = (time_points(1):time_points(2))./3;

for jj = 1:ncells
    
    y_values = squeeze(cells_in_territory_new(:,2,jj))./squeeze(cells_in_territory_new(1,2,jj));
    hold on;
    plot(x_values, y_values,'Color', rand(1,3), 'LineWidth', 2);
    
end

xlabel('Time after Differentiation(hrs)');
ylabel('Distance from edge at t/Distance from the edge at t0');

ax = gca;
ax.FontSize = 12;


for jj = 1:ncells
    y_values(:,jj) = squeeze(cells_in_territory_new(:,2,jj))./squeeze(cells_in_territory_new(1,2,jj));
end


y_values2 = mean(y_values,2);
error = std(y_values,0, 2)./sqrt(22);

subplot(1,2,2);
errorbar(x_values, y_values2, error, '-ro');
hold on;
plot(x_values, y_values2, '-r', 'LineWidth', 2);

title(['t= ' int2str(time_points(1)/3) ':' int2str(time_points(2)/3)]);

xlabel('Time after Differentiation(hrs)');
ylabel('Distance from edge at t/Distance from the edge at t0');

ax = gca;
ax.FontSize = 12;
hold off;
%%
% how does beta catenin expression change in these cells as a function of
% time.






