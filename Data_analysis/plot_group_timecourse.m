function h = plot_group_timecourse( timecourse, cortex00, field1, field2, fs, fq, prespike, postspike)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

h=figure;
k=1; j=1;
for i=1:10
    hh(k)=subplot('Position',[(i-1)/10 3/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(5:end), timecourse(i).(field1)(:,5:end)'); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
   
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    hh(k)=subplot('Position',[(i-1)/10 2/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(5:end), timecourse(i).(field2)(:,5:end)'); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w')
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
    hh_cort(j)=subplot('Position',[(i-1)/10 1/4 (1/10-0.01) (1/4-0.01)]); j=j+1;
    patch('vertices',cortex00.vert,'faces',cortex00.faces(:,[1 3 2]),'facecolor',[.65 .65 .65],'edgecolor','none');
    axis equal; axis off;
    camlight('headlight','infinite');
    for e=1:length(timecourse(i).ipsi_ElecLoc)
        elec = timecourse(i).ipsi_ElecLoc{e};
        hold on; plot3(elec(1),elec(2),elec(3),'.','MarkerSize',20, 'Color', getColor( timecourse(i).ipsi_ElecValue{e}, [0 3000], colormap ));
    end
    hh_cort(j)=subplot('Position',[(i-1)/10 0 (1/10-0.01) (1/4-0.01)]); j=j+1;
    patch('vertices',cortex00.vert,'faces',cortex00.faces(:,[1 3 2]),'facecolor',[.65 .65 .65],'edgecolor','none');
    axis equal; axis off;
    camlight('headlight','infinite');
    for e=1:length(timecourse(i).contra_ElecLoc)
        elec = timecourse(i).contra_ElecLoc{e};
        hold on; plot3(elec(1),elec(2),elec(3),'.','MarkerSize',20, 'Color', getColor( timecourse(i).contra_ElecValue{e}, [0 3000], colormap ));
    end
    
end
CommonCaxis = caxis((hh(1)));
for i=1:20
    thisCaxis = caxis((hh(i)));
    CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
    CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
end
for i=1:20
    caxis(hh(i), CommonCaxis/4);
end

end


