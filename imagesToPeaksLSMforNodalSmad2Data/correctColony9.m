function plate1 = correctColony9(plate1, coloniesToCorrect)
% find points corresponding to every shape.
% get the shape center.
% find the center that is closest to that ring.

alpha_radius = 30;
%%
%put the data points corresponding to first two shapes in colony 51,52.
% moidified for keeping cells out of circle, out of the colony.

for ii = coloniesToCorrect
    alldata = plate1.colonies(ii).data;
    xy = alldata(:,1:2);
    ashape = alphaShape(xy(:,1), xy(:,2), alpha_radius);
    pointsInShape =  xy(inShape(ashape,xy(:,1), xy(:,2), 1), :); %actual points in the colony - in shape 1
    figure; plot(pointsInShape(:,1), pointsInShape(:,2), 'k.'); title(['Colony' int2str(ii)]);
    dataInColony = alldata(ismember(alldata(:,1), pointsInShape(:,1)), :);
    dataInColony = dataInColony(ismember(dataInColony(:,2), pointsInShape(:,2)), :);
    plate1.colonies(ii).data = dataInColony;
end
%%
% for the next two shapes -: ring-shaped colonies,first find the cells that belong to the inner circle, then put
% all the data points in colonies 53 54.
% for jj = 1
%     pointsInRing = xy(inShape(ashape,xy(:,1), xy(:,2), jj),:);
%     ringCenter = mean(pointsInRing);
%     regions = numRegions(ashape);
%
%     for ii = 1:regions
%         pointsInside =  xy(inShape(ashape,xy(:,1), xy(:,2), ii),:);
%         if numel(pointsInside) > 10
%             pointsCenter= mean(pointsInside);
%             dist(ii) = pdist([ringCenter; pointsCenter], 'Euclidean');
%         else
%             dist(ii) = 0;
%         end
%     end
%     dist(dist == 0) = Inf;
%     shapeInside = find(dist == min(dist));
%     pointsInside = xy(inShape(ashape,xy(:,1), xy(:,2), shapeInside),:);
%
%     pointsInRing = [pointsInRing; pointsInside];
%     figure;
%     plot(pointsInRing(:,1), pointsInRing(:,2), 'k.');
%
%     dataInColony = alldata(ismember(alldata(:,1), pointsInRing(:,1)), :);
%     dataInColony = dataInColony(ismember(dataInColony(:,2), pointsInRing(:,2)), :);
%     plate1.colonies(colonyNum(jj)).data = dataInColony;
% end


