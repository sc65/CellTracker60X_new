
function peaks = addmRNA(peaks, nuclearMask1,  spotMasks, rawImages, oneSpotIntensities)

%% check if the spots lie on the nuclei - Assign them to those nuclei. % Else, assign to the closest nuclei.

%%
% Get the pixel indices of all spots.

channels = size(spotMasks,3);
maxMinDist = 100; %in pixels.

nZslices = size(spotMasks,4);

for ch = 1:channels
    startColumn = size(peaks,2)+1;
    
    for zz = 1:nZslices
        spotMask = logical(spotMasks(:,:,ch,zz));
        stats = regionprops(spotMask, 'PixelIdxList');
        
        if size(stats,1) > 0
            spotIndices = cat(1, stats.PixelIdxList)';
            
            spotsInNuclei = spotIndices(nuclearMask1(spotIndices) > 0); %spots that overlay the nuclear mask.
            spotsOutsideNuclei = setxor(spotIndices, spotsInNuclei); %spots outside nucleus
            
            im1 = rawImages(:,:,ch,zz); %raw image corresponding to the channel.
            ncells = size(peaks,1);
            
            % assign the spots outside the nuclei to the cell closest (distance < maxMinDist) to it.
            %get linear indices.
            [y1, x1] = ind2sub([1024 1024], spotsOutsideNuclei);
            
            %get the distances of these points from the centers of cells
            cellCenters = peaks(:,1:2);
            distances = distmat([x1',y1'], cellCenters);
            
            %closest cells.
            [minDistance, assignTo] = min(distances,[],2);
            assignTo(minDistance > maxMinDist,:) = 0;
            
            for i = 1:ncells
                spotsInNucleiIdx =  spotIndices(nuclearMask1(spotIndices) == i);
                intensity1 = sum(im1(spotsInNucleiIdx)); %intensity of spots inside nuclei
                if zz == 1
                    peaks(i, startColumn) = intensity1/oneSpotIntensities(ch); %
                else
                    peaks(i, startColumn) = peaks(i, startColumn)+ intensity1/oneSpotIntensities(ch);
                end
                
                intensity2 = 0; %intensity of spots outside nuclei
                if (sum(assignTo == i) > 0)
                    spotsOutsideNucleiIdx = spotsOutsideNuclei((assignTo == i)');
                    intensity2 = sum(im1(spotsOutsideNucleiIdx));
                end
                if zz == 1
                    peaks(i, startColumn+1) = intensity2/oneSpotIntensities(ch); %
                else
                    peaks(i, startColumn+1) = peaks(i, startColumn)+ intensity2/oneSpotIntensities(ch);
                end
                
            end
        end
    end
end
