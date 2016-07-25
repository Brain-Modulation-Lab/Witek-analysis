function [h, hh_cort] = plot_group_timecourse2_ICBM( timecourse, Vertices, Faces, field1, field2, fs, fq, prespike, postspike)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

h=figure;
k=1; j=1;
for i=1:4
    hh(k)=subplot('Position',[(i-1)/4 3/4 (1/4-0.01) (1/4-0.01)]); k=k+1;
    M = timecourse(i).(field1)(:,9:end)'/timecourse(i).([field1,'Count']); % M = log10(timecourse(i).(field1)(:,9:end))'; M(M==-Inf) = 0; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(9:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
   
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    hh(k)=subplot('Position',[(i-1)/4 2/4 (1/4-0.01) (1/4-0.01)]); k=k+1;
    M = timecourse(i).(field2)(:,9:end)'/timecourse(i).([field1,'Count']); % M = log10(timecourse(i).(field2)(:,9:end))'; M(M==-Inf) = 0; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(9:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w')
    
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


