%%
function files = readLSMmontageDirectory(direc, logfile)
%% returns a structure - files, with all relevant information, extracted from the metadata.
% fields in the structure files:
% direc: path of the raw data
% coloniesPerWell: total positions in the montage
% imagesPerColony_x: positions imaged in X direction
% imagesPerColony_y: positions imaged in Y direction
%%
logfileId  = fopen(logfile);
logileInfo = textscan(logfileId, '%s');
fclose(logfileId);
allLines = logileInfo{1};
lineId = contains(logileInfo{1}, '<Repeats>');
line1 = allLines(lineId);
idx1 = cell2mat(regexp(line1, '<Repeats>','end'));
idx2 = cell2mat(regexp(line1, '</Repeats>','start'));

t1 = str2double(line1{1}(idx1+1:idx2-1));
t2 = numel(dir([direc filesep 'Track0001/*oif']));

[coloniesPerWell, imagesPerColony_x, imagesPerColony_y, ~] = findColoniesPerWell(logileInfo);

files.dir = direc;
files.nWells = length(coloniesPerWell);
files.coloniesPerWell = coloniesPerWell;
files.imagesPerColony_x = imagesPerColony_x;
files.imagesPerColony_y = imagesPerColony_y;

if t2<t1
    files.timepoints = t2;
else
    files.timepoints = t1;
end    

end

