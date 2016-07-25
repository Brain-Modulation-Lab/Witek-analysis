
if(isvarname('tstart') && isvarname('tend') && isvarname('RecID') && isvarname('Force') && isvarname('fs') && isvarname('time1kHz'))

eval(['Force',RecID,'=Force(fs*tstart:fs*tend,:);']);
eval(['time1kHz',RecID,'=time1kHz(fs*tstart:fs*tend)-tstart;']);
eval(['figure; plot(time1kHz',RecID,', Force',RecID,');']);
eval(['[ResponseBlockTime, LeftResponseTimes, LeftForceResponseBlock] = MotivationTaskResponseTrig(Force',RecID,'(:,1), 100, 2.5, 2.5, fs);']);
eval(['[ResponseBlockTime, RightResponseTimes, RightForceResponseBlock] = MotivationTaskResponseTrig(Force',RecID,'(:,2), 100, 2.5, 2.5, fs);']);
hold on; plot((1/fs)*LeftResponseTimes*[1 1], ylim, 'b')
hold on; plot((1/fs)*RightResponseTimes*[1 1], ylim, 'g')

else
    fprintf('Following variables needed: \n\ttstart\n\tend\n\tRecID\n\tForce\n\tfs\n\ttime1kHz');
end
