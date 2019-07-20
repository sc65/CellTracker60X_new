%%
%% ------- cells in random walk.
radius = 400;
center = [0,0];
xRange = [-400 400];

nCells = 100;
timeSteps = 165;
v = 1.73; % mean displacement moved by a cell in 1h
%avg distance moved by all cells in 10 minutes = 1.73um, in 6*1.56 = 9.33 um.
%% points on circle
theta1 = [0:0.1:360];
x_onCircle = radius*(cosd(theta1));
y_onCircle = radius*(sind(theta1));
figure; plot(x_onCircle, y_onCircle, 'k.');

%% select random n = nPoints inside circle.
x0 = randi(xRange, 1, nCells);
y0 = sqrt(radius^2 - x0.^2);

y_0 = [+1, -1];
y_01 = randi(2, 1, nCells);
y_02 = rand(1, nCells);

y0 = y_0(y_01).*y_02.*(y0);

x27 = zeros(1, nCells); y27 = x27;

cells_xy = zeros(timeSteps,2, nCells);
%% ------------------- completely random direction
% a) increments only if cell remains inside the circle.
for ii = 1:nCells
    x1 = x0(ii);
    y1 = y0(ii);
    cells_xy(1,1,ii) = x1;
    cells_xy(1,2,ii) = y1;
    
    for jj = 2:timeSteps
        theta = randi([0 360], 1);%-- random direction
        x2 = v*cosd(theta)+x1;
        y2 = v*sind(theta)+y1;
        
        if x2^2 + y2^2 <= radius^2
            x1 = x2;
            y1 = y2;
            
            cells_xy(jj,1,ii) = x1;
            cells_xy(jj,2,ii) = y1;
            
        end
    end
    
    x27(ii) = x1;
    y27(ii) = y1;
end
%%
% b) remains on the boundary if increment forces it out.
for ii = 1:nCells
    x1 = x0(ii);
    y1 = y0(ii);
    cells_xy(1,1,ii) = x1;
    cells_xy(1,2,ii) = y1;
    
    for jj = 2:timeSteps
        theta = randi([0 360], 1);%-- random direction
        x2 = v*cosd(theta)+x1;
        y2 = v*sind(theta)+y1;
        
        if x2^2 + y2^2 > radius^2
            dists = sqrt((x2-x_onCircle).^2 + (y2 - y_onCircle).^2);
            [~, closest] = min(dists);
            x2 = x_onCircle(closest);
            y2 = y_onCircle(closest);
        end
        x1 = x2;
        y1 = y2;
        
        cells_xy(jj,1,ii) = x1;
        cells_xy(jj,2,ii) = x2;
    end
    
    x27(ii) = x1;
    y27(ii) = y1;
end

%% points in the circle
hold on;
plot(x0, y0, '*', 'Color', [0 0.6 0]);
plot(x27, y27, 'r*');
%% displacement
displacement = sqrt((y27 - y0).^2 + (x27 - x0).^2);
figure;
h = histogram(displacement, 'Normalization', 'Probability', 'BinWidth', 2);
h.FaceColor = [0.6 0 0];
xlabel('Displacement (\mum)'); ylabel('Fraction of cells');
ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';
%% ---------------------- radial displaement vs distance from the edge
d0 = 400 - sqrt(y0.^2 + x0.^2); % distance of points from the edge at t0
rD = sqrt(y27.^2 + x27.^2) - sqrt(y0.^2 + x0.^2); % radial displacement

figure; plot(d0, rD, '.', 'Color', [0.7 0 0]);
xlabel('Distance from the edge at t0');
ylabel('Radial displacement');
ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
%%
figure;
h = histogram(rD, 'Normalization', 'Probability', 'BinWidth', 2);
h.FaceColor = [0.6 0 0];
xlabel('radial displacement (\mum)'); ylabel('Fraction of cells');
ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';
%%
%% ------------------------- mean square displacement

deltaT = 1:floor(timeSteps/4);
%Saxton, M. J. (1997). Single-particle tracking: The distribution of diffusion coeffcients. Biophys. J. 72, 1744?1753
%suggests having at least 4 values to compute average from.

msd = zeros(numel(deltaT), numel(nCells)); %mean square displacement, initialize.
msd_sd = msd;
msd_se = msd;

for dt = deltaT
    deltaX = bsxfun(@minus, (cells_xy(1+dt:end,1:2,:)), (cells_xy(1:end-dt,1:2,:)));
    deltaX_square = squeeze(sum((deltaX(:,1:2,:).^2),2));
    
    msd(dt, 1:nCells) = mean(deltaX_square,1);
    msd_sd(dt, 1:nCells) = std(deltaX_square,1);
    msd_se (dt, 1:nCells) = std(deltaX_square,1)./sqrt(size(deltaX_square,1));
end


%% plot
counter = 1;
figure;
cellsToPlot = randi(nCells, 1, 20);
for jj= cellsToPlot
    subplot(5,4,counter);
    plot(deltaT, msd(:,jj), 'Marker', '.', ...
        'Color', 'k', 'MarkerSize', 6);
%     errorbar(deltaT, msd(:,jj),  msd_se(:,jj), 'Marker', '.', ...
%         'Color', 'r', 'MarkerSize', 1);
    counter = counter+1;
    ylabel('msd (\mum^2)');
    xlabel('\Delta t');
end


