function [t, Nbin, p, h] = raster_poisson(DD, dur, sf, epoch_num, pre, epoch_length, stim_dur, nbin, filename)

NN = DD;
NN(NN~=0)=1;
N = sum(NN,2)/epoch_num;
Nbin = nbin*bin(N, nbin)/epoch_length;

t = epoch_length*((1:nbin)-1)/nbin - pre;

h=figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RASTER PANEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

offset = 1500; %1.1*max(max(DD)-min(VV));
axes1 = subplot(2,1,1);
hold on; 
for(j=1:epoch_num) 
    % plot((1:length(VV))/sf, VV(:,j)-offset*(j-1)); 
    tstamps = find(NN(:,j)~=0);
    for k = 1:length(tstamps)
        if tstamps(k)>(pre*sf) & (tstamps(k)-pre*sf)<=dur(j)*sf
            color='red';
        else
            color='black';
        end
%       color = 'black';
        plot(tstamps(k)/sf*[1 1], [-offset*(j-1.4) -offset*(j-0.6)], 'color', color, 'LineWidth', 0.5)
    end
end
xlim([0 epoch_length]);
set(axes1, 'xtick', -1)
% ylim([-offset*(epoch_num-1)+1.4*min(VV(:,epoch_num)) 1.2*max(VV(:,1))]); 
ylim ([-offset*(epoch_num-0.5) 0.5*offset]);
y1limits = get(axes1, 'ylim');
set(axes1, 'ytick', y1limits(1)-1);
hold on; plot(stim_dur*[1 1], y1limits, 'color', [0.75 0.75 0.75], 'LineWidth', 2);
title(filename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P value panel -- based on bootstrapping the binomial distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes2 = subplot(2,1,2);
prebins = ceil((pre/epoch_length)*length(Nbin));
Nbaseline = [];
Ndur = [];
for i=1:epoch_num
%    NNbin(:,i) = nbin*bin(NN(:,i), nbin)/epoch_length;
    NNbin(:,i) = bin(NN(:,i), nbin);
%	poisson = makedist('Poisson','lambda',mean(NNbin(1:prebins,i)));
%     for k=1:1000
%         BSpoisson_mean(k) = mean(random(poisson, 1000, 1));
%     end
%    [x, f] = ecdf(BSpoisson_mean)
%    x(find(f>3.7445,1,'first'))
    Nbaseline((end+1):(end+prebins)) = NNbin(1:prebins,i);
    durbins = ceil((dur(i)/epoch_length)*length(Nbin));
    Ndur((end+1):(end+durbins)) = NNbin((prebins+1):(prebins+durbins),i);
    fano(i) = var(NNbin(1:prebins,i))/mean(NNbin(1:prebins,i));
    fprintf('Mean: %f   Var: %f   Fano: %f\n', mean(NNbin(1:prebins,i)), var(NNbin(1:prebins,i)), fano(i));
%     for j=1:nbin
%         pp(j,i) = cdf('poiss', NNbin(j,i), mean(NNbin(1:prebins,i))); 
%     end
end
for j=1:nbin
p(j) = cdf('poiss', mean(NNbin(j,:)), mean(Nbaseline)); 
end
fprintf('MEAN FANO:  %f\n', mean(fano));
fprintf('BASELINE FANO:  %f\n', var(Nbaseline)/mean(Nbaseline));

xlim([-pre epoch_length-pre]);
plot(xlim, [0 0], 'color', 'black');
hold on; plot([0 0], [0 1.25], 'color', [0.75 0.75 0.75], 'LineWidth', 2);
hold on;
plot(xlim, 2*[1 -1; 1 -1], ':', 'color', 'black'); % z = 1.644853 corresponds to 5% tail of a normal prob. distr.
stairs([t max(t)+epoch_length/(nbin)], [p p(end)], 'k', 'LineWidth', 1);
hold on; plot(t(p>0.95)+epoch_length/(2*nbin), p(p>0.95), '*', 'Color', 'r')
xlabel('time (s)', 'FontSize', 20);
ylabel('p-value', 'FontSize', 20);
xlim([min(t) max(t)+epoch_length/(nbin)]);
ylim([0 1.25]);


ho = 0:max([max(Nbaseline), max(Ndur)]);
[Hbaseline, ho] = hist(Nbaseline, ho);
[Hdur, ho] = hist(Ndur, ho);
figure; bar(ho, Hbaseline/sum(Hbaseline));
hold on; plot(ho, pdf('Poisson', ho, mean(Nbaseline)), 'Color', 'g');
hold on; bar(ho, Hdur/sum(Hdur), 'r');
hold on; plot(ho, pdf('Poisson', ho, mean(Ndur)), 'Color', 'm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HISTOGRAM PANEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% axes2 = subplot(2,1,2);
% bar(epoch_length*((1:nbin)-0.5)/nbin, Nbin);
% xlim([0 epoch_length]);
% xlabel('seconds');
% ylabel('Hz');
 
axes1pos = get(axes1, 'Position');
axes2pos = get(axes2, 'Position');
%set(axes2, 'Position', [axes2pos(1:3) axes2pos(4)/2]);
set(axes1, 'Position', [axes1pos(1) axes2pos(2)+axes2pos(4)/1 axes1pos(3) axes1pos(2)+axes1pos(4)-(axes2pos(2)+axes2pos(4)/1)]);
set(axes1, 'FontSize', 20);
set(axes2, 'FontSize', 20);

% 
% y2limits = get(axes2, 'ylim');
% axes(axes2);
% hold on; plot(stim_dur*[1 1], y2limits, 'color', 'black');