function [t, Nbin, z] = raster_ms(VV, DD, sf, epoch_num, pre, epoch_length, stim_dur, nbin, filename)

NN = DD;
NN(NN~=0)=1;
N = sum(NN,2)/epoch_num;
Nbin = nbin*bin(N, nbin)/epoch_length;

t = epoch_length*((1:nbin)-0.5)/nbin - pre;

f = figure;
fpos = get(f, 'Position');
set(f, 'Position', [fpos(1), fpos(2) - 0.25*fpos(4), fpos(3), 1.25*fpos(4)]);
offset = 1000; %0.4*max(max(DD)-min(VV));
% RASTER PANEL
axes1 = subplot(3,1,1);
hold on; 
for(j=1:epoch_num) 
    plot(1000*(1:length(VV))/sf - pre, VV(:,j)-offset*(j-1)); 
end
xlim([-pre epoch_length-pre]);
set(axes1, 'xtick', 0)
ylim([-offset*epoch_num 1.2*offset]);
y1limits = get(axes1, 'ylim');
set(axes1, 'ytick', y1limits(1)-1);
%hold on; plot(stim_dur*[1 1], y1limits, 'color', 'black');
title(filename);
% HISTOGRAM PANEL
axes2 = subplot(3,1,2);
bar(t, 1000*Nbin);
xlim([-pre epoch_length-pre]);
set(axes2, 'xtick', -pre-1)
ylabel('Hz');
% Z-SCORE PANEL
axes3 = subplot(3,1,3);
prebins = ceil((pre/epoch_length)*length(Nbin));
sigma = std(Nbin(1:prebins));
for i=1:nbin
    z(i) = (Nbin(i)-mean(Nbin(1:prebins)))/sigma;
end
xlim([-pre epoch_length-pre]);
plot(xlim, [0 0], 'color', 'black');
hold on;
plot(xlim, 1.644853*[1 -1; 1 -1], ':', 'color', 'black'); % z = 1.644853 corresponds to 5% tail of a normal prob. distr.
plot(t, z);
xlabel('ms');
ylabel('z-score');

axes1pos = get(axes1, 'Position');
axes2pos = get(axes2, 'Position');
axes3pos = get(axes3, 'Position');

margin = 0.06;

set(axes3, 'Position', [axes3pos(1) margin axes3pos(3) 0.15]);
set(axes2, 'Position', [axes2pos(1) margin+0.15 axes2pos(3) 0.15]);
set(axes1, 'Position', [axes1pos(1) margin+0.3 axes1pos(3) 0.7-2*margin]);

y2limits = get(axes2, 'ylim');
axes(axes2);
%hold on; plot(stim_dur*[1 1], y2limits, 'color', 'black');

% histogram and z-score only option
figure;
% HISTOGRAM PANEL
subplot(2,1,1);
bar(t, 1000*Nbin);
xlim([-pre epoch_length-pre]);
ylabel('Hz');
title(filename);
% Z-SCORE PANEL
subplot(2,1,2);
xlim([-pre epoch_length-pre]);
plot(xlim, [0 0], 'color', 'black');
hold on;
plot(xlim, 1.644853*[1 -1; 1 -1], ':', 'color', 'black'); % z = 1.644853 corresponds to 5% tail of a normal prob. distr.
plot(t, z);
xlabel('ms');
ylabel('z-score');