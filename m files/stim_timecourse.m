function [t, TT] = stim_timecourse(LL, epoch_num, nbin, stim_freq, filename)

NN = LL;
NN(NN~=0)=1;
B = bin(NN, nbin);
binsize = floor(length(NN)/nbin);
TT = (1/binsize)*B;
t = (binsize/stim_freq)*((1:nbin)-0.5);

figure; 
plot(t, TT, '.', 'MarkerSize', 24, 'LineStyle', '-');
ylim([0 1]);
xlabel('seconds');
ylabel('firing probability');
title(filename);