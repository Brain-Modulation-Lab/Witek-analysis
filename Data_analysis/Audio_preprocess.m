%dataFN = 'datafileRC021616_MER_Left0001';
%spikeFN = 'RC021616_Left_CS02_Post.txt';
%electrodeNum = 2;
%sampRate = 30000;
%Vraw_sampRate = 44000;
subjectInfo;
load(recFN);

idx=2; %index of the trial set you want to look at
EventTimes = sort([Rec(idx).DigUp Rec(idx).DigDown]);
[EventTimesTrellis] = GetEventData([dataFN '.nev']);

figure; plot(EventTimesTrellis*[1 1], [-1 1])
% Look at the event times and decide where which you want to look at
cutoff_times = [4000 2500 1500 800];

Event0 = EventTimesTrellis(find(EventTimesTrellis>cutoff_times(idx),1,'first'));

tstart= Event0 - EventTimes(1);
tend = tstart + length(Rec(idx).Vraw.ts)/44000;

[~, AudioFull, AnalogElectrodeIDs] = GetAnalogData([dataFN '.ns5'], sampRate, 10269, [], []);
Audio = AudioFull(round(tstart*30000):round(tend*sampRate));
timeFull = (0:(length(AudioFull)-1))/sampRate;
time = timeFull(round(tstart*30000):round(tend*sampRate));

SkipEvents = 2;
AudioEnv = abs(hilbert(highpassfilter(double(Audio),sampRate,100)));
AudioEnv = smooth(AudioEnv,1500); %50 ms

%% Do the audio analysis/ selection of audio start times
%AudioAnalysis;
AutoAudioOnsetMarking;
%% Save events/times to the Rec structure
Rec(idx).tstart = tstart;
Rec(idx).tend = tend;
Rec(idx).AudioStart = AudioStart;
Rec(idx).EventTimes = EventTimes;
Rec(idx).SkipEvents = SkipEvents;
Rec(idx).ResponseTimes = ResponseTimes;

%% Read in the associated spike time data

spikeTimes = readSpikeTimes(spikeFN);
nUnits = max(unique(spikeTimes(:,1)));
V = Rec(idx).Vraw.ts; % Raw waveforms
timeFull = (0:(size(V,2)-1))/sampRate; %timeseries
figure; ah = axes();
for i=1:nUnits
    ts = spikeTimes(spikeTimes(:,1) == i, 2);
    spikeInd = round(ts*Vraw_sampRate);
    spikeWind = -20:80;
    y = zeros(length(spikeInd), length(spikeWind));
    for j = 1:length(spikeInd)
        y(j,:) = V(electrodeNum, spikeWind+spikeInd(j)) - V(electrodeNum, spikeInd(j));
        %line(spikeWind./Vraw_sampRate, y, 'Color', 'k');
    end
    plotSpikeWaveform(spikeWind./Vraw_sampRate, y, ah);
    
    %UnitResponse(time, ts, Vraw_sampRate, [], EventTimes, 4);
    %getAudioResponse;
end

