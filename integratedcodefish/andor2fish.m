%%
% this code corrects andor file names and copies andor files to fishformat
% in the new folder.

inputdirec = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/RawData1';
outputdirec = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat';

[fileinfo, start] = postart(inputdirec);
samplenumlist = start:length(fileinfo);

i = start;
for i = samplenumlist
    filepath = strcat(inputdirec, filesep, fileinfo(i).name);
    ff = readAndorDirectorymont(filepath);
    
    prefix = ff.prefix;
    channels = length(ff.w);
    zslices = length(ff.z);
    
    positions = length(ff.p);
    
    if(positions == 0);
        allfiles = dir([filepath filesep '*.tif']);
        
        for jj = 1:numel(allfiles)
            
            x1 = strfind(allfiles(jj).name, '_');
            
            startstring = allfiles(jj).name(1:x1(1));
            endstring = allfiles(jj).name(x1(1)+1 : end);
            middlestring = 'm0000';
            
            newname = strcat(startstring, middlestring, '_', endstring);
            newfilepath = strcat(filepath, filesep, newname);
            
            oldfilepath = strcat(filepath, filesep, allfiles(jj).name);
            
            movefile(oldfilepath, newfilepath);
        end
        ff = readAndorDirectorymont(filepath);
        
        prefix = ff.prefix;
        channels = length(ff.w);
        zslices = length(ff.z);
        
        positions = length(ff.p);
    end
    
    
    for ch = 0:channels-1
        clear files;
        
        files = dir([filepath filesep sprintf('*w%04d.tif', ch)]);
        
        for jj = 1:length(files)
            newfilename = strrep(files(jj).name, ff.prefix, sprintf('fish%02d', i-start+1));
            
            newfilepath = strcat(outputdirec, filesep, sprintf('images%02d', ch), filesep, newfilename);
            oldfilepath = strcat(filepath, filesep, files(jj).name);
            
            copyfile(oldfilepath, newfilepath);
        end
    end
end


%%
% make masks


imagedirectory = '/Volumes/SAPNA/160517fishnewest/spatzcells format/images00';
maskfolderpath = '/Volumes/SAPNA/160517fishnewest/spatzcells format/masks';

mkdir(maskfolderpath);
samples = 13;

ff = readFISHdir(imagedirectory, samples);

masknum = sum(ff.positions);

for i = 1:masknum
    LcFull = ones(1024);
    
    maskname = sprintf('fishmask%02d.mat', i);
    maskpath = strcat(maskfolderpath, filesep, maskname);
    
    save(maskpath, 'LcFull');
end








