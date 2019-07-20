function cellMovementSimulation_turningAngles_clusterRunFile (jobScriptsPath, outputFile1, outputFile2_path, nTimes, nCells)
%% runs the cell movement simulation model, nTimes (20 cells/time) on the cluster
% file that submits jobs

for ii = 1:nTimes
    outputFile2 = [outputFile2_path filesep 'file' int2str(ii), '.mat'];
    
    scriptfile = [jobScriptsPath filesep 'jobscripts' filesep 'jobcl' int2str(ii) '.slurm'];
    fid = fopen(scriptfile,'w');
    fprintf(fid, '#!/bin/bash \n');
    fprintf(fid,['#SBATCH --job-name=job' int2str(ii) '\n']);
    fprintf(fid, '#SBATCH --ntasks=1 \n');
    fprintf(fid,'#SBATCH --partition=commons\n');
    fprintf(fid,'#SBATCH --mem-per-cpu=8G \n');
    
    fprintf(fid,'#SBATCH --time=02:00:00 \n');
    
    fprintf(fid,'#SBATCH --mail-type ALL \n');
    fprintf(fid,'#SBATCH --mail-user sc65@rice.edu \n');
    fprintf(fid, '#SBATCH --account=commons \n');
    fprintf(fid, 'echo "My job ran on:" \n');
    fprintf(fid, 'cat $SLURM_NODELIST \n');
    
    %fprintf(fid, ['matlab -nodisplay -r "runMeinhartSimple2DCircleCluster(''' saveInPath ''', ''' paramfile ''', ' int2str(jj) '); quit"']);
    fprintf(fid, ['matlab -nodisplay -r "cellMovementSimulation_constantVperCell_changingturningAngles(''' outputFile1 ''', ''' outputFile2 ''', ' int2str(nCells) '); quit"']);
    fclose(fid);
    system(['sbatch ' scriptfile]); 
end