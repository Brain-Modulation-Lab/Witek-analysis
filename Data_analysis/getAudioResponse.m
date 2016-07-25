
D = zeros(size(V));
D(round(30000*ts))=1;

DD = false((30000*5)+1, length(ResponseTimes));
for i = 1:length(ResponseTimes)
    DD(:,i) = D((round(30000*ResponseTimes(i))-30000*2.5):(round(30000*ResponseTimes(i))+30000*2.5));
end

%DD = DD(:,find(sum(DD,1)>0,1,'first'):find(sum(DD,1)>0,1,'last'));

[t, Nbin, ~, NNbin, h] = raster_spikecountz(DD, 30000, size(DD,2), 2.5, 0.1, 5, 2.5, 30, spikeFN);


