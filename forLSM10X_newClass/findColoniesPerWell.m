function [colonyIds, imagesPerColony_x, imagesPerColony_y, distances_c] = findColoniesPerWell(fileInfo)
%% returns the no. of positions imaged in each well in each imaging run
%logFile = 'MATL_Mosaic.log';


%% get x & y position coordinates
files = fileInfo{1};

x_Index = strfind(fileInfo{1}, '<XPos>');
x_Index = not(cellfun('isempty', x_Index));
files1 = files(x_Index);
x1_start = cell2mat(regexp(files1, '<XPos>','end'));
x1_end = cell2mat(regexp(files1, '</XPos>','start'));
for ii = 1:length(files1)
    fun1 = @(x) str2double(x(x1_start(ii)+1:x1_end(ii)-1));
    x1(ii,1) = fun1(files1{ii});
end


y_Index = strfind(fileInfo{1}, '<YPos>');
y_Index = not(cellfun('isempty', y_Index));
files2 = files(y_Index);
y1_start = cell2mat(regexp(files2, '<YPos>','end'));
y1_end = cell2mat(regexp(files2, '</YPos>','start'));
for ii = 1:length(files2)
    fun2 = @(x) str2double(x(y1_start(ii)+1:y1_end(ii)-1));
    y1(ii,1) = fun2(files2{ii});
end

%% find the most distant consecutive points
xy = [x1 y1];
distances = distmat(xy);

idx1 = [1:length(files1)-1]';
idx2 = idx1+1;
linear_idx = sub2ind([length(files1),length(files1)], idx1, idx2);

distances_c = distances([linear_idx]);
%figure; plot([1:length(files1)-1]', distances_c);
%%
wells = find(distances_c>5000);
% works good for colonies imaged at 20X.

[imagesPerColony_x, imagesPerColony_y] = findImagesPerMosaicFromLogFile(fileInfo);
imagesPerColony = imagesPerColony_x(1) * imagesPerColony_y(1);
colonyIds = wells./imagesPerColony;
nColonies = size(xy,1)/imagesPerColony;
colonyIds = [colonyIds; nColonies];
colonyIds = [colonyIds(1) diff(colonyIds)'];
end







