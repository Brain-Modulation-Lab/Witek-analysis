function [h, hh_cort] = plot_group_timecourse_ICBM( timecourse, Vertices, Faces, field1, field2, fs, fq, prespike, postspike)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

prespike = round(prespike*fs);
postspike = round(postspike*fs);

h=figure;
k=1; j=1;
for i=1:10
    hh(k)=subplot('Position',[(i-1)/10 3/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    M = log10(timecourse(i).(field1))'; M(M==-Inf) = 0;% M = timecourse(i).(field1)(:,5:end)'; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(5:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
   
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    hh(k)=subplot('Position',[(i-1)/10 2/4 (1/10-0.01) (1/4-0.01)]); k=k+1;
    M = log10(timecourse(i).(field2))'; M(M==-Inf) = 0; %M = timecourse(i).(field2)(:,5:end)'; %
    imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq(5:end), M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w')
    
    x1limits = get(hh(k-1), 'xlim');
    set(hh(k-1), 'xtick', x1limits(1)-1);
    y1limits = get(hh(k-1), 'ylim');
    set(hh(k-1), 'ytick', y1limits(1)-1);
    
     hh_cort(j)=0%subplot('Position',[(i-1)/10 1/4 (1/10-0.01) (1/4-0.01)]); j=j+1;
% 
%     Vraw = timecourse(i).ipsi_Vcomm;
%     a = find(Vraw~=0); %Vraw(a) = log(1+Vraw(a));
%     d = 0.005;
%     tau = 0.0025;
%     V = zeros(size(Vraw));
%     for v =1:length(a)
%         
%         aconn = find(pdist2(Vertices(a(v),:), Vertices)<=d);
%         dconn = pdist2(Vertices(a(v),:), Vertices(aconn,:));
%         V(aconn) = V(aconn)+Vraw(a(v))*exp(-dconn/tau)';
%         
%     end
%     Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', V/(max(V)-min(V)),'edgecolor','none','FaceColor','interp');
%     axis equal
%     camlight('headlight','infinite');
%     fh(1)=gcf;
%     vertnormals = get(Hp,'vertexnormals');
%     axis off;
%     colormap jet
%     
     hh_cort(j)=0%subplot('Position',[(i-1)/10 0 (1/10-0.01) (1/4-0.01)]); j=j+1;
% 
%     Vraw = timecourse(i).contra_Vcomm;  
%     a = find(Vraw~=0); %Vraw(a) = log10(1+Vraw(a)); 
%     d = 0.005;
%     tau = 0.0025;
%     V = zeros(size(Vraw));
%     for v =1:length(a)
%         
%         aconn = find(pdist2(Vertices(a(v),:), Vertices)<=d);
%         dconn = pdist2(Vertices(a(v),:), Vertices(aconn,:));
%         V(aconn) = V(aconn)+Vraw(a(v))*exp(-dconn/tau)';
%         
%     end
%     Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', V/(max(V)-min(V)),'edgecolor','none','FaceColor','interp');
%     axis equal
%     camlight('headlight','infinite');
%     fh(1)=gcf;
%     vertnormals = get(Hp,'vertexnormals');
%     axis off;
     colormap jet
    
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

end


