function [timecourse] = timecourse2_evoked_plfSPL_TW(ph, SpikeTimes, TrialEpochs, fs, fq, nbin, niter, prespike, postspike)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% TrialEpochs
% 1 - preFeedback
% 2 - preITI
% 3 - Cue
% 4 - Command
% 5 - ForceResponseStart
% 6 - ForceResponseEnd
% 7 - Feedback
% 8 - postITI

epochs1 = [2 3 5 6];
epochs2 = [3 4 6 8];

t=0;
for ep=1:length(epochs1)
    
    tstart=clock;
    
    t = t+1;

    fprintf('time epochs %d - %d...  ', epochs1(ep), epochs2(ep));
    
    ts_stamps=[];
    for trial=1:length(TrialEpochs)
        if ep==1
            t1 = TrialEpochs(trial).epoch(epochs2(ep)) - 1.0;
        else
            t1 = TrialEpochs(trial).epoch(epochs1(ep));
        end
        t2 = TrialEpochs(trial).epoch(epochs2(ep));
        sample_stamps = SpikeTimes(SpikeTimes>=t1 & SpikeTimes<t2);
        ts_stamps=[ts_stamps; sample_stamps];
    end
    
    [sfc,stats]=SpikeLockPhase(ph, round(fs*ts_stamps), fs, prespike, postspike,  1,1, nbin, niter, 1);
    zplf = (sfc.PLFamp-stats.PLFmu)./stats.PLFsd;
    blobplf = param_cluster_sig(zplf, stats.surr);

    timecourse(t).sfc = sfc;
%     timecourse(t).stats = stats;
    timecourse(t).zplf = zplf;
    timecourse(t).blobplf = blobplf;

    tend=clock;
    
    fprintf('completed in %d seconds.\n', round(etime(tend,tstart)));
    
end

end