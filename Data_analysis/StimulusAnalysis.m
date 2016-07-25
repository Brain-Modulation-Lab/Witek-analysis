function [FR] = StimulusAnalysis(StimulusTimes, StimulusDuration, Trial, TrialTypes, TrialNum, D)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sf = 30000;
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
SelectedDuration = StimulusDuration(ind(ind<=TrialNum));

for i = 1:length(SelectedTimes)
    FR(i) = nnz(D(floor(sf*SelectedTimes(i)):ceil(sf*(SelectedTimes(i)+SelectedDuration(i)))))/SelectedDuration(i);
    %DD(:,i) = D(sf*floor(SelectedTimes(i)-pre):sf*floor(SelectedTimes(i)+post));
end

%[t, Nbin, z, h] = raster(DD, 30000, size(DD,2), pre, pre+post, post, 60, TrialTypes);

end

