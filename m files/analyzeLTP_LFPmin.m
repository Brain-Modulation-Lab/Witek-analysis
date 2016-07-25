function [base, test] = analyzeLTP_LFPmin(basefile, testfile, tbase, tstart, tstop, tltp, binsize, sf, stimf, pre)

%get baseline data
workspace = load([basefile, '.mat']);
base.VV = workspace.VV; % stim matrix
%analyze baseline data
base.nbins = floor(workspace.epoch_num/binsize);
base.tstart = workspace.tstart;
for(j=1:workspace.epoch_num)
    base.area(j) = sum(base.VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - base.VV(sf*tbase/1000,j))/sf;
    [base.min(j), indexofmin] = min(base.VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - base.VV(sf*tbase/1000,j));
    base.tmin(j) = tstart+1000*indexofmin(1)/sf;
    %SLOPE CALCULATION
    t = sf*(pre+tstart)/1000;
    while (base.VV(t,j) > base.VV(sf*tbase/1000,j)) && (t < sf*(pre+tstop)/1000)
        t = t+1;
    end
    base.slope(j) = 0.001*sf*(base.VV(t+1,j) - base.VV(t-1,j))/2;
end
for(j=1:base.nbins)
    base.area_sterr(j) = std(base.area(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    base.min_sterr(j) = std(base.min(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    base.tmin_sterr(j) = std(base.tmin(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    base.slope_sterr(j) = std(base.slope(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
end
base.area_bin = bin(base.area, base.nbins)/binsize;
base.min_bin = bin(base.min, base.nbins)/binsize;
base.tmin_bin = bin(base.tmin, base.nbins)/binsize;
base.slope_bin = bin(base.slope, base.nbins)/binsize;

for(k=1:length(testfile))
    %get baseline data
    workspace = load([testfile{k}, '.mat']);
    test(k).VV = workspace.VV; % stim matrix
    %analyze baseline data
    test(k).nbins = floor(workspace.epoch_num/binsize);
    test(k).tstart = workspace.tstart;
    for(j=1:workspace.epoch_num)
        baseV = test(k).VV(sf*tbase/1000,j);
        test(k).area(j) = sum(test(k).VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - baseV)/sf;
        [test(k).min(j), indexofmin] = min(test(k).VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - baseV);
        test(k).tmin(j) = tstart+1000*indexofmin(1)/sf;
        %SLOPE CALCULATION
        t = sf*(pre+tstart)/1000;
        while (test(k).VV(t,j) > test(k).VV(sf*tbase/1000,j)) && (t < sf*(pre+tstop)/1000)
            t = t+1;    
        end
        test(k).slope(j) = 0.001*sf*(test(k).VV(t+1,j) - test(k).VV(t-1,j))/2;
    end
    for(j=1:test(k).nbins)
        test(k).area_sterr(j) = std(test(k).area(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
        test(k).min_sterr(j) = std(test(k).min(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
        test(k).tmin_sterr(j) = std(test(k).tmin(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
        test(k).slope_sterr(j) = std(test(k).slope(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    end
    test(k).area_bin = bin(test(k).area, test(k).nbins)/binsize;
    test(k).min_bin = bin(test(k).min, test(k).nbins)/binsize;
    test(k).tmin_bin = bin(test(k).tmin, test(k).nbins)/binsize;
    test(k).slope_bin = bin(test(k).slope, test(k).nbins)/binsize;
end

% figure;
% errorbar((binsize*(1:base.nbins)/stimf - binsize/2 + (hms2sec(base.tstart) - hms2sec(tltp)))/60, base.slope_bin, base.slope_sterr, base.slope_sterr);
% hold on; 
% for(k=1:length(testfile))
%     errorbar((binsize*(1:test(k).nbins)/stimf - binsize/2 + (hms2sec(test(k).tstart) - hms2sec(tltp)))/60, test(k).slope_bin, test(k).slope_sterr, test(k).slope_sterr)
% end
% xlabel('minutes');
% ylabel(['slope (mV / ms)']);
% 
% figure;
% errorbar((binsize*(1:base.nbins)/stimf - binsize/2 + (hms2sec(base.tstart) - hms2sec(tltp)))/60, base.min_bin, base.min_sterr, base.min_sterr);
% hold on; 
% for(k=1:length(testfile))
%     errorbar((binsize*(1:test(k).nbins)/stimf - binsize/2 + (hms2sec(test(k).tstart) - hms2sec(tltp)))/60, test(k).min_bin, test(k).min_sterr, test(k).min_sterr)
% end
% xlabel('minutes');
% ylabel(['minimum amplitude ', num2str(tstart), ' - ', num2str(tstop), ' ms post stim']);
% 
% figure;
% errorbar((binsize*(1:base.nbins)/stimf - binsize/2 + (hms2sec(base.tstart) - hms2sec(tltp)))/60, base.tmin_bin, base.tmin_sterr, base.tmin_sterr);
% hold on; 
% for(k=1:length(testfile))
%     errorbar((binsize*(1:test(k).nbins)/stimf - binsize/2 + (hms2sec(test(k).tstart) - hms2sec(tltp)))/60, test(k).tmin_bin, test(k).tmin_sterr, test(k).tmin_sterr)
% end
% xlabel('minutes');
% ylabel(['latency of minimum amplitude ', num2str(tstart), ' - ', num2str(tstop), ' ms post stim']);