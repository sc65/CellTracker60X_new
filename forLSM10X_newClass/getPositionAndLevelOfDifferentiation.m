function [positions, thresholds] = getPositionAndLevelOfDifferentiation(colonies, idx, ch)

%% --- returns the position(back, front, peak) and level of differentiation
% (calculated for the top 20% rA value corresponding to channel ch)

%%
counter = 1;
positions = zeros(numel(idx),3); %size of front, back end
thresholds = zeros(numel(idx),1); %

bins = colonies(1).radialProfile.bins;
xValues = (bins(1:end-1)+bins(2:end))/2;

for ii = idx
    brachyury = colonies(ii).radialProfile.dapiNormalized.mean(ch,:);
    threshold = 0.8*max(brachyury);
    
    if threshold > 0.06 % proceed only if there is a peak
        line1 = [xValues; repmat(threshold, 1,numel(xValues))];
        line2 = [xValues; brachyury];
        p = InterX(line1, line2);
        positions(counter,1:2) = p(1,:);
        positions(counter,3) = xValues(brachyury == max(brachyury));
        thresholds(counter) = threshold;
        counter = counter+1;
        
    end
end
end