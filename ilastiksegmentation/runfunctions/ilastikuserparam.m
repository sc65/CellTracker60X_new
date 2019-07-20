function ilastikuserparam

global userParam
%
% ------------file paths----------------
% segfiledir: ilastik_Pmasks: directory path of ilastik 2d segmentation probability density maps
% rawfiledir: dapi_images: directory path of the nuclear channel raw images (the same
% that was fed to FISH)
% mrnafilepath : spatzcells_output: directory path of spatzcells output.

% outfiledir: output_table_path: output file path, wherever you want to save sampleoutput.mat
% imageoutputdir:output_images if you want to save segmented image files, declare this
% path too. Else, comment it out.


userParam.ilastik_Pmasks = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat/ilastik_probability_masks';
userParam.dapi_images = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat/images00'; 
userParam.spatzcells_output = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat/new_mRNAoutput';
userParam.fluorescent_protein = 0; % if there is no fluorescent protein quantification, set this to 0; else, specify the path corresponding to images with proteinchannel.

userParam.output_table =  '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat/newoutput_matfiles';
userParam.output_images = '/Users/sapnachhabra/Desktop/CellTrackercd/Experiments/Cher/161010BetaCatCellsDkk1/SpatzcellsFormat/segmentedimages';

%%
%---------------samples informtation---------------
userParam.nsamples = 3;
userParam.nuclear_channel = 0; %Andor output files, *w000channel.tif, channel value corresponding to DAPI images. 
userParam.pchannel = 0; % fluorescence channel for protein quantification
userParam.channels = 1; %fluorescent channel for which mRNA's are counted and need to be assigned
userParam.negativecontrol = 2; %sample corresponding to negative control
userParam.imviews = 0; % to display the result of segmented images; set it to 0 if you have a lot of images. 
userParam.imsave = 1; % to save all the segmented images for all channels separately (set this to 0 if you have a lot of samples.)

%%
%------------------ parameters for function primary filter--------
%  % number of zslices in the image
userParam.logfilter = 10;
userParam.bthreshfilter = 0.25;
userParam.diskfilter = 3;
userParam.area1filter = 100;

%%
% --------------parameters for function secondary filter----------
userParam.minstartobj = 2;
userParam.minsolidity = [0.95, 0.75];
userParam.area2filter = 300;

%%
% tracing objects
% if you think that one object can be present in a maximum of 5 zslices, set that as the limit.
% matchdistance: minimum distance in pixels between the centroid of two
% objectsin two different zslices to be considered as the same object.
userParam.matchdistance = 15;

%%
% overlap filter
userParam.overlapthresh = 70; 
%%
% maximum distance(in pixels) between centroid of cell and mrna. 
userParam.cmcenter = 40;

end