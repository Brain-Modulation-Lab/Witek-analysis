function [delta, baseline, start, stop] = spikewidth(W)
%negative spikes only
baseline = W(1);
j = 1;

while (W(j) > (baseline - 0.4*(baseline-min(W)))) | (j < 10)
    baseline = mean(W(1:j));
    j = j+1;
end

start = j - (baseline - W(j))/(W(j-1)-W(j));

while(W(j) < baseline)
    j = j+1;    
end

stop = j - 1 + (baseline - W(j-1))/(W(j)-W(j-1));

delta = stop - start;