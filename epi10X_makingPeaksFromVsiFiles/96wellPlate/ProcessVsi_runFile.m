

%%
clearvars;

masterFolder = '/Volumes/SAPNA/190107_96wellPlate';
rawImagesPath = [masterFolder filesep 'rawData'];
%conditions = {'wells1', 'wells2'};
dapiChannel = 1;

saveInPath = [masterFolder filesep 'tiffFiles'];
mkdir(saveInPath);
%conditionIds = [36:42 34 35];
%%

%for ii = 1:numel(conditions)
%vsiFiles = dir([rawImagesPath filesep conditions{ii} filesep '*.vsi']);
vsiFiles = dir([rawImagesPath filesep '*.vsi']);
%for jj = [1 3:6]
for jj = 49:numel(vsiFiles)
    tic;
    vsiFile1 = [vsiFiles(jj).folder filesep vsiFiles(jj).name];
    saveInPath1 = [saveInPath filesep 'Condition' int2str(jj)];
    processVsi(vsiFile1, saveInPath1);
    
    toc;
end
%end

%%
