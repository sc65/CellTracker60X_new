
function newImage = makeImageSizeX(image1, size1)
%% changes image1 size to size1

newImage = uint16(zeros(size1(1), size1(2)));
diff = size1 - size(image1);

if sum(diff)>0
    pads = [diff(1)/2, diff(1)/2, diff(2)/2, diff(2)/2];
    idx = find(mod(pads,1)~=0);
    if ~isempty(idx)
        for jj = 1:numel(idx)/2
            pads(idx(jj)) = pads(idx(jj))+0.5;
            pads(idx(jj)+1) =  pads(idx(jj)+1) - 0.5;
        end
    end
    if diff(1) == 0
        newImage(:, pads(3):pads(3)+size(image1,2)-1) = image1;
    elseif diff(2) == 0
        newImage(pads(1):pads(1)+size(image1,1)-1,:) = image1;
    else
        newImage(pads(1):pads(1)+size(image1,1)-1, pads(3):pads(3)+size(image1,2)-1) = image1;
    end
else
    newImage = image1;
end
end