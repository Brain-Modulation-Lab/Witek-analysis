function [Wmean, base, berr, min, merr, latency] = meanstimwindow(W, base, duration)

dim = size(W);
b = zeros(dim(1),1);
be = zeros(dim(1),1);
m = zeros(dim(1),1);
me = zeros(dim(1),1);
l = zeros(dim(1),1);

for i = 1:dim(1)
    b(i) = mean(W(i,1:base));
    [max, maxindex] = max(W(i,:));
    [m(i), minindex] = min(W(i,maxindex:dim(2)));
    l(i) = maxindex+minindex-base;
end

Wmean = mean(W);
base = mean(b);
berr = std(b);
min = mean(m);
merr = std(m);
latency = mean(l);