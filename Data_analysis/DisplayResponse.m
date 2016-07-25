function [h, SelectedTimes] = DisplayResponse(ResponseTimes, StimulusTimes, Trial, TrialTypes, latency, TrialNum, ts, Nsamples)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sf = 30000;
pre = 2.5;
post = 2.5;

D = zeros(Nsamples,1);
D(round(sf*ts)) = 1;

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
SelectedSamples = round(sf*SelectedTimes);

[RightResponseMatch, ~] = FindMismatch( ResponseTimes./1000, SelectedTimes', latency);

SelectedResponses = 30*ResponseTimes(RightResponseMatch);

for i = 1:length(SelectedResponses)
    DD(:,i) = D((SelectedResponses(i)-sf*pre):(SelectedResponses(i)+sf*post));
end

[t, Nbin, h] = raster_spikecount(DD, 30000, size(DD,2), pre, pre+post, pre, 25, TrialTypes);
h=0;
end

