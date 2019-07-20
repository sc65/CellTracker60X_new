
%% -----------------------------------------------------  Figure 9C, 3

outputFile = '/Volumes/SAPNA/171010_bCat_reporterCells_liveCellImaging/outputFigure2.mat';

%%
rA1 = rA.betaCatenin.individualColonies_values;
rA1 = permute(rA1, [3 2 1]);
%%
Fig9C.betaCatenin.radialProfile = rA1;
Fig9C.betaCatenin.threshold = 0.6354;
Fig9C.betaCatenin.timeInHrs = rA.betaCatenin.timeInHrs;
%%
rA2 = rA.brachyury.individualColonies_values';
Fig9C.brachyury = rA2;
Fig9C.bins = rA.bins;
%%

saveInPath = '/Volumes/sapnaDrive2/190713_FiguresData/Figure9.mat';
save(saveInPath, 'Fig9C', '-append');
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------

saveInPath = '/Volumes/sapnaDrive2/190713_FiguresData/Figure3.mat';

Fig3D.betaCatenin.radialProfile = rA1;
Fig3D.betaCatenin.threshold = 0.6354;
Fig3D.betaCatenin.timeInHrs = rA.betaCatenin.timeInHrs;
Fig3D.betaCatenin.radialProfileAverage = rA.betaCatenin.coloniesAverage_values;
Fig3D.bins = rA.bins;

save(saveInPath, 'Fig3D');
%%

