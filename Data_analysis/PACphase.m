function phase = PACphase(fps, fas, amp_ph)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

P1 = ginput(1);
ip=find(fps>=floor(P1(1)), 1, 'first');
ia=find(fas>=floor(P1(2)), 1, 'first');

phase = squeeze(amp_ph(ia,ip,:));
size(phase)
figure; plot(2*pi*(1:30)./32-pi, phase, '.', 'MarkerSize', 12); 
hold on; plot(2*pi*(1:30)./32-pi, smooth(phase), 'r', 'LineWidth', 2); 
xlim([-pi pi]); 
hold on; plot([0 0], ylim, ':');
title(['Phase distribution Fp=', num2str(floor(P1(1))), 'Hz Fa=', num2str(floor(P1(2))), 'Hz'])

end

