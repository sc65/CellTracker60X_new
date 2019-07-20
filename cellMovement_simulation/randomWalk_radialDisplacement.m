%%
%% ------- cells in random walk.
radius = 400;
center = [0,0];
xRange = [-400 400];

%% points on circle
theta1 = [0:0.1:360];
x_onCircle = radius*(cosd(theta1));
y_onCircle = radius*(sind(theta1));
figure; plot(x_onCircle, y_onCircle, 'k.');

%% select random n = nPoints inside circle.
nPoints = 100;
x0 = randi(xRange, 1, nPoints);
y0 = sqrt(radius^2 - x0.^2);

y_0 = [+1, -1];
y_01 = randi(2, 1, nPoints);
y_02 = rand(1, nPoints);

y0 = y_0(y_01).*y_02.*(y0);

x27 = zeros(1, nPoints); y27 = x27;
%%
v = 1.73; % mean displacement moved by a cell in 1h
%avg distance moved by all cells in 10 minutes = 1.56um, in 6*1.56 = 9.33 um.

%% ------------------- completely random direction
% a) increments only if cell remains inside the circle.
for ii = 1:nPoints
    x1 = x0(ii);
    y1 = y0(ii);
    
    for jj = 1:27*6
        theta = randi([0 360], 1);%-- random direction
        x2 = v*cosd(theta)+x1;
        y2 = v*sind(theta)+y1;
        
        if x2^2 + y2^2 <= radius^2
            x1 = x2;
            y1 = y2;
        end
    end
    
    x27(ii) = x1;
    y27(ii) = y1;   
end
%%
% b) remains on the boundary if increment forces it out.
for ii = 1:nPoints
    x1 = x0(ii);
    y1 = y0(ii);
    
    for jj = 1:27*6
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
    end
    
    x27(ii) = x1;
    y27(ii) = y1;   
end
%%

%% points in the circle
figure; hold on;
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





