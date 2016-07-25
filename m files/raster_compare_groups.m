function [t, Nbin, Tbin, Pbin, RT, h] = raster_compare_groups(ts, l, fs, TrialNum, pre, binsize, post, EventTimes, SkipEvents, ResponseTimes, groups)

D = zeros(l,1);
D(round(fs*ts))=1;

for i = 1:length(ResponseTimes)
    DD(:,i) = D((round(fs*ResponseTimes(i))-fs*pre*binsize):(round(fs*ResponseTimes(i))+fs*post*binsize));
end
DD(DD~=0)=1;

for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    ITIbase(trial) = sum(D(round(fs*EventTimes(baseEvent)):(round(fs*EventTimes(baseEvent))+fs*binsize)));
    RT(trial) = ResponseTimes(trial)-EventTimes(baseEvent+2);
    delay(trial) = EventTimes(baseEvent+2)-EventTimes(baseEvent+1);
    fprintf('%4.2f\n',EventTimes(baseEvent+2)-EventTimes(baseEvent+1));
end
fprintf('Min = %4.2f, Mean = %4.2f, Max = %4.2f\n',min(delay), mean(delay), max(delay));

nbin = pre + post + 1;

for G=1:length(groups)
    
    thisGroup = groups{G};
    for trial=1:length(thisGroup)
        NNbin{G}(:,trial) = bin(DD(:,thisGroup(trial)), nbin)/ITIbase(thisGroup(trial));
        %NNbin{G}(:,trial) = bin(DD(:,thisGroup(trial)), nbin);%/ITIbase(thisGroup(trial));
    end

    Nbin(:,G) = mean(NNbin{G},2);
    Nbinsterr(:,G) = std(NNbin{G},0,2)/sqrt(size(NNbin{G},2));
    %clear NNbin
end


for b=1:nbin
    x1 = NNbin{1}(b,:);
    x2 = NNbin{2}(b,:);
    Tbin(b) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
    Pbin(b) = tcdf(Tbin(b),numel(x1)+numel(x2)-2);
end

%t = binsize*((1:nbin)-0.5-pre);
t = binsize*((1:nbin)-1-pre);
h=figure;
hold on
for G=1:length(groups)
    errorbar(t, Nbin(:,G), Nbinsterr(:,G));
end

% stairs(t, Nbin);
% figure; stairs(t, Tbin);
% figure; stairs(t, Pbin); 
%hold on; plot( binsize*(find(Pbin<0.05/nbin)*[1 1]-0.5-pre), [0 0], 'b*')
%hold on; plot( binsize*(find(Pbin>(1-0.05/nbin))*[1 1]-0.5-pre), [0 0], 'r*')

