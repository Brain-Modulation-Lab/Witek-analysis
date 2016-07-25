function [h] = plot_group_timecourse5( timecourse, field1, field2, fs, fq, prespike, postspike)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

nframes=1;

h=figure; colormap jet
k=1; j=1;
for i=1:nframes
    hh(k)=subplot('Position',[(i-1)/nframes 2/3 (1/nframes-0.005) (1/3-0.05)]); k=k+1;
    %M = timecourse(i).(field1)(:,1:end,:); M(M>0)=1; M = sum(M,3)';
    M = mean(timecourse(i).(field1)(:,1:end,:),3)'; % M = log10(timecourse(i).(field1)(:,1:end))'; M(M==-Inf) = 0; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(1:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); 
    %hold on; plot([0 0], ylim, '-', 'Color', 'k');
    hold on; plot(xlim, 25*[1 1], ':', 'Color', 'w');
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
    hh(k)=subplot('Position',[(i-1)/nframes 1/3 (1/nframes-0.005) (1/3-0.05)]); k=k+1;
    %M = timecourse(i).(field2)(:,1:end,:); M(M>0)=1; M = sum(M,3)';
    M = mean(timecourse(i).(field2)(:,1:end,:),3)'; % M = log10(timecourse(i).(field2)(:,1:end))'; M(M==-Inf) = 0; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(1:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); 
    %hold on; plot([0 0], ylim, '-', 'Color', 'k')
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
%     hh(k)=subplot('Position',[(i-1)/nframes 0 (1/nframes-0.005) (1/3-0.05)]); k=k+1;
%     M = mean(timecourse(i).(field2)(:,1:end,:),3)'- mean(timecourse(i).(field1)(:,1:end,:),3)'; % M = log10(timecourse(i).(field2)(:,1:end))'; M(M==-Inf) = 0; %
%     imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(1:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, '-', 'Color', 'k')
%     
%     x1limits = get(hh(k-1), 'xlim');
%     set(hh(k-1), 'xtick', x1limits(1)-1);
%     y1limits = get(hh(k-1), 'ylim');
%     set(hh(k-1), 'ytick', y1limits(1)-1);
end
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


