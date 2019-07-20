
function tmp1 =  soliditycombine(tmp1, lchk, overlap, zlim)

%% this function adds unique objects having lower solidity to the corresponding frames with higher solidity.


for z1 = zlim
    
    clear o21 pxlmat r c
    o21 = tmp1{2}{z1}-tmp1{1}{z1}; % objects identified only in image2 (sol = 0.8)
    z=z1+1;
    obj = bwconncomp(o21);
    nobj = obj.NumObjects;
    
    %%
    while nobj>0 && z<z1+lchk && z<zlim(end)
        
        obj = bwconncomp(o21); % new objects in im2 (sol = 0.8)
        nobj = obj.NumObjects;
        
        obj1 = bwconncomp(tmp1{1}{z}); % objects in im1 (sol = 0.9)
        nobj1 = obj1.NumObjects;
        
        % pxl overlap matrices
        pxlmat{1} = zeros(nobj, nobj1);
        pxlmat{2} = pxlmat{1}';
        m = 1;
        
        for i = 1:nobj
            for j = 1:nobj1
                
                pxlmat{1}(i,j) = nnz(ismember(obj.PixelIdxList{i}, obj1.PixelIdxList{j}))/numel(obj.PixelIdxList{i});
                pxlmat{2}(j,i) = nnz(ismember(obj.PixelIdxList{i}, obj1.PixelIdxList{j}))/numel(obj1.PixelIdxList{j});
                
            end
        end
        
        %%
        % Selecting required overlap
        for i = 1:2
            [r{i}, c{i}] = find(pxlmat{i} > overlap);
        end
        
        %%
        % If there is a overlap, set the pixel values corresponding to the new
        % object as 0.
        
        if(size(r{1},2) < size(r{1},1))
            rnew = r{1}';
        else
            rnew = r{1};
        end
        
        if (size(c{2},2)<size(c{2},1))
            cnew = c{2}';
        else
            cnew = c{2};
        end
        
        oobj = unique([rnew cnew]);
        if(~isempty(oobj))
            for i = oobj
                o21(obj.PixelIdxList{i}) = 0;
            end
        end
        z= z+1;
    end
    
    %%
    objadd = bwconncomp(o21);
    for i = 1:objadd.NumObjects
        tmp1{1}{z1}(objadd.PixelIdxList{i}) = 1;
    end
end

end
