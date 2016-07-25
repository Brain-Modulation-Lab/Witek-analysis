function h = plot_timecourse3( timecourse, fs, fq, field1, field2, time_range, fq_range, prespike, postspike)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

nframes = length(timecourse);

h=figure; 
colormap jet
k=1;
for i=1:nframes
    hh(k)=subplot('Position',[(i-1)/nframes 3/4 (1/nframes-0.005) (1/4-0.01)]); k=k+1;
    
    tc1 = timecourse(i).(field1)';
%     tc1 = tc1(:);
%     tc1 = arrayfun(@(x) logfun(x), tc1);
%     tc1 = reshape(tc1, size(timecourse(i).(field1)'));
    
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, tc1); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    
    if ~isempty(time_range) || ~isempty(fq_range)
        hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
        hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
        hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
        hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);
        
        STATStimecourse(i).selected = reshape(timecourse(i).(field)(round(fs*(prespike/fs+time_range(1))):round(fs*(prespike/fs+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
        STATStimecourse(i).mean = mean(STATStimecourse(i).selected);
        STATStimecourse(i).std = std(STATStimecourse(i).selected);
    end
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    hh(k)=subplot('Position',[(i-1)/nframes 2/4 (1/nframes-0.005) (1/4-0.01)]); k=k+1;
    
    tc2 = timecourse(i).(field2)';
%     tc2 = tc2(:);
%     tc2 = arrayfun(@(x) logfun(x), tc2);
%     tc2 = reshape(tc2, size(timecourse(i).(field2)'));
    
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, tc2); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    
    if ~isempty(time_range) || ~isempty(fq_range)
        hold on; plot(time_range(1)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
        hold on; plot(time_range(2)*[1 1], fq_range, 'Color', 'w', 'LineWidth', 2);
        hold on; plot(time_range, fq_range(1)*[1 1], 'Color', 'w', 'LineWidth', 2);
        hold on; plot(time_range, fq_range(2)*[1 1], 'Color', 'w', 'LineWidth', 2);
        
        STATStimecourse(i).selected = reshape(timecourse(i).(field)(round(fs*(prespike/fs+time_range(1))):round(fs*(prespike/fs+time_range(2))), find(fq==fq_range(1)):find(fq==fq_range(2))), 1, []);
        STATStimecourse(i).mean = mean(STATStimecourse(i).selected);
        STATStimecourse(i).std = std(STATStimecourse(i).selected);
    end
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
end
CommonCaxis = caxis((hh(1)));
for i=1:(2*nframes)
    thisCaxis = caxis((hh(i)));
    CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
    CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
end
for i=1:(2*nframes)
    caxis(hh(i), CommonCaxis/1.5);
end

if ~isempty(time_range) || ~isempty(fq_range)
    subplot('Position',[0.04 0.04 (1-0.08) (2/4-0.08)]); k=k+1;
    
    %numel(STATStimecourse(1).selected)
    bon=0.05/(numel(STATStimecourse(1).selected));
    thresh=icdf('normal',1-bon,0,1);
    xlim([-2.5 3])
    plot(xlim, thresh*[1 1], 'k', 'LineWidth', 2)
    hold on; errorbar((1:10)/2-2.5, [STATStimecourse(:).mean], [STATStimecourse(:).std], 'LineWidth', 2)
    hold on; errorbar((1:10)/2-2.5, [STATStimecourse(:).mean], [STATStimecourse(:).std], 'r', 'LineWidth', 2)
    xlim([-2.5 3])
end



end


