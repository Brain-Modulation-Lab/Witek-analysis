function [t, TT, lp, up] = stim_timecourse_err(LL, epoch_num, nbin, stim_freq, alpha, filename)

NN = LL;
NN(NN~=0)=1;
B = bin(NN, nbin);
binsize = floor(length(LL)/nbin);
TT = (1/binsize)*B;
t = (binsize/stim_freq)*((1:nbin)-0.5);
for j=1:nbin
    [lp(j), up(j)] = cfbin(LL((1+(j-1)*binsize):(j*binsize)),alpha);
end

figure; 
plot(t, TT, '.', 'MarkerSize', 24, 'LineStyle', '-');
hold on;
errorbar(t, TT, TT-lp, up-TT);
ylim([0 1]);
xlabel('seconds');
ylabel('firing probability');
title([filename, ' - f.p., ', num2str(100*(1-alpha)), '% c.i.']);