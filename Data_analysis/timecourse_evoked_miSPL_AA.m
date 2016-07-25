function [timecourse] = timecourse_evoked_miSPL_AA(LFP, fs, SpikeTimes, SelectedTimes, fq, nbin, niter, prespike, postspike )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

SpikeTimes=round(SpikeTimes.*fs);
for timeblocks=1:10
    
    t1=clock;
    
    tstart = (timeblocks-1)/2-2.5;
    tend = (timeblocks+1)/2-2.5;
    
    fprintf('time segment %d - %d...  ', tstart, tend);
    
    ts_stamps=[];
    for i=1:length(SelectedTimes)
        sample_stamps = SpikeTimes(SpikeTimes>=(SelectedTimes(i)+tstart*fs) & SpikeTimes<(SelectedTimes(i)+tend*fs));
        ts_stamps=[ts_stamps; sample_stamps];
    end
    ts_stamps=ts_stamps./fs;
    [ mi, zmi, pmi, phase_hist ] = miSPL_AA( LFP, fs, ts_stamps, fq, nbin, niter, prespike, postspike );
    timecourse(timeblocks).mi = mi;
    timecourse(timeblocks).phase_hist = phase_hist;
    timecourse(timeblocks).zmi = zmi;
    timecourse(timeblocks).pmi = pmi;
    
    t2=clock;
    
    fprintf('completed in %d minutes.\n', etime(t2,t1)/60);
    
end

end