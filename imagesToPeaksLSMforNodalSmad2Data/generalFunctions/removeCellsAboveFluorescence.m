function plate1 = removeCellsAboveFluorescence(plate1, goodColonies, columnNum, fluorescence)
%%

for ii = goodColonies
    if iscell(plate1)
        data = plate1{ii};
    else
        data = plate1.colonies(ii).data;
    end
    
    if columnNum >5
        dataToConsider = data(:,columnNum) + data(:,columnNum+1); %adding cytoplasmic values.
    else
        dataToConsider = data(:,columnNum);
    end
    data(dataToConsider > fluorescence, :) = [];
    
    if iscell(plate1)
        plate1{ii} = data;
    else
        plate1.colonies(ii).data = data;
    end
end

end


