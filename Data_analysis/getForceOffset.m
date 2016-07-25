
D = zeros(size(V));
D(round(30000*ts))=1;

for i = 1:length(LeftOffsetTimes)
    DDoffL(:,i) = D(30*(LeftOffsetTimes(i)-2.5*1000):30*(LeftOffsetTimes(i)+2.5*1000));
end
[t, Nbin, h_LoffR] = raster_spikecount(DDoffL, 30000, size(DDL,2), 2.5, 5, 2.5, 60, ['Left Grip Offsets -- ',RecID]);
for i = 1:length(RightOffsetTimes)
    DDoffR(:,i) = D(30*(RightOffsetTimes(i)-2.5*1000):30*(RightOffsetTimes(i)+2.5*1000));
end
[t, Nbin, h_RoffR] = raster_spikecount(DDoffR, 30000, size(DDoffR,2), 2.5, 5, 2.5, 60, ['Right Grip Offsets -- ',RecID]);


