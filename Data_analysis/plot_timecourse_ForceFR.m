function [h] = plot_timecourse_ForceFR( timecourse, field1, field2, field3, t, ...
    Nbin1, Nbin2,  Nbin1_thresh, Nbin2_thresh, F1, F2, psych, fs, fq, prespike, postspike)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

nframes=26;
Lmargin = 0.05;
Bmargin = 0.05;

h=figure; colormap jet
k=1; j=1;
for i=1:nframes
    hh(k)=subplot('Position',[Lmargin+(i-1)*(1-Lmargin)/nframes Bmargin+2*(1-Bmargin)/4 ((1-Lmargin)/nframes-0.005) ((1-Bmargin)/4-0.05)]); k=k+1;
    M = timecourse.(field1)(i).(field3)(:,1:end)'; % M = log10(timecourse(i).(field1)(:,9:end))'; M(M==-Inf) = 0; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(1:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); 
    %hold on; plot([0 0], ylim, '-', 'LineWidth', 0.25, 'Color', 'k');
   
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
    hh(k)=subplot('Position',[Lmargin+(i-1)*(1-Lmargin)/nframes Bmargin+(1-Bmargin)/4 ((1-Lmargin)/nframes-0.005) ((1-Bmargin)/4-0.05)]); k=k+1;
    M = timecourse.(field2)(i).(field3)(:,1:end)'; % M = log10(timecourse(i).(field2)(:,9:end))'; M(M==-Inf) = 0; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(1:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); 
    %hold on; plot([0 0], ylim, '-', 'LineWidth', 0.25, 'Color', 'k')
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
%     hh(k)=subplot('Position',[(i-1)/nframes 0 (1/nframes-0.005) (1/3-0.05)]); k=k+1;
%     M = timecourse.(field2)(i).(field3)(:,9:end)'- timecourse.(field1)(i).(field3)(:,9:end)'; % M = log10(timecourse(i).(field2)(:,9:end))'; M(M==-Inf) = 0; %
%     imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(9:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); 
%     %hold on; plot([0 0], ylim, '-', 'Color', 'k')
%     
%     x1limits = get(hh(k-1), 'xlim');
%     set(hh(k-1), 'xtick', x1limits(1)-1);
%     y1limits = get(hh(k-1), 'ylim');
%     set(hh(k-1), 'ytick', y1limits(1)-1);
end

Tpre = 2500;
Tpost = 2500;
Tbase = 2000;
minF = min([min(min(F1(:,:,1))), min(min(F1(:,:,1)))]);
maxF = max([max(max(F1(:,:,1))), max(max(F2(:,:,1)))]);
subplot('Position',[Lmargin Bmargin+7*(1-Bmargin)/8 (1-Lmargin-0.005) ((1-Bmargin)/8)])
shadedErrorBar(((1:(Tpre+Tpost+1))-Tpre)/fs, mean(F1(:,:,1),2), [max(F1(:,:,1),[],2)-mean(F1(:,:,1),2), mean(F1(:,:,1),2)-min(F1(:,:,1),[],2)], ...
    {'b', 'LineWidth', 2} ,0);
hold on; 
shadedErrorBar(((1:(Tpre+Tpost+1))-Tpre)/fs, mean(F1(:,:,2),2), [max(F1(:,:,2),[],2)-mean(F1(:,:,2),2), mean(F1(:,:,2),2)-min(F1(:,:,2),[],2)], ...
    {':r', 'LineWidth', 1} ,0);
plot(-[max(psych.CueT1) min(psych.CueT1)], (minF+(maxF-minF)/2)*[1 1], 'b')
plot(-mean(psych.CueT1), (minF+(maxF-minF)/2)*[1 1], 'b.', 'MarkerSize', 12)
plot(-[max(psych.RT1) min(psych.RT1)], (minF+(maxF-minF)/2)*[1 1], 'b')
plot(-mean(psych.RT1), (minF+(maxF-minF)/2)*[1 1], 'b.', 'MarkerSize', 12)
plot([min(psych.FBT1) max(psych.FBT1)], (minF+(maxF-minF)/2)*[1 1], 'b')
plot(mean(psych.FBT1), (minF+(maxF-minF)/2)*[1 1], 'b.', 'MarkerSize', 12)
plot([min(psych.PITI1) max(psych.PITI1)], (minF+(maxF-minF)/2)*[1 1], 'b')
plot(mean(psych.PITI1), (minF+(maxF-minF)/2)*[1 1], 'b.', 'MarkerSize', 12)
xlim([-Tpre Tpost]/fs)
ylim([minF maxF])
axis off
subplot('Position',[Lmargin Bmargin+6*(1-Bmargin)/8 (1-Lmargin-0.005) ((1-Bmargin)/8)])
shadedErrorBar(((1:(Tpre+Tpost+1))-Tpre)/fs, mean(F2(:,:,1),2), [max(F2(:,:,1),[],2)-mean(F2(:,:,1),2), mean(F2(:,:,1),2)-min(F2(:,:,1),[],2)], ...
    {'r', 'LineWidth', 2} ,0);
hold on; 
shadedErrorBar(((1:(Tpre+Tpost+1))-Tpre)/fs, mean(F2(:,:,2),2), [max(F2(:,:,2),[],2)-mean(F2(:,:,2),2), mean(F2(:,:,2),2)-min(F2(:,:,2),[],2)], ...
    {':b', 'LineWidth', 1} ,0);
plot(-[max(psych.CueT2) min(psych.CueT2)], (minF+(maxF-minF)/2)*[1 1], 'r')
plot(-mean(psych.CueT2), (minF+(maxF-minF)/2)*[1 1], 'r.', 'MarkerSize', 12)
plot(-[max(psych.RT2) min(psych.RT2)], (minF+(maxF-minF)/2)*[1 1], 'r')
plot(-mean(psych.RT2), (minF+(maxF-minF)/2)*[1 1], 'r.', 'MarkerSize', 12)
plot([min(psych.FBT2) max(psych.FBT2)], (minF+(maxF-minF)/2)*[1 1], 'r')
plot(mean(psych.FBT2), (minF+(maxF-minF)/2)*[1 1], 'r.', 'MarkerSize', 12)
plot([min(psych.PITI2) max(psych.PITI2)], (minF+(maxF-minF)/2)*[1 1], 'r')
plot(mean(psych.PITI2), (minF+(maxF-minF)/2)*[1 1], 'r.', 'MarkerSize', 12)
xlim([-Tpre Tpost]/fs)
ylim([minF maxF])
axis off

subplot('Position',[Lmargin Bmargin (1-Lmargin) ((1-Bmargin)/4-0.05)])
stairs(t, Nbin1/.2, 'b', 'LineWidth', 1);
hold on; plot(xlim, Nbin1_thresh(1)*[1 1]/.2, ':b', 'LineWidth', 1);
hold on; plot(xlim, Nbin1_thresh(2)*[1 1]/.2, ':b', 'LineWidth', 1);
hold on; stairs(t, Nbin2/.2, 'r', 'LineWidth', 1);
hold on; plot(xlim, Nbin2_thresh(1)*[1 1]/.2, ':r', 'LineWidth', 1);
hold on; plot(xlim, Nbin2_thresh(2)*[1 1]/.2, ':r', 'LineWidth', 1);

CommonCaxis = caxis((hh(1)));
for i=1:2*nframes
    thisCaxis = caxis((hh(i)));
    CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
    CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
end
for i=1:2*nframes
    caxis(hh(i), CommonCaxis);
    %caxis(hh(i), [-max(abs(CommonCaxis)), max(abs(CommonCaxis))]);
end
cm = colormap;
range = linspace(CommonCaxis(1),CommonCaxis(2),length(cm));
idx0 = find(range>=0,1,'first');
cm(1:idx0,:) = zeros(idx0,3);
colormap(cm);
end


