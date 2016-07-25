k=1; h=figure; colormap jet;
for i=1:10
    hh_cort(k)=subplot('Position',[(i-1)/10 1/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    patch('vertices',cortex00.vert,'faces',cortex00.faces(:,[1 3 2]),'facecolor',[.65 .65 .65],'edgecolor','none');
    axis equal; axis off;
    camlight('headlight','infinite');
    for e=1:length(group_timecourse(i).ipsi_ElecLoc)
        elec = group_timecourse(i).ipsi_ElecLoc{e};
        hold on; plot3(elec(1),elec(2),elec(3),'.','MarkerSize',20, 'Color', getColor( group_timecourse(i).ipsi_ElecValue{e}, [0 3000], colormap ));
    end
    hh_cort(k)=subplot('Position',[(i-1)/10 0 (1/10-0.01) (1/4-0.01)]); k=k+1;
    patch('vertices',cortex00.vert,'faces',cortex00.faces(:,[1 3 2]),'facecolor',[.65 .65 .65],'edgecolor','none');
    axis equal; axis off;
    camlight('headlight','infinite');
    for e=1:length(group_timecourse(i).contra_ElecLoc)
        elec = group_timecourse(i).contra_ElecLoc{e};
        hold on; plot3(elec(1),elec(2),elec(3),'.','MarkerSize',20, 'Color', getColor( group_timecourse(i).contra_ElecValue{e}, [0 3000], colormap ));
    end
end