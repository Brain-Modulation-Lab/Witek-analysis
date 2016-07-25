function [HH, artifact] = stim_min(VV, sf, pre, post, epoch_num, artifact, max_latency)

%epoch = sf*(pre+post)/1000; %convert ms to samples

for(j=1:epoch_num) 
    HH(:,j) = find_min(VV(ceil(sf*(pre+artifact)/1000):floor(sf*(pre+max_latency)/1000),j)); 
end