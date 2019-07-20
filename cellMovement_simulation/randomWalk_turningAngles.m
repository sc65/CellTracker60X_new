%% random walk_ turningAngle1

% 1) pick n points inside a circle of a given radius
% 2) for each point, pick a random starting angle
% 3) for every subsequent timepoint, pick a random number from all turning angles and
% calculate the position vector.
%%
radius = 400;
theta1 = 0:0.1:360;
x_onCircle = radius.*cosd(theta1);
y_onCircle = radius.*sind(theta1);
figure; plot(x_onCircle, y_onCircle, 'k.');

% %% x0, y0 - starting position of n points inside the circle
xRange = [-radius radius];
nPoints = 200;
x0 = randi(xRange, 1, nPoints); 
y0 = sqrt(radius^2 - x0.^2);

y_0 = [+1, -1];
y_01 = randi(2, 1, nPoints);
y_02 = rand(1, nPoints);
y0 = y_0(y_01).*y_02.*(y0); %any value from [-1:1]y0

x27 = zeros(1, nPoints); y27 = x27; %final position of n points inside the circle
%%
dAvg = 1.56; % average distance(in um) covered in 1 timestep.
for ii = 19:nPoints
    tic;
    ii
    % starting position
    x1  = x0(ii);
    y1 = y0(ii);
    
    % first step - random
    theta1 = rand(1,1)*randi([0 360], 1);
    x2 = x1 + dAvg*cosd(theta1);
    y2 = y1 + dAvg*sind(theta1);
    if x2^2 + y2^2 > radius^2
        dists = sqrt((x2-x_onCircle).^2 + (y2 - y_onCircle).^2);
        [~, closest] = min(dists);
        x2 = x_onCircle(closest);
        y2 = y_onCircle(closest);
    end

     d1_x = x2-x1;
     d1_y = y2-y1;
        
    for jj = 2:27*6 %6 timesteps per hour
        
        x1 = x2;
        y1 = y2;
       
        %select an angle randomly from all turningAngles
        theta2 = allTurningAngles(randi(numel(allTurningAngles),1));
        
        syms d2_x d2_y
        eqn1 = d1_x*d2_x + d2_y*d1_y == dAvg*dAvg*cosd(theta2);
        eqn2 = d1_x*d2_y - d1_y*d2_x == dAvg*dAvg*sind(theta2);
        sol = solve([eqn1 eqn2], [d2_x, d2_y]);
        d2_x = real(double(sol.d2_x)); d2_x = d2_x(1);
        d2_y = real(double(sol.d2_y)); d2_y = d2_y(1);
        %disp([num2str(d2_x) '  ' num2str(d2_y) '   ' num2str(sqrt(d2_x*d2_x+d2_y*d2_y))]);
        
        x2 = x1+d2_x;
        y2 = y1+d2_y;
        
        if x2^2 + y2^2 > radius^2
            dists = sqrt((x2-x_onCircle).^2 + (y2 - y_onCircle).^2);
            [~, closest] = min(dists);
            x2 = x_onCircle(closest);
            y2 = y_onCircle(closest);
        end
        
    end
    x27(ii) = x2;
    y27(ii) = y2;
    
    toc;
end

%%
lastTerm = ii;
x0_1 = x0(1:lastTerm);
y0_1 = y0(1:lastTerm);

x27_1 = x27(1:lastTerm);
y27_1 = y27(1:lastTerm);

hold on;
plot(x0_1, y0_1, '*', 'Color', [0 0.6 0]);
plot(x27_1, y27_1, 'r*');
%% displacement
displacement = sqrt((y27_1 - y0_1).^2 + (x27_1 - x0_1).^2);
figure;
h = histogram(displacement, 'Normalization', 'Probability', 'BinWidth', 20);
h.FaceColor = [0.6 0 0];
xlabel('Displacement (\mum)'); ylabel('Fraction of cells');
ax = gca; ax.FontSize = 16; ax.FontWeight = 'bold';

%% radialDisplacement
d0 = 400 - sqrt(y0_1.^2 + x0_1.^2); % distance of points from the edge at t0
rD = sqrt(y27_1.^2 + x27_1.^2) - sqrt(y0_1.^2 + x0_1.^2); % radial displacement

figure; plot(d0, rD, '.', 'Color', [0.7 0 0], 'MarkerSize', 10);
xlabel('Distance from the edge at t0 (\mum)');
ylabel('Radial displacement (\mum)');
ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
















