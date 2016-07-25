function [t, Nbin, Nbin_thresh, NNbin, h] = raster_spikecountz(DD, sf, epoch_num, pre, epsilon, epoch_length, stim_dur, nbin, filename)
%function [t, Nbin, Nbin_thresh, NNbin, h] = raster_spikecountz(DD, sf, epoch_num, pre, epsilon, epoch_length, stim_dur, nbin, filename)
%Inputs:    DD - Matrix of binary spike response vectors
%           sf - sampling frequency of the spike vector (in sample/sec)
%           epoch_num - number of trials/repeats, the other dimension of
%           spike matrix
%           pre - length of time to consider before 0 (sec)
%           epsilon - amount of time before 0 to consider baseline
%           epoch_length - sum of pre and stim_dur
%           stim_dur - length of time to consider after 0 (sec) 
%           nbin - number of bins
%           filename - the filename
%Outputs:   t - bin times
%           Nbin - The zscores 
%           Nbin_thresh
%           NNbin
%           h - significance from baseline

NN = DD;
NN(NN~=0)=1;
N = sum(NN,2)/epoch_num;
Nbin = bin(N, nbin);

prebins = ceil(((pre-epsilon)/epoch_length)*length(Nbin));

for i=1:epoch_num
    NNbin(:,i) = bin(NN(:,i), nbin);
end

% NNbin_baseline = NNbin(1:prebins,:);
% basemean = mean(NNbin_baseline(:));
% sigma = std(NNbin_baseline(:));

alpha=0.05;
iter=100;
NNbaseline = NN(1:sf*(pre-epsilon),:);
nrNNbaseline = size(NNbaseline,1);
%NNbaseline_surr = zeros(nrNNbaseline,1);
NNbaseline_surr_bin = zeros(prebins, epoch_num, iter);
for i=1:iter
    for j=1:epoch_num
        %NNbaseline_surr = circshift(NNbaseline(:,j), randi(nrNNbaseline));
        NNbaseline_surr_bin(:,j,i) = bin(circshift(NNbaseline(:,j), randi(nrNNbaseline)), prebins);
    end
end

NNbaseline_surr_mean = squeeze(mean(NNbaseline_surr_bin,2));
Nbin_thresh  = [prctile(NNbaseline_surr_mean(:),alpha/2), prctile(NNbaseline_surr_mean(:),100*(1-alpha/2))];

%zz = (NNbin-basemean)/sigma;

t = epoch_length*((1:nbin)-0.5)/nbin - pre;

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
        color = 'black';
        plot(tstamps(k)/sf*[1 1], [-offset*(j-1.4) -offset*(j-0.6)], 'color', color, 'LineWidth', 0.25)
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
% Z-SCORE PANEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes2 = subplot(2,1,2);
stairs(t, Nbin/.2, 'k', 'LineWidth', 1);
xlim([min(t) max(t)]);
hold on; plot(xlim, Nbin_thresh(1)*[1 1]/.2, 'color', 'r', 'LineWidth', 1);
hold on; plot(xlim, Nbin_thresh(2)*[1 1]/.2, 'color', 'r', 'LineWidth', 1);
ylim1 = ylim;
ylim(ylim1); % ylim([0 10]) %
hold on; plot([0 0], ylim, 'color', [0.75 0.75 0.75], 'LineWidth', 2);
xlabel('time (s)', 'FontSize', 20);
ylabel('mean firing rate (Hz)', 'FontSize', 20);


 
axes1pos = get(axes1, 'Position');
axes2pos = get(axes2, 'Position');
%set(axes2, 'Position', [axes2pos(1:3) axes2pos(4)/2]);
set(axes1, 'Position', [axes1pos(1) axes2pos(2)+axes2pos(4)/1 axes1pos(3) axes1pos(2)+axes1pos(4)-(axes2pos(2)+axes2pos(4)/1)]);
set(axes2, 'FontSize', 20);
set(axes1, 'FontSize', 20);

% 
% y2limits = get(axes2, 'ylim');
% axes(axes2);
% hold on; plot(stim_dur*[1 1], y2limits, 'color', 'black');