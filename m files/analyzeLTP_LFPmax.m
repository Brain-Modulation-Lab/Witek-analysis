function [base, test] = analyzeLTP_LFPmax(basefile, testfile, tbase, tstart, tstop, tltp, binsize, sf, stimf, pre)

%get baseline data
workspace = load([basefile, '.mat']);
base.VV = workspace.VV; % stim matrix
%analyze baseline data
base.nbins = floor(workspace.epoch_num/binsize);
base.tstart = workspace.tstart;
for(j=1:workspace.epoch_num)
    base.area(j) = sum(base.VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - base.VV(sf*tbase/1000,j))/sf;
    [base.max(j), indexofmax] = max(base.VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - base.VV(sf*tbase/1000,j));
    base.tmax(j) = tstart+1000*indexofmax(1)/sf;
    %SLOPE CALCULATION
    t = sf*(pre+tstart)/1000;
    while (base.VV(t,j) > base.VV(sf*tbase/1000,j)) && (t < sf*(pre+tstop)/1000)
        t = t+1;
    end
    base.slope(j) = 0.001*sf*(base.VV(t+1,j) - base.VV(t-1,j))/2;
end
for(j=1:base.nbins)
    base.area_sterr(j) = std(base.area(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    base.max_sterr(j) = std(base.max(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    base.tmax_sterr(j) = std(base.tmax(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    base.slope_sterr(j) = std(base.slope(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
end
base.area_bin = bin(base.area, base.nbins)/binsize;
base.max_bin = bin(base.max, base.nbins)/binsize;
base.tmax_bin = bin(base.tmax, base.nbins)/binsize;
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
        [test(k).max(j), indexofmax] = max(test(k).VV((sf*(pre+tstart)/1000):(sf*(pre+tstop)/1000),j) - baseV);
        test(k).tmax(j) = tstart+1000*indexofmax(1)/sf;
        %SLOPE CALCULATION
        t = sf*(pre+tstart)/1000;
        while (test(k).VV(t,j) > test(k).VV(sf*tbase/1000,j)) && (t < sf*(pre+tstop)/1000)
            t = t+1;    
        end
        test(k).slope(j) = 0.001*sf*(test(k).VV(t+1,j) - test(k).VV(t-1,j))/2;
    end
    for(j=1:test(k).nbins)
        test(k).area_sterr(j) = std(test(k).area(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
        test(k).max_sterr(j) = std(test(k).max(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
        test(k).tmax_sterr(j) = std(test(k).tmax(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
        test(k).slope_sterr(j) = std(test(k).slope(((j-1)*binsize+1):j*binsize))/sqrt(binsize);
    end
    test(k).area_bin = bin(test(k).area, test(k).nbins)/binsize;
    test(k).max_bin = bin(test(k).max, test(k).nbins)/binsize;
    test(k).tmax_bin = bin(test(k).tmax, test(k).nbins)/binsize;
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
% errorbar((binsize*(1:base.nbins)/stimf - binsize/2 + (hms2sec(base.tstart) - hms2sec(tltp)))/60, base.max_bin, base.max_sterr, base.max_sterr);
% hold on; 
% for(k=1:length(testfile))
%     errorbar((binsize*(1:test(k).nbins)/stimf - binsize/2 + (hms2sec(test(k).tstart) - hms2sec(tltp)))/60, test(k).max_bin, test(k).max_sterr, test(k).max_sterr)
% end
% xlabel('minutes');
% ylabel(['maximum amplitude ', num2str(tstart), ' - ', num2str(tstop), ' ms post stim']);
% 
% figure;
% errorbar((binsize*(1:base.nbins)/stimf - binsize/2 + (hms2sec(base.tstart) - hms2sec(tltp)))/60, base.tmax_bin, base.tmax_sterr, base.tmax_sterr);
% hold on; 
% for(k=1:length(testfile))
%     errorbar((binsize*(1:test(k).nbins)/stimf - binsize/2 + (hms2sec(test(k).tstart) - hms2sec(tltp)))/60, test(k).tmax_bin, test(k).tmax_sterr, test(k).tmax_sterr)
% end
% xlabel('minutes');
% ylabel(['latency of maximum amplitude ', num2str(tstart), ' - ', num2str(tstop), ' ms post stim']);