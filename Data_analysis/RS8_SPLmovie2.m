


% for t=1:200
%     for contact=1:4
%         LowB_L(t,contact) = mean(mean(timecourse(contact).SPL_LR(t).zplf(200:300,9:21)));
%         LowB_R(t,contact) = mean(mean(timecourse(contact).SPL_RR(t).zplf(200:300,9:21)));
%         HiB_L(t,contact) = mean(mean(timecourse(contact).SPL_LR(t).zplf(200:300,22:37)));
%         HiB_R(t,contact) = mean(mean(timecourse(contact).SPL_RR(t).zplf(200:300,22:37)));
%     end
% end
% 
% minLowB = min([ min(min(LowB_L)) min(min(LowB_R)) ]);
% rangeLowB = max([ max(max(LowB_L)) max(max(LowB_R)) ]) - min([ min(min(LowB_L)) min(min(LowB_R)) ]);
% minHiB = min([ min(min(HiB_L)) min(min(HiB_R)) ]);
% rangeHiB = max([ max(max(HiB_L)) max(max(HiB_R)) ]) - min([ min(min(HiB_L)) min(min(HiB_R)) ]);
% 
% for t=1:200
%     for contact=1:4
%         LowB_L(t,contact) = (LowB_L(t,contact) - minLowB)/rangeLowB;
%         LowB_R(t,contact) = (LowB_R(t,contact) - minLowB)/rangeLowB;
%         HiB_L(t,contact) = (HiB_L(t,contact) - minHiB)/rangeHiB;
%         HiB_R(t,contact) = (HiB_R(t,contact) - minHiB)/rangeHiB;
%     end
% end

Vraw = VL_indiv;
d = 0.01;
tau = 0.005;

a = cell2mat(al);

figure; 
clear M
for t=1:200

    VL = zeros(size(Vraw));
    VR = zeros(size(Vraw));
    VL_color = 0.75*ones(length(Vraw),3);
    VR_color = 0.75*ones(length(Vraw),3);
    
    for v = 1:length(a)
        aconn = find(pdist2(subject.Vertices(a(v),:), subject.Vertices)<=d);
        dconn = pdist2(subject.Vertices(a(v),:), subject.Vertices(aconn,:));

         VL(aconn) = VL(aconn)+LowB_L(t,v)*exp(-dconn/tau)';
         VR(aconn) = VR(aconn)+LowB_R(t,v)*exp(-dconn/tau)';

    end
    
    for v = find(VL~=0)'
        VL_color(v,:) = getColor(VL(v), [0 1], cm);
    end
    for v = find(VR~=0)'
        VR_color(v,:) = getColor(VR(v), [0 1], cm);
    end

    
    if t==1
        hh_Ftrace = subplot('Position',[0 3/4 1 1/4]);
%         xlim([-1 1]); ylim([-1 1]);
%         h_text = text(0, 0, num2str(10*(t-1)/200-5), 'FontSize', 16);
        plot(ForceTrace, 'color', [0.75 0.75 0.75], 'LineWidth', 2); 
        xlim([0 10001]); ylim([-10 510]); hold on;
        plot(ForceTrace(1:(t*10000/200)), 'color', 'r', 'LineWidth', 2);
        axis off;
        
        hh_Vtrace = subplot('Position',[0 2/4 1 1/4-0.01]);
        plot(Vtrace(1:(t*300000/200))); xlim([0 300001]);  ylim([-1000 2000]); 
        axis off;
        
        hh(1)=subplot('Position',[0.01 0.01 (1/2-0.02) 2/4-0.01]);
        HpL = patch('vertices',subject.Vertices,'faces',subject.Faces,'FaceVertexCData', VL_color,'edgecolor','none','FaceColor','interp');
        text(0, -.1, .09, 'IPSILATERAL', 'color', 'k', 'FontSize', 16, 'HorizontalAlignment', 'center')
        axis equal
        camlight('headlight','infinite');
        axis off;
        colormap jet
        set(gca,'cameraposition',CamPos)
        %camzoom(1.5)
        M(t) = getframe(gcf);
        
        hh(2)=subplot('Position',[1/2+0.01 0.01 (1/2-0.02) 2/4-0.01]);
        HpR = patch('vertices',subject.Vertices,'faces',subject.Faces,'FaceVertexCData', VR_color,'edgecolor','none','FaceColor','interp');
        text(0, -.1, .09, 'CONTRALATERAL', 'color', 'k', 'FontSize', 16, 'HorizontalAlignment', 'center');
        axis equal
        camlight('headlight','infinite');
        axis off;
        colormap jet
        set(gca,'cameraposition',CamPos)
        %camzoom(1.5)
        M(t) = getframe(gcf);
    else
        %h_text.String = num2str(10*(t-1)/200-5);
        axes(hh_Ftrace);
%         plot(ForceTrace, 'color', [0.75 0.75 0.75], 'LineWidth', 2); 
%         xlim([0 10001]); ylim([-10 510]); hold on;
        plot(ForceTrace(1:(t*10000/200)), 'color', 'r', 'LineWidth', 2);
        axis off;
        axes(hh_Vtrace);
        plot(Vtrace(1:(t*300000/200))); xlim([0 300001]);  ylim([-1000 2000]); axis off;
        set(HpL,'FaceVertexCData',VL_color);
        set(HpR,'FaceVertexCData',VR_color);
        M(t) = getframe(gcf);
    end
    pause(0.01)
end