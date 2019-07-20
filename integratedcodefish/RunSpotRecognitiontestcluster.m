%% Run full spot recognition
function RunSpotRecognitiontestcluster(direc,paramfile, samplenum, framenum)
% direc = path where raw images and masks are saved.
% framenum = position within samplenum that you want to test the threshold for.

global userparam;
eval(paramfile);
nch = userparam.nch;
z1 = userparam.z1;
pos = userparam.pos;
sn = userparam.sn;
sname = userparam.sname;
dir1 = direc;
framenum = framenum-1;


%% 0. Initialize general experiment parameters
ip      = InitializeExptest(dir1, z1, pos, sn, sname);
channel = nch; % fluorescence channel for spot counting

%% 1. Check Spot recognition parameters

df1             = sprintf('/spotsquantify_ch%d/', nch);
spot_folder     = [ip.exp.path df1];
mkdir(spot_folder);
tic;

for n_sample = samplenum
    for n_image =  framenum % the corresponding frame number
        n_frame = ip.exp.splimg2frm(n_sample,n_image+1);
        
        % display time progression
        time = toc;
        hours = floor(time/3600);
        minutes = floor(time/60) - 60*hours;
        seconds = floor(time - 60*minutes - 3600*hours);
        
        progress_ = [...
            sprintf('\n') 'SPOT RECOGNITION. FRAME ' num2str(n_frame,'%4d')...
            ' of ' num2str(ip.exp.totalframes,'%4d') '. Elapsed time = ' ...
            num2str(hours,'%02d') 'hr:' ...
            num2str(minutes,'%02d') 'min:' ...
            num2str(seconds,'%02d') 'sec'] ;
        fprintf(1,progress_) ;
        
        
        sr = InitializeSpotRecognitionParameterstest(ip,n_frame,channel,spot_folder, z1(n_frame));
        peakdata = spatzcellstest(sr);
        save([sr.output 'peakdata' num2str(n_frame,'%03d') '.mat'],'peakdata');
        
    end   
end