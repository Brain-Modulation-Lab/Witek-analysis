function h = plot_timecourse2( timecourse1, timecourse2, fs, fq, field, prespike, postspike, title_text)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

h=figure;  subplot('Position',[0 3/4 (1-0.01) (1/4-0.01)]); 
xlim([-1 1]); ylim([-1 1]); text(0, 0, title_text); axis off;
k=1;
for i=1:4
    hh(k)=subplot('Position',[(i-1)/4 2/4 (1/4-0.01) (1/4-0.01)]); k=k+1;
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, timecourse1(i).(field)');
    set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
    hh(k)=subplot('Position',[(i-1)/4 1/4 (1/4-0.01) (1/4-0.01)]); k=k+1;
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, timecourse2(i).(field)');
    set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
end
CommonCaxis = caxis((hh(1)));
for i=1:8
    thisCaxis = caxis((hh(i)));
    CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
    CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
end
for i=1:8
    caxis(hh(i), CommonCaxis);
end

end


