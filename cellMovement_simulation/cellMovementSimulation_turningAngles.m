function cellMovementSimulation_turningAngles(outputFile1, outputFile2, nCells)
%% saves the initial and final positions of nCells in outputFile2

%% ---------- inputs
% 1)outputFile1: file with the avgSpeed and turningAngles information.
% 2)outputFile2: file where simulated positions are saved.

%% ---------- algorithm
% 1) pick n points inside a circle of a given radius
% 2) for each point, pick a random starting angle
% 3) for every subsequent timepoint, pick a random number from all turning angles and
% calculate the new position.
%%
display(outputFile2);

load(outputFile1, 'speed', 'turningAngles');
%dAvg = mean(speedAvg); %average distance(in um) covered in 1 timestep.
%allTurningAngles = turningAngles(:);
%%
radius = 400;
theta1 = 0:0.1:360;
x_onCircle = radius.*cosd(theta1);
y_onCircle = radius.*sind(theta1);
%% 
% x0, y0 - starting position of n points inside the circle
xRange = [-radius radius];

x0 = randi(xRange, 1, nCells); 
y0 = sqrt(radius^2 - x0.^2);

y_0 = [+1, -1];
y_01 = randi(2, 1, nCells);
y_02 = rand(1, nCells);
y0 = y_0(y_01).*y_02.*(y0); %any value from [-1:1]y0

x27 = zeros(1, nCells); y27 = x27; %final position of n points inside the circle
%%

for ii = 1:nCells
    tic;
    ii
    % starting position
    x1  = x0(ii);
    y1 = y0(ii);
    
    
    % first step - random direction
    d1 = speed(1, randi(size(speed,2),1));
    theta1 = rand(1,1)*randi([0 360], 1);
    x2 = x1 + d1*cosd(theta1);
    y2 = y1 + d1*sind(theta1);
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
       
        d2 = speed(jj, randi(size(speed,2),1));
        %select an angle randomly from all turningAngles
        theta2 = turningAngles(jj-1, randi(size(turningAngles,2),1));
        
        syms d2_x d2_y
        eqn1 = d1_x*d2_x + d2_y*d1_y == d1*d2*cosd(theta2);
        eqn2 = d1_x*d2_y - d1_y*d2_x == d1*d2*sind(theta2);
        sol = solve([eqn1 eqn2], [d2_x, d2_y]);
        d2_x = real(double(sol.d2_x)); d2_x = d2_x(1);
        d2_y = real(double(sol.d2_y)); d2_y = d2_y(1);
        disp([num2str(d2_x) '  ' num2str(d2_y) '   ' num2str(sqrt(d2_x*d2_x+d2_y*d2_y))]);
        
        x2 = x1+d2_x;
        y2 = y1+d2_y;
        d1 = d2;
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
fprintf('displacement...');
displacement = sqrt((y27 - y0).^2 + (x27 - x0).^2);
disp(displacement);

fprintf('saving..');
startPosition = [x0', y0']; disp(startPosition);
endPosition = [x27', y27']; disp(endPosition);
save(outputFile2, 'startPosition', 'endPosition', 'displacement');



















