function runRsemCluster(paramfile)

%% submit jobs to quantify star alignment output
%% start matlab in the working directory


global userParam;
eval(paramfile);

files = dir([userParam.rawData filesep '*_1.fq.gz']);
for ii = 1:numel(files)
    idx1 = strfind(files(ii).name, '_1.fq.gz');
    prefices{ii} = files(ii).name(1:idx1-1);
end

mkdir(userParam.rsemOutput);
mkdir(userParam.jobscripts);


for ii = 1:length(prefices)
    prefices{ii}
    
    scriptfile = [userParam.jobscripts filesep 'job' int2str(ii) '.slurm'];
    fid = fopen(scriptfile,'w');
    fprintf(fid, '#!/bin/bash \n');
    
    fprintf(fid,['#SBATCH --job-name=job' int2str(ii) '\n']);
    
    fprintf(fid, '#SBATCH --ntasks=1 \n');
    fprintf(fid,'#SBATCH --partition=commons\n');
    fprintf(fid,'#SBATCH --cpus-per-task=4 \n');
    fprintf(fid,'#SBATCH --mem-per-cpu=7G \n');
    fprintf(fid,'#SBATCH --time=04:00:00 \n');
    fprintf(fid,['#SBATCH -e errorLogQ' int2str(ii) '.err \n \n']);
    
    fprintf(fid,['cd ' userParam.workingDir '\n']);
    fprintf(fid,['pwd \n']);
    
    fprintf(fid, ['rSem=' userParam.RSEM '\n']);
    fprintf(fid, ['inputFile=' userParam.starOutput filesep prefices{ii} 'Aligned.toTranscriptome.out.bam \n']);
    fprintf(fid, ['genomeFile=' userParam.genomeIndexRSEM filesep userParam.genomeIndexRSEM  '\n']);
    fprintf(fid, ['outputFile=' userParam.rsemOutput filesep prefices{ii}  '\n']);
    
    fprintf(fid, '${rSem}/rsem-calculate-expression --bam --no-bam-output \\ \n');
    fprintf(fid, ['-p 4 --paired-end --forward-prob 0 ${inputFile} \\ \n']);
    fprintf(fid, ['${genomeFile} ${outputFile} \\ \n']);
    
    fprintf(fid, ['>& ${outputFile}_rsem.log']);
    
    fclose(fid);
    system(['sbatch ' scriptfile]);
end
