
if(isvarname('RecID'))
    
eval(['EventTimes',RecID,' = EventTimes(find(EventTimes>tstart,1,''first''):find(EventTimes<tend,1,''last''))-tstart;']);
eval(['figure; plot(time1kHz',RecID,', Force',RecID,')']);
hold on; plot((1/fs)*LeftResponseTimes*[1 1], ylim, 'b');
hold on; plot((1/fs)*RightResponseTimes*[1 1], ylim, 'g');
eval(['hold on; plot(EventTimes',RecID,'*[1 1], ylim, ''k'')']);
    
eval(['[CueStimulusTimes, CueStimulusDuration, CueTrial, TrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', 3, 4, 1, BilateralDelayMotivationTaskIntraopData);']);
eval(['[CommandStimulusTimes, CommandStimulusDuration, CommandTrial, TrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', 3, 4, 2, BilateralDelayMotivationTaskIntraopData);']);
eval(['[FeedbackStimulusTimes, FeedbackStimulusDuration, FeedbackTrial, TrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', 3, 4, 3, BilateralDelayMotivationTaskIntraopData);']);
eval(['[ITIStimulusTimes, ITIStimulusDuration, ITITrial, TrialNum] = MotivationTaskStimulusBlock(EventTimes',RecID,', 3, 4, 4, BilateralDelayMotivationTaskIntraopData);']);

for i = 1:length(CueStimulusTimes)
eval(['DD',RecID,'Cue(:,i) = D',RecID,'(round(30000*(CueStimulusTimes(i)-2.5)):round(30000*(CueStimulusTimes(i)+2.5)));']);
end
eval(['[t, Nbin, z, h] = raster(DD',RecID,'Cue, 30000, size(DD',RecID,'Cue,2), 2.5, 5, 2.5, 60, ''All Cue Times -- ',RecID,''');']);
for i = 1:length(CommandStimulusTimes)
eval(['DD',RecID,'Command(:,i) = D',RecID,'(round(30000*(CommandStimulusTimes(i)-2.5)):round(30000*(CommandStimulusTimes(i)+2.5)));']);
end
eval(['[t, Nbin, z, h] = raster(DD',RecID,'Command, 30000, size(DD',RecID,'Command,2), 2.5, 5, 2.5, 60, ''All Command Times -- ',RecID,''');']);
for i = 1:length(FeedbackStimulusTimes)
eval(['DD',RecID,'Feedback(:,i) = D',RecID,'(round(30000*(FeedbackStimulusTimes(i)-2.5)):round(30000*(FeedbackStimulusTimes(i)+2.5)));']);
end
eval(['[t, Nbin, z, h] = raster(DD',RecID,'Feedback, 30000, size(DD',RecID,'Feedback,2), 2.5, 5, 2.5, 60, ''All Feedback Times -- ',RecID,''');']);
for i = 1:length(ITIStimulusTimes)
eval(['DD',RecID,'ITI(:,i) = D',RecID,'(round(30000*(ITIStimulusTimes(i)-2.5)):round(30000*(ITIStimulusTimes(i)+2.5)));']);
end
eval(['[t, Nbin, z, h] = raster(DD',RecID,'ITI, 30000, size(DD',RecID,'ITI,2), 2.5, 5, 2.5, 60, ''All ITI Times -- ',RecID,''');']);

else
    fprintf('Following variables needed: \n\tRecID\n');
end
