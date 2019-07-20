
%% fate domains in a circular colony

rA_0 = rA_all{2}./maxRA;
%%

figure; plot(xValues, rA_0);
%%
t_values = rA_0(:,1);
%%
t_threshold = 0.5*(max(t_values) - min(t_values));
%%
cdx2_domain = [0:71];
t_domain = [71:200];
sox2_domain = [200:350];

cdx2_fraction = [cdx2_domain(end) - cdx2_domain(1)]/350
t_fraction = [t_domain(end) - t_domain(1)]/350
sox2_fraction = [sox2_domain(end) - sox2_domain(1)]/350
%%
 lattice = false(180);
 radius = 20;
 nSides = 1;
 
[~, ~, colonyState] = specifyColonyInsideLattice(lattice, radius, nSides);

edgeLength1 = cdx2_fraction*radius;
[~, colonyEdge1] = specifyRegionWithinColony(colonyState, edgeLength1);

edgeLength2 = (t_fraction+cdx2_fraction)*radius;
[~, colonyEdge2] = specifyRegionWithinColony(colonyState, edgeLength2);
%%
fates = lattice;
fates(colonyState) = 1;
%%
figure; imagesc(fates);
%%
fates = double(fates);
fates(colonyEdge1) = 100;
%%
fate2 = colonyEdge2 - colonyEdge1;
%%
fates(logical(fate2)) = 300;
%%
figure; imagesc(fates);