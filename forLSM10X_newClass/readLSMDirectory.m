%%
function files = readLSMDirectory(direc, logfile)
%% returns a structure - files, with all relevant information, extracted from the metadata.
% fields in the structure files:
% direc: path of the raw data
% coloniesPerWell: total positions in the montage
% imagesPerColony_x: positions imaged in X direction
% imagesPerColony_y: positions imaged in Y direction
%%
[coloniesPerWell, imagesPerColony_x, imagesPerColony_y, ~] = findColoniesPerWell(logfile);

files.dir = direc;
files.nWells = length(coloniesPerWell);
files.coloniesPerWell = coloniesPerWell;
files.imagesPerColony_x = imagesPerColony_x;
files.imagesPerColony_y = imagesPerColony_y;

end

