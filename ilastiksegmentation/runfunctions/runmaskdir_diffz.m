function runmaskdir_diffz(paramfile)
%%
tic;
global userParam
eval(paramfile);
mkdir (userParam.output_table);


ff = readFISHdir(userParam.dapi_images, userParam.nsamples);
nuc_ch = userParam.nuclear_channel;

if(userParam.imsave)
    for i = 1:numel(userParam.channels)
        newfolder = strcat(userParam.output_images, filesep, sprintf('channel%01d', userParam.channels(i)));
        mkdir(newfolder);
    end
end

nsamples = numel(ff.samples);


for sample_num = 1:nsamples
    
    npositions = ff.positions(sample_num);
    
    clear peaks1 peaks spotsinfo masklabel;
    %for pos = 2;
    for ii = 1:npositions
        nzslices = ff.zslices{sample_num}(ii);
        
        
        [pnuc, inuc] = readmaskfilesnew(userParam.ilastik_Pmasks, userParam.dapi_images, sample_num, ii-1,  nzslices-1, nuc_ch);
        %%
        
        pmasks = primaryfilter(pnuc,userParam.logfilter, userParam.bthreshfilter, userParam.diskfilter, userParam.area1filter);
        %%
        
        [zrange, smasks] = secondaryfilter(pmasks, userParam.minstartobj, userParam.minsolidity, userParam.diskfilter, userParam.area2filter);
        
        if (zrange)
            %%
            zmatch = nzslices-1;
            [PILsn,PILsSourcen, CC, masterCCn, stats, nucleilist, zrange] = traceobjectszdistinct(smasks, userParam.matchdistance, zrange, zmatch);
            %%
            
            if(zrange)
                [nucleilist, masterCC] =  overlapfilter(PILsn, PILsSourcen, masterCCn, nucleilist, inuc, zrange, userParam.overlapthresh, userParam.imviews);
                
                %%
                masklabel{ii} = masklabel3d(CC,nucleilist, zrange, nzslices);
                
                framenum = sum(ff.positions(1:sample_num-1)) + ii;
                
                
                [peaks1{ii}, spotsinfo{ii}] = mrnapercells(nucleilist, stats, userParam.spatzcells_output, framenum, zrange, userParam.channels, userParam.cmcenter, masklabel{ii});
                %%
                peaks{ii} = peakscelltrackerformat(peaks1{ii});
                
                if(userParam.imsave)
                    nucleimrnasave(masterCC, inuc, zrange, peaks{ii}, framenum, sample_num, ii-1, userParam.channels,  userParam.cmcenter, userParam.spatzcells_output, userParam.output_images);
                end
                
                
                if(userParam.fluorescent_protein)
                    if(sample_num ~= userParam.negativecontrol)
                        peaks{ii} = assignproteinvalues(nucleilist, nzslices, userParam.fluorescent_protein, sample_num, ii-1, userParam.pchannel, inuc, peaks{ii}, masklabel{ii});
                    end
                end
            end
        else
            peaks{ii} = [];
            masklabel{ii} = [];
            spotsinfo{ii} = 0;
        end
        
        %%
        
        
        
    end
    
    outfile = strcat(userParam.output_table, filesep, sprintf('sample%02dout.mat', sample_num));
    save(outfile, 'peaks', 'spotsinfo', 'masklabel');
end
toc;