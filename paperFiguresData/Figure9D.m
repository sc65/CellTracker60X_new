

%% Figure 9D

saveInFolder = '/Volumes/sapnaDrive2/190713_FiguresData';
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/plate2';
conditions = 33:40;
ch = 1; % brachyury

coloniesRA = cell(1, numel(conditions));

counter = 1;
for ii = conditions
    outputFile1 = [masterFolder filesep 'tiffFiles/Condition' ...
        int2str(ii) filesep 'output.mat'];
    load(outputFile1, 'rA_colonies0', 'nPixels', 'colonyIds_good');
    
    coloniesRA{counter} = rA_colonies0(:, colonyIds_good, 1)';
    counter = counter+1;
end

%%
rA = struct;
rA.SB_0h = coloniesRA{1};
rA.SB_15h = coloniesRA{3};
rA.SB_20h = coloniesRA{4};
rA.SB_25h = coloniesRA{5};
rA.SB_35h = coloniesRA{7};

%%
sId = [1 3:5 7];
counter = 1;
for ii = 1:numel(sId)
    allRA{counter} = mean(coloniesRA{ii}); 
    counter = counter+1;
end

%%    
figure; hold on;

for ii = 1:numel(allRA)
    plot(1:18, allRA{ii});
end
%%
Fig9D = rA;
file1 = [saveInFolder filesep 'Figure9.mat'];
save(file1, 'Fig9D', '-append');
%%
load(file1);

%%
