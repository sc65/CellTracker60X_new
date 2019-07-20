%%
% making nCells curve

clearvars -except outputFiles
masterFolder = '.';
timePoints = {'25', '29', '33', '37'}; 

outputFiles = cell(1,4);
for ii = 1:4
    outputFiles{ii} = [masterFolder filesep  'output_' timePoints{ii} 'h.mat'];
end
%%
shape2_nCells = cell(1,length(outputFiles));
shape2_colonyPath = shape2_nCells;

shape1_nCells = shape2_nCells;
shape2_colonies = shape2_nCells;
shape3_colonies = shape2_nCells;
%% -- with plates
for ii = 1:length(outputFiles)
    load(outputFiles{ii}, 'plate1', 'colonyPath');
    shape2_colonies{ii} = find([plate1.colonies.shape] == 2);
    %shape3_colonies{ii} = find([plate1.colonies.shape] == 3);
    
    shape2_nCells{ii} = [plate1.colonies(shape2_colonies{ii}).ncells];
    %shape1_nCells{ii} = [plate1.colonies(shape3_colonies{ii}).ncells];
    
    shape2_colonyPath{ii} = colonyPath([shape2_colonies{ii}]);
end
nCells = shape2_nCells;
%% -- with peaks
for ii = 1:length(outputFiles)
    load(outputFiles{ii});
    shape2_colonies{ii} = 1:length(peaks1);
    nCells{ii} = cellfun(@(x) size(x,1), peaks1);
end
%%
colonies1 = shape2_colonies;

figure; hold on;
timePoints = 24:4:48;

colors = {[0 0.5 0], [0.5 0 0], [1 0 0], [0 0 0.5], [0.5 0.5 0], [0 0.5 0.5], [0 0 1]};

for ii = 1:numel(timePoints)
    xValues = timePoints(ii)*ones(1, numel(nCells{ii}));
    plot(xValues, nCells{ii}, '.', 'Color', colors{ii}, 'MarkerSize',14);
end

xlabel('Time(h)'); ylabel('cells');
ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';
%%
% select the colonies with first 50 percentile
coloniesOnCurve = cell(2, numel(timePoints));
threshold = zeros(1,numel(timePoints));

for ii = 1:numel(timePoints)
    n1 = nCells{ii};
    y = prctile(n1, 50); threshold(ii) = y;
    c_high = find(n1>y);
    c_low = find(n1<y);
    
    coloniesOnCurve{1,ii} = colonies1{ii}(c_high);
    coloniesOnCurve{2,ii} = colonies1{ii}(c_low);
end
%%
hold on;
plot([timePoints], threshold, 'k:', 'LineWidth', 3);
%% ---------------------------------------------
% Assuming the division time is 20h, if we start with n0 cell, how many
% cells do we have after tn(max) hrs?

tn = [1:16];
n0 = [1300:20:1550];
%n0 = nCells{1};
tDivision = 20;

nt = zeros(numel(n0),numel(tn));
nt(:,1) = n0';

for ii = 1:numel(n0)
    for jj = 1:numel(tn)
        nt(ii,jj+1) = n0(ii)*2^(tn(jj)/tDivision);
    end
end

hold on;
xValues = timePoints(1):1:timePoints(end);
for ii = 1:size(nt,1)
    plot(xValues, nt(ii,:), 'k-', 'LineWidth', 1);
end
%%



%%
% Select colonies with +/- 50 cells around the optimum cell number.
nStart = [];

[~, position] = intersect(n0, nStart);
nOpt = nt([position],[1:4:17]);

coloniesOnCurve = cell(numel(nStart),numel(timePoints));

for ii = 1:numel(nStart)
    for jj = 1:numel(timePoints)
        coloniesToKeep = find(abs(nCells{jj}-nOpt(ii,jj)) < 50);
        coloniesOnCurve{ii,jj} = shape2_colonies{jj}(coloniesToKeep);
    end
end

%%










