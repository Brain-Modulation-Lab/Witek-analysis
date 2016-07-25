function [t, Nbin, h] = raster_spikecount(DD, sf, epoch_num, pre, epoch_length, stim_dur, nbin, filename)

NN = DD;
NN(NN~=0)=1;
N = sum(NN,2)/epoch_num;
Nbin = bin(N, nbin);

prebins = ceil((pre/epoch_length)*length(Nbin));
Nbaseline = [];
Ndur = [];
for i=1:epoch_num
    NNbin(:,i) = bin(NN(:,i), nbin);
    Nbaseline((end+1):(end+prebins)) = NNbin(1:prebins,i);
    
    durbins = ceil((dur(i)/epoch_length)*length(Nbin));
    Ndur((end+1):(end+durbins)) = NNbin((prebins+1):(prebins+durbins),i);
    fano(i) = var(NNbin(1:prebins,i))/mean(NNbin(1:prebins,i));
    fprintf('Mean: %f   Var: %f   Fano: %f\n', mean(NNbin(1:prebins,i)), var(NNbin(1:prebins,i)), fano(i));
%     for j=1:nbin
%         pp(j,i) = cdf('poiss', NNbin(j,i), mean(NNbin(1:prebins,i))); 
%     end
end


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
%         if k>1 && (tstamps(k)-tstamps(k-1))<500
%             color='red';
%         else
%             color='blue';
%         end
        color = 'black';
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
% SPIKE COUNT PANEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes2 = subplot(2,1,2);
stairs(t, Nbin, 'k', 'LineWidth', 1);
xlim([min(t) max(t)]);
ylim1 = ylim;
ylim([0 ylim1(2)]); ylim([0 10]) %
hold on; plot([0 0], ylim, 'color', [0.75 0.75 0.75], 'LineWidth', 2);
xlabel('time (s)', 'FontSize', 20);
ylabel('Mean spike count', 'FontSize', 20);



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