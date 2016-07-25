function [LLL, mean_latency, success_rate, lp, up] = stim_varISIanalysis(DDD, epoch_num, nISI, varISI, sf, pre, post, artifact, filename)

for j=1:nISI
    disp(['*** ISI = ', num2str(varISI(j)), ' ms :']);
    [LLL(j,:), mean_latency(j), success_rate(j)] = stim_analysis(filename, DDD(:,:,j), sf, pre+varISI(j), post-varISI(j), epoch_num/nISI, artifact(j));
    [lp(j), up(j)] = cfbin(LLL(j,:), 0.25);
    disp(['75% CI: (', num2str(100*lp(j)), ' ', num2str(100*up(j)), ') %']);
end

figure; hold on;
plot(varISI, success_rate, 'Marker', '.', 'MarkerSize', 12);
plot(varISI, up, ':');
plot(varISI, lp, ':');
hold on;
errorbar(varISI, success_rate, success_rate-lp, up-success_rate);
ylim([0 1]);
xlabel('ISI');
ylabel('firing probability');
title([filename, ' - f.p., 75% c.i.']);