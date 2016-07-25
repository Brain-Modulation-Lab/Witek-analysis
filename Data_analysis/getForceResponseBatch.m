
units(unit).D = zeros(size(units(unit).V));
units(unit).D(round(30000*units(unit).ts))=1;

for i = 1:length(units(unit).LeftResponseTimes)
    units(unit).DDL(:,i) = units(unit).D(30*(units(unit).LeftResponseTimes(i)-2.5*1000):30*(units(unit).LeftResponseTimes(i)+2.5*1000));
end
[t, Nbin, h_LR] = raster_spikecount(units(unit).DDL, 30000, size(units(unit).DDL,2), 2.5, 5, 2.5, 60, ['Left Grip Responses -- ',units(unit).id]);
for i = 1:length(units(unit).RightResponseTimes)
    units(unit).DDR(:,i) = units(unit).D(30*(units(unit).RightResponseTimes(i)-2.5*1000):30*(units(unit).RightResponseTimes(i)+2.5*1000));
end
[t, Nbin, h_RR] = raster_spikecount(units(unit).DDR, 30000, size(units(unit).DDR,2), 2.5, 5, 2.5, 60, ['Right Grip Responses -- ',units(unit).id]);


