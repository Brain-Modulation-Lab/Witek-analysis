
D = zeros(length(V),1);
D(round(30000*ts))=1;

for i = 1:length(LeftResponseTimes)
    DDLR(:,i) = D(30*(LeftResponseTimes(i)-2.5*1000):30*(LeftResponseTimes(i)+2.5*1000));
end
[t, Nbin, h_LR] = raster_spikecountz(DDLR, 30000, size(DDLR,2), 2.5, 0.1, 5, 2.5, 50, ['Left Grip Responses -- ',RecID]);
for i = 1:length(RightResponseTimes)
    DDRR(:,i) = D(30*(RightResponseTimes(i)-2.5*1000):30*(RightResponseTimes(i)+2.5*1000));
end
[t, Nbin, h_RR] = raster_spikecountz(DDRR, 30000, size(DDRR,2), 2.5, 0.1, 5, 2.5, 50, ['Right Grip Responses -- ',RecID]);


