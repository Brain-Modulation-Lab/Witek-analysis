function [ h] = plot_timecourse_FB3( timecourse, fq)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

h=figure;
k=1;
for i=1:10
    hh(k)=subplot('Position',[(i-1)/10 1/2 (1/10-0.01) (1/2-0.01)]); k=k+1;
    imagesc((1:801)/1000-0.4, fq, timecourse(i).FB3miLR'); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
%     hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
%     hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
%     hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
%     hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);
    
%     STATStimecourse1(i).selected = reshape(timecourse1(i).mi(round(1000*(0.5+time_range(1))):round(1000*(0.5+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
%     STATStimecourse1(i).mean = mean(STATStimecourse1(i).selected);
%     STATStimecourse1(i).std = std(STATStimecourse1(i).selected);
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    hh(k)=subplot('Position',[(i-1)/10 0 (1/10-0.01) (1/2-0.01)]); k=k+1;
    imagesc((1:801)/1000-0.4, fq, timecourse(i).FB3miRR'); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
%     hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
%     hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
%     hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
%     hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);
    
%     STATStimecourse2(i).selected = reshape(timecourse2(i).mi(round(1000*(0.5+time_range(1))):round(1000*(0.5+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
%     STATStimecourse2(i).mean = mean(STATStimecourse2(i).selected);
%     STATStimecourse2(i).std = std(STATStimecourse2(i).selected);
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
end
CommonCaxis = caxis((hh(1)));
for i=1:20
    thisCaxis = caxis((hh(i)));
    CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
    CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
end
for i=1:20
    caxis(hh(i), CommonCaxis./20);
end

% figure; errorbar([STATStimecourse1(:).mean], [STATStimecourse1(:).std])
% hold on; errorbar([STATStimecourse2(:).mean], [STATStimecourse2(:).std], 'r')
% 
% numel(STATStimecourse1(1).selected)
% bon=0.05/(numel(STATStimecourse1(1).selected));
% thresh=icdf('normal',1-bon,0,1);
% 
% hold on; plot(xlim, thresh*[1 1], ':')

end


