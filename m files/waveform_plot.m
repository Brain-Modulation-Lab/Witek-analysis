function waveform_plot(W, sf, prespike, postspike, filename)

unit = 1000; %display millisecs

prespike = prespike*sf/unit; %convert to samples
postspike = postspike*sf/unit; %convert to samples

timescale = unit*((1:(prespike+postspike+1))-prespike-1)/sf;

% for i = 1:cols(W)
% W(:,i) = W(:,i) - mean(W(1:15,i));
% end

Wm = mean(W, 2);
Ws = std(W, [],2);

figure;
plot(timescale, Wm, 'LineWidth', 2);
hold on
plot(timescale, Wm-Ws, '--')
plot(timescale, Wm+Ws, '--')
plot([0 0], ylim, ':', 'color', 'red')
xlim(unit*[-prespike postspike]/sf);
ylabel('mV');
xlabel('ms');
title([filename, ' waveform mean +/- std']);