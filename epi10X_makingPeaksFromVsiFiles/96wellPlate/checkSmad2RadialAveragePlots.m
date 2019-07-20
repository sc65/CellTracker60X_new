%% -------------------- filter good colonies, smad2 data. 
% for all conditions, remove the outlier colonies -> smad2 levels, dapi
% levels. 
% calculate average rA, save good colonies. 
% Do the results make sense?

clearvars;
masterFolder = '/Volumes/SAPNA/180314_96wellPlates/Lsm20X/allConditionsMoreImages/smad2_data/plate2/imaging2/colonyImages2';
controlFile = '/Volumes/SAPNA/180314_96wellPlates/plate1/control1.mat';
load(controlFile, 'bins');

conditions = [strcat('iwp2_', strsplit(int2str([0 10:5:40]), ' '), 'h')];
controlCondition = 1;% position of the control condition in conditions array
%%
condition = 6;
outputFile = [masterFolder filesep conditions{condition} filesep 'output.mat'];
load(outputFile);


xvalues = (bins(1:end-1)+bins(2:end))./2;
%% smad2 n/c
legendLabels = strcat('Colony', strsplit(int2str(1:size(rA_colonies_fates,2)), ' '));
figure; hold on;
for ii = 1:size(rA_colonies_smads,2)
    plot(xvalues, rA_colonies_smads(:,ii,2));
end
xlabel('Distance from edge');
ylabel('smad2_n/c' );
legend(legendLabels);    

%% smad2/dapi
legendLabels = strcat('Colony', strsplit(int2str(1:size(rA_colonies_fates,2)), ' '));
figure; hold on;
for ii = 1:size(rA_colonies_fates,2)
    plot(xvalues, rA_colonies_fates(:,ii,3));
end
xlabel('Distance from edge');
ylabel('smad2/dapi' );
legend(legendLabels);    

%% dapi
figure; hold on;
for ii = 1:size(rA_colonies_fates,2)
    plot(xvalues, rA_colonies_dapi(:,ii));
end
legend(legendLabels);
xlabel('Distance from edge');
ylabel('dapi' );
legend(legendLabels);  

%% smad1/dapi
figure; hold on;
for ii = 1:size(rA_colonies_fates,2)
    plot(xvalues, rA_colonies_fates(:,ii,2));
end
legend(legendLabels);
xlabel('Distance from edge');
ylabel('dapi' );
legend(legendLabels);  


%% edit good colonies list

colonyIds_good = [1 2];
save(outputFile, 'colonyIds_good', '-append');
%%
saveInPath = [masterFolder filesep conditions{condition} filesep 'coloniesRA'];
saveAllOpenFigures(saveInPath);




