function h = plot_timecourse_movie( timecourse1, timecourse2, fs, fq, field, prespike, postspike, title_text)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

CommonCaxis=[0,0];
for i=1:length(timecourse1)
    CommonCaxis(1)=min( CommonCaxis(1), min(min(timecourse1(1).(field))));
    CommonCaxis(2)=max( CommonCaxis(1), max(max(timecourse1(1).(field))));
end
for i=1:length(timecourse2)
    CommonCaxis(1)=min( CommonCaxis(1), min(min(timecourse2(1).(field))));
    CommonCaxis(2)=max( CommonCaxis(1), max(max(timecourse2(1).(field))));
end

h=figure;
hh(1)=subplot('Position',[0.01 0.01 (1/2-0.02) (1-0.02)]);
hh(2)=subplot('Position',[1/2+0.01 0.01 (1/2-0.02) (1-0.02)]);

k=1;
for i=1:length(timecourse1)
    
    axes(hh(1));
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, timecourse1(i).(field)');
    set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    
    x1limits = get(hh(1), 'xlim');
    set(hh(1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(1), 'ylim');
    set(hh(1), 'ytick', y1limits(1)-1);
    caxis(hh(1), CommonCaxis);
    
    text(-.4, 35, num2str(10*(i-1)/200-5), 'FontSize', 20, 'Color', 'w')

    axes(hh(2));
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, timecourse2(i).(field)');
    set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    
    x1limits = get(hh(2), 'xlim');
    set(hh(2), 'xtick', x1limits(1)-1);
    y1limits = get(hh(2), 'ylim');
    set(hh(2), 'ytick', y1limits(1)-1);
    caxis(hh(2), CommonCaxis);
    
    pause(0.0001);
end


end


