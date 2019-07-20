function peaks = runmaskone(paramfile, sample_num, position_num, object_num)
%%
% samplenum: Every different condition - be it in a different chip or
% different dish represents a different sample.
% position_num: corresponding montage value for the image.
% objnum: cell number for which you want to check no. of mRNA's assigned (for
% eg: if your raw image has around 20 different cells, then objno could be
% anywhere between 1 and 20.

global userParam
eval(paramfile);

ff = readFISHdir(userParam.dapi_images, userParam.nsamples);


if(ff.positions(sample_num)< position_num)
    error('Error. Invalid position number. Try again!');
else
    nzslices = ff.zslices{sample_num}(position_num);
    nuc_ch = userParam.nuclear_channel;
    [pnuc, inuc] = readmaskfilesnew(userParam.ilastik_Pmasks, userParam.dapi_images, sample_num, position_num-1,  nzslices-1, nuc_ch);
    
    %%
    pmasks = primaryfilter(pnuc,userParam.logfilter, userParam.bthreshfilter, userParam.diskfilter, userParam.area1filter);
    %%
    
    [zrange, smasks] = secondaryfilter(pmasks, userParam.minstartobj, userParam.minsolidity, userParam.diskfilter, userParam.area2filter);
    
    %%
    if (zrange)
        %%
        zmatch = nzslices-1;
        [PILsn,PILsSourcen, CC, masterCCn, stats, nucleilist, zrange] = traceobjectszdistinct(smasks, userParam.matchdistance, zrange, zmatch);
        
        [nucleilist, masterCC] =  overlapfilter(PILsn, PILsSourcen, masterCCn, nucleilist, inuc, zrange, userParam.overlapthresh, userParam.imviews);
        
        %%
        masklabel{position_num} = masklabel3d(CC,nucleilist, zrange, nzslices);
        
        frame_num = sum(ff.positions(1:sample_num-1)) + position_num;
        [peaks1{position_num}, ~] = mrnapercells(nucleilist, stats, userParam.spatzcells_output, frame_num, zrange, userParam.channels, userParam.cmcenter, masklabel{position_num});
        %%
        
        %%
        peaks{position_num} = peakscelltrackerformat(peaks1{position_num});
        if (~exist('object_num', 'var'))
            object_num = 5;
        end
        nucleimrnacheck(masterCC, inuc, zrange, peaks{position_num}, frame_num, object_num, userParam.channels, userParam.spatzcells_output, userParam.cmcenter, masklabel{position_num});
        
    else
        peaks{position_num} = [];
        error('Error. \No cells found! Try another sample.')
    end
    
end
%%

