
%get Force data
tstart= 0; %start of task
tend= 0; %end of task
fs=1000;

[time1kHz, Force, AnalogElectrodeIDs] = GetAnalogData('datafileRSintraop0002.ns2', fs, [10241 10242]);
figure; plot(time1kHz, Force)
ForceRS8=Force(fs*tstart:fs*tend,:);
time1kHzRS8=time1kHz(fs*tstart:fs*tend)-tstart;
figure; plot(time1kHzRS8, ForceRS8);

%get response times
[ResponseBlockTime, LeftResponseTimes, LeftForceResponseBlock] = MotivationTaskResponseTrig(ForceRS8(:,1), 100, 2.5, 2.5, sf);
[ResponseBlockTime, RightResponseTimes, RightForceResponseBlock] = MotivationTaskResponseTrig(ForceRS8(:,2), 100, 2.5, 2.5, sf);
hold on; plot((1/sf)*LeftResponseTimes*[1 1], ylim, 'b')
hold on; plot((1/sf)*RightResponseTimes*[1 1], ylim, 'g')

%get neural S.U. data
fs=30000;
[time, V, AnalogElectrodeIDs] = GetAnalogData('datafileRSintraop0002.ns5', fs, [10244]);
VRS8=V(fs*tstart:fs*tend);

figure; plot(VRS8)

%discriminate spike
HRS8 = find_max(VRS8);
DRS8 = discriminate(HRS8, 500, 1);
DRS8 = enforce_minISI(DRS8, 30000, 0.5);
indRS8 = find(DRS8~=0);
[WRS8, ~, ~] = waveform(VRS8, indRS8, sf, 0.5, 0.5, '');
figure; [indRS8, DRS8] = DiscrimWaveform( WRS8, indRS8, DRS8 );
figure; plot(VRS8)
hold on; plot(indRS8*[1 1], ylim, 'r')


for i = 1:length(RightResponseTimes)
VVRS8(:,i) = VRS8(30*(RightResponseTimes(i)-2.5*1000):30*(RightResponseTimes(i)+2.5*1000));
DDRS8(:,i) = DRS8(30*(RightResponseTimes(i)-2.5*1000):30*(RightResponseTimes(i)+2.5*1000));
end
[t, Nbin, z, h] = raster(VVRS8, DDRS8, 30000, size(DDRS8,2), 2.5, 5, 2.5, 60, 'Right Motor Responses');
for i = 1:length(LeftResponseTimes)
VVRS8L(:,i) = VRS8(30*(LeftResponseTimes(i)-2.5*1000):30*(LeftResponseTimes(i)+2.5*1000));
DDRS8L(:,i) = DRS8(30*(LeftResponseTimes(i)-2.5*1000):30*(LeftResponseTimes(i)+2.5*1000));
end
[t, Nbin, z, h] = raster(VVRS8L, DDRS8L, 30000, size(DDRS8L,2), 2.5, 5, 2.5, 60, 'Left Motor Responses');


[EventTimes] = GetEventData('datafileRSintraop0002.nev');
[time1kHz, Force, AnalogElectrodeIDs] = GetAnalogData('datafileRSintraop0002.ns2', 1000, [10241 10242]);
figure; plot(time1kHz, Force)
EventTimesRS8 = EventTimes(find(EventTimes>400,[],'first'):find(EventTimes<750,[],'last'));
find(EventTimes>400,[],'first')
find(EventTimes>400,1,'first')
EventTimesRS8 = EventTimes(find(EventTimes>400,1,'first'):find(EventTimes<750,1,'last'));
EventTimesRS8 = EventTimes(find(EventTimes>400,1,'first'):find(EventTimes<750,1,'last'))-400;
figure; plot(time1kHzRS8, ForceRS8)
hold on; plot((1/sf)*LeftResponseTimes*[1 1], ylim, 'b')
hold on; plot((1/sf)*RightResponseTimes*[1 1], ylim, 'g')
hold on; plot(EventTimesRS8*[1 1], ylim, 'k')
[CueStimulusTimes, CueTrial, CueTrialNum] = MotivationTaskStimulusBlock(EventTimesRS8, 4, 4, 1, 'BilateralDelayMotivationTaskIntraopRSintraop8');
[CueStimulusTimes, CueTrial, CueTrialNum] = MotivationTaskStimulusBlock(EventTimesRS8, 4, 4, 1, BilateralDelayMotivationTaskIntraopRSintraop8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Right&Go', VVRS8L, DDRS8L);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Right&Go', VRS8L, DRS8L);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Right&Go', VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Left&Go', VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Right&Go', VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Left&Go', VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Left&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Lose&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Left&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Win&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Lose&Left&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(CueStimulusTimes, CueTrial, 'Correct&Lose&Right&Go', TrialNum, VRS8, DRS8);
[GoStimulusTimes, GoTrial, TrialNum] = MotivationTaskStimulusBlock(EventTimesRS8, 4, 4, 2, BilateralDelayMotivationTaskIntraopRSintraop8);
DisplayStimulus(GoStimulusTimes, GoTrial, 'Correct&Win|Lose|*&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(GoStimulusTimes, GoTrial, 'Correct&Win|Lose|Squeeze&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(GoStimulusTimes, GoTrial, 'Correct&Win|Lose|Squeeze&Left&Go', TrialNum, VRS8, DRS8);
[FeedbackStimulusTimes, FeedbackTrial, TrialNum] = MotivationTaskStimulusBlock(EventTimesRS8, 4, 4, 3, BilateralDelayMotivationTaskIntraopRSintraop8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Win|Lose|Squeeze&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Win|Lose|Squeeze&Left&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Win&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Lose&Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Lose&Left|Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Win&Left|Right&Go', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Lose&Left|Right', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Win&Left|Right', TrialNum, VRS8, DRS8);
DisplayStimulus(FeedbackStimulusTimes, FeedbackTrial, 'Correct&Win', TrialNum, VRS8, DRS8);
save('analysis RS0003', '-v7.3')