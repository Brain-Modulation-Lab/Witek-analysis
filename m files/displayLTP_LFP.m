binsize = 10;
stimf = 0.1;
tltp = 30;

figure;
hold on; 
errorbar((binsize*(1:control.nbins)/stimf - binsize/2 + (hms2sec(control.tstart) - hms2sec(tltp)))/60, control.min_bin/control.min_bin(1), control.min_sterr/control.min_bin(1), control.min_sterr/control.min_bin(1));
errorbar((binsize*(1:base.nbins)/stimf - binsize/2 + (hms2sec(base.tstart) - hms2sec(tltp)))/60, base.min_bin/base.min_bin(1), base.min_sterr/base.min_bin(1), base.min_sterr/base.min_bin(1));
for(k=1:length(test))
    errorbar((binsize*(1:test(k).nbins)/stimf - binsize/2 + (hms2sec(test(k).tstart) - hms2sec(tltp)))/60, test(k).min_bin/base.min_bin(1), test(k).min_sterr/base.min_bin(1), test(k).min_sterr/base.min_bin(1))
end
xlabel('minutes');
ylabel('norm. minimum amplitude ');

