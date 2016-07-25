function S = a_w_scatter(i, W)
%negative spikes only
S = zeros(length(i), 5);

for(j = 1:length(i))
    S(j, 1) = i(j);
    [delta, baseline, start, stop] = spikewidth(W(:,j)); %spike timestamp in samples
    S(j, 2) = start;
    S(j, 3) = stop;
    S(j, 4) = min(W(ceil(start):floor(stop), j)); %spike amplitude
    S(j, 5) = delta;
end