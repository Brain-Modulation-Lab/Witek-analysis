function h = plot_timecourse_FDR( timecourse1, timecourse2, fq, field, time_range, fq_range)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

h=figure;
k=1;
for i=1:10
    hh(k)=subplot('Position',[(i-1)/10 3/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    sig_value = timecourse1(i).(field);
    sig_value(timecourse1(i).sig==0) = 0;
    imagesc((1:1001)/1000-0.5, fq, sig_value'); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);
    
    STATStimecourse1(i).selected = reshape(timecourse1(i).zmi(round(1000*(0.5+time_range(1))):round(1000*(0.5+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
    STATStimecourse1(i).selected_sig = reshape(timecourse1(i).sig(round(1000*(0.5+time_range(1))):round(1000*(0.5+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
    STATStimecourse1(i).mean = mean(STATStimecourse1(i).selected(STATStimecourse1(i).selected_sig==1));
    STATStimecourse1(i).std = std(STATStimecourse1(i).selected(STATStimecourse1(i).selected_sig==1));
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    hh(k)=subplot('Position',[(i-1)/10 2/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    sig_value = timecourse2(i).(field);
    sig_value(timecourse1(i).sig==0) = 0;
    imagesc((1:1001)/1000-0.5, fq, sig_value'); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
    hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);
    

    
    STATStimecourse2(i).selected = reshape(timecourse2(i).zmi(round(1000*(0.5+time_range(1))):round(1000*(0.5+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
    STATStimecourse2(i).selected_sig = reshape(timecourse2(i).sig(round(1000*(0.5+time_range(1))):round(1000*(0.5+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
    STATStimecourse2(i).mean = mean(STATStimecourse2(i).selected(STATStimecourse2(i).selected_sig==1));
    STATStimecourse2(i).std = std(STATStimecourse2(i).selected(STATStimecourse2(i).selected_sig==1));
    
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
    caxis(hh(i), CommonCaxis);
end

subplot('Position',[0.04 0.04 (1-0.08) (2/4-0.08)]); k=k+1;

bon=0.05;
thresh=icdf('normal',1-bon,0,1);
xlim([-2.5 3])
plot(xlim, thresh*[1 1], 'k', 'LineWidth', 2)
hold on; errorbar((1:10)/2-2.5, [STATStimecourse1(:).mean], [STATStimecourse1(:).std], 'LineWidth', 2)
hold on; errorbar((1:10)/2-2.5, [STATStimecourse2(:).mean], [STATStimecourse2(:).std], 'r', 'LineWidth', 2)
xlim([-2.5 3])



end


