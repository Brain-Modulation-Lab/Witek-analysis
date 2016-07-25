function [C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr] = SpikeFieldStimulus(StimulusTimes, Trial, TrialTypes, TrialNum, LFP, D, movingwin, params)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sf = 1000;
pre = 2.5;
post = 2.5;

AndTypes = regexp(TrialTypes,'\&','split');

OrTypes = regexp(AndTypes{1},'\|','split');
ind = Trial.(OrTypes{1});
for j = 1:length(OrTypes)
    ind = union(ind, Trial.(OrTypes{j}));
end

ind=Trial.(AndTypes{1});

for i = 1:length(AndTypes)
    OrTypes = regexp(AndTypes{i},'\|','split');
    Orind = Trial.(OrTypes{1});
    for j = 1:length(OrTypes)
        Orind = union(Orind, Trial.(OrTypes{j}));
    end
    ind = intersect(ind, Orind);
end
SelectedTimes = StimulusTimes(ind(ind<=TrialNum));
SelectedSamples = round(30000*SelectedTimes);

LFP = highpassfilter(LFP, 1000, 1);
for i = 1:length(SelectedTimes)
    LFPtrials(:,i) = LFP((round(SelectedSamples(i)/30)-sf*pre):(round(SelectedSamples(i)/30)+sf*post));
    spike(i).spiketimes = find(D((SelectedSamples(i)-30000*pre):(SelectedSamples(i)+30000*post))~=0)'./30000;
end
figure; hold on;
for i=1:length(SelectedTimes)
plot((1:length(LFPtrials))/1000-pre, LFPtrials(:,i)-200*(i-1), 'k');
plot(spike(i).spiketimes*[1 1]-pre, -[200*(i-1)+20 200*(i-1)-20], 'r');
end
[C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr]=cohgramcpt(LFPtrials,spike,movingwin,params);

end

