function LFPxtrials = LFPStimulus(StimulusTimes, Trial, TrialTypes, TrialNum, LFP)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sf = 1000;
pre = 0.5;
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
SelectedSamples = round(sf*SelectedTimes);

for i = 1:length(SelectedTimes)
    LFPxtrials(:,i) = LFP((SelectedSamples(i)-sf*pre):(SelectedSamples(i)+sf*post));
end

%figure; plot((1:size(LFPxtrials,1))/sf-pre, mean(LFPxtrials,2));

end

