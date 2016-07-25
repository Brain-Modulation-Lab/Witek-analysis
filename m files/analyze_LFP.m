function ans = analyze_LFP(sf, pre, post, tbase, tstart, tstop, VV, epoch_num, binsize)

%analyze baseline data
ans.nbins = floor(epoch_num/binsize);
for(j=1:epoch_num)
    ans.area(j) = sum(VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - VV(sf*tbase/1000,j))/sf;
    [ans.min(j), indexofmin] = min(VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - VV(sf*tbase/1000,j));
    ans.tmin(j) = tstart+1000*indexofmin(1)/sf;
    %SLOPE CALCULATION
    t = sf*(pre+tstart)/1000;
    while (VV(t,j) > VV(sf*tbase/1000,j)) && (t < sf*(pre+tstop)/1000)
        t = t+1;
    end
    ans.slope(j) = 0.001*sf*(VV(t+1,j) - VV(t-1,j))/2;
end
for(j=1:ans.nbins)
    ans.area_sterr(j) = std(ans.area(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    ans.min_sterr(j) = std(ans.min(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    ans.tmin_sterr(j) = std(ans.tmin(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    ans.slope_sterr(j) = std(ans.slope(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
end
ans.area_bin = bin(ans.area, ans.nbins)/binsize;
ans.min_bin = bin(ans.min, ans.nbins)/binsize;
ans.tmin_bin = bin(ans.tmin, ans.nbins)/binsize;
ans.slope_bin = bin(ans.slope, ans.nbins)/binsize;

