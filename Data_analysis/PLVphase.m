function phase = PLVphase(f, t, amp_ph)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

P1 = ginput(1)
ifreq=find(f>=P1(2), 1, 'first')
it=find(t>=P1(1), 1, 'first')

phase = squeeze(amp_ph(:,it,ifreq));
size(phase)
figure; plot(2*pi*(1:30)./30-pi, phase, '.', 'MarkerSize', 12); 
hold on; plot(2*pi*(1:30)./30-pi, smooth(phase), 'r', 'LineWidth', 2); 
xlim([-pi pi]); 
hold on; plot([0 0], ylim, ':');
title(['Phase distribution Freq=', num2str(P1(2)), 'Hz t=', num2str(P1(1)), 's'])

end

