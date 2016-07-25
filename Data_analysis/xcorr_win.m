N=150000;
W=30000;
X = 300000;

for lag=1:N
xc(lag) = sum(abs(AudioSegment((X-W/2+lag-N/2):(X+W/2+lag-N/2))).*abs(SpikeSegment((X-W/2):(X+W/2))));
end