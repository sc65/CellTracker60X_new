
function rmsVelocity = findRMSvelocity(allstats, territory, timeLag, avgOvercells)
%% How does the root mean square velocity of cells change in 10 hours.
%find the root mean square velocity for all cells in the given territory.
%returns rms velocity (um/timestep)

umtopixel = 1.55;
territories = [0 71 252 400]; %distance from the edge(in microns) for individual territories. 
ii = territory;
mindistance = territories(ii)*umtopixel;
maxdistance1 = territories(ii+1)*umtopixel;
%select cells whose distance from the edge fall between mindistance and
%maxdistance at t0.
distance_from_edge_t0 = squeeze(allstats(1,4,:));
condition_to_satisfy = distance_from_edge_t0 > mindistance & distance_from_edge_t0 < maxdistance1;
cells_in_territory = allstats(:,:, condition_to_satisfy);
counter = 1;
for jj = 1:timeLag:size(allstats,1)-timeLag %iterate over all time points to see how the rms displacement changes.
    t1 = jj;
    t2 = jj+timeLag;
    displacement(:,counter) = findDisplacementfromAllstats(cells_in_territory, t1, t2); %how far do individual cells move from t1 to t2?   
    counter = counter+1;
end
timeSteps = counter-1;
displacement = displacement./umtopixel;
velocity = displacement./timeLag; %per timestep
if avgOvercells == 1
 meanSquareVelocity = sum(velocity.^2,1)./size(displacement,1); %for every timepoint average over cells. 
else
meanSquareVelocity = sum(velocity.^2,2)./timeSteps; %for every cell, average over timepoints. 
end
rmsVelocity = sqrt(meanSquareVelocity);
