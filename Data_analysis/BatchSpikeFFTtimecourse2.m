function [spikefq, SpikeFFT] = BatchSpikeFFTtimecourse2()

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

dat_files = dir('*.mat');
fq=[1 50];
window = 0.5;

fs=1000;


for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    S = load(filename, 'RecID', 'qts', 'fs', 'RecSide', 'SPLtrial');
    fprintf('%s\n', S.RecID);
    
%     if strcmp(S.RecID,'MK01_1')
%        disp(S.RecID)
%     end
    
    for ep=1:length(epochs1)
        fprintf('  time epochs %d - %d...\n', epochs1(ep), epochs2(ep));
        trial_idx = 0;
        for trial=1:length(S.SPLtrial.Left)
            
            ts=[];
            if ep==1
                t1 = S.SPLtrial.Left(trial).epoch(epochs2(ep)) - 1.0;
            else
                t1 = S.SPLtrial.Left(trial).epoch(epochs1(ep));
            end
            t2 =  S.SPLtrial.Left(trial).epoch(epochs2(ep));
            if round(fs*(t2-t1)) < window
                t2 = t1 + window/fs;
                fprintf('Warning: epoch too short (%d)...\n', round(fs*(t2-t1)));
            end
            ts = S.qts(S.qts>=t1 & S.qts<t2);
            if length(ts)>1
                trial_idx = trial_idx+1;
                [spikefq, ~, spikefft_norm, ~, ~] = spike_fft(ts, S.fs, [], window, fq);
                spikefft_norm_trial(:,trial_idx) = spikefft_norm;
            end
        end

        sfft_norm_L = mean(spikefft_norm_trial, 2);
        sfft_thresh_L = 1 + 2*std(sfft_norm_L(findfreq(300,500,spikefq)));

        trial_idx = 0;
        for trial=1:length( S.SPLtrial.Right)
            
            ts=[];
            if ep==1
                t1 = S.SPLtrial.Right(trial).epoch(epochs2(ep)) - 1.0;
            else
                t1 = S.SPLtrial.Right(trial).epoch(epochs1(ep));
            end
            t2 = S.SPLtrial.Right(trial).epoch(epochs2(ep));
            if round(fs*(t2-t1)) < window
                t2 = t1 + window/fs;
                fprintf('Warning: epoch too short (%d)...\n', round(fs*(t2-t1)));
            end

            ts = S.qts(S.qts>=t1 & S.qts<t2);
            if length(ts)>1
                trial_idx = trial_idx+1;
                [spikefq, ~, spikefft_norm, ~, ~] = spike_fft(ts, S.fs, [], window, fq);
                spikefft_norm_trial(:,trial_idx) = spikefft_norm;
            end
        end
        sfft_norm_R = mean(spikefft_norm_trial, 2);
        sfft_thresh_R = 1 + 2*std(sfft_norm_R(findfreq(300,500,spikefq)));

        if S.RecSide == 1
            SpikeFFT(i).ipsi(ep).sfft_norm = sfft_norm_L;
            SpikeFFT(i).ipsi(ep).sfft_thresh = sfft_thresh_L;
            SpikeFFT(i).contra(ep).sfft_norm = sfft_norm_R;
            SpikeFFT(i).contra(ep).sfft_thresh = sfft_thresh_R;
        else
            SpikeFFT(i).ipsi(ep).sfft_norm = sfft_norm_R;
            SpikeFFT(i).ipsi(ep).sfft_thresh = sfft_thresh_R;
            SpikeFFT(i).contra(ep).sfft_norm = sfft_norm_L;
            SpikeFFT(i).contra(ep).sfft_thresh = sfft_thresh_L;
        end

    end
  
end

end