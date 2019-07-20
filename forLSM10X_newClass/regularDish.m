
%%

% use colonymask to find distinct objects in image
% treat each object as a separate colony

% save labelled colonyMask in outputfile

%%
masterFolder = '/Volumes/sapnaDrive2/snail_check/experiment2/snail_sox2_nanog';
metadata  = [masterFolder filesep 'metadata.mat'];
load(metadata);

sample = 'dish_media_45h';
samplesFolder = [masterFolder filesep 'processedData' filesep sample];
files = dir([samplesFolder filesep '*.h5']);

colonies = colonyS;
%%
colonyCounter = 1;
for ii = 1:numel(files)
    colonyMask = imread([samplesFolder filesep 'colony' int2str(ii) '_colonyMask.tif']);
    
    if ~isempty(find(colonyMask, 1))
        nuclearMask = imread([samplesFolder filesep 'colony' int2str(ii) '_nuclearMask.tif']);
        stats = regionprops(colonyMask, 'area');
        colonyMask = bwlabel(colonyMask);
        
        for jj = 1:max(unique(colonyMask))
            colonyMask1 = colonyMask == jj;
            nuclearMask1 = nuclearMask & colonyMask1;
            %figure; imshow(colonyMask1);
            %figure; imshow(nuclearMask1);
            colonies(colonyCounter) = colonyS(ii,samplesFolder, ['colony' int2str(ii) '.tif'], stats(jj).Area);
            colonies(colonyCounter) = calculateRadialProfile(colonies(colonyCounter), meta, colonyMask1, nuclearMask1);
            colonyCounter = colonyCounter+1;
        end
        
        imwrite(colonyMask, ['colony' int2str(ii) '_colonyMask_labelled.tif']);
    end   
end

outputFile = [samplesFolder filesep 'output.mat'];
save(outputFile, 'colonies');


