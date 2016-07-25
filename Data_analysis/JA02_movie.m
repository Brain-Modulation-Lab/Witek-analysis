
PowerTrials = MeanPowerTrialsTstat;

nframes=200;

binsize=floor((size(PowerTrials,1)-1000)/nframes);

for t=1:nframes
    Value(t,:) = squeeze(mean(mean(PowerTrials((500+binsize*(t-1)+1):(500+binsize*t),findfreq(50,185,fq),:),1),2))';
end


ValueRange(1)=min(min(Value));
ValueRange(2)=max(max(Value));
ValueRange = [-max(abs(ValueRange)), max(abs(ValueRange))];


Value = (Value - ValueRange(1))/(ValueRange(2)-ValueRange(1));

Val = Value;

figure;
colormap jet;

d = 5;
de = 0.6;
tau = 1.2;
cm = colormap;

a = cell2mat(al);

clear M
for t=1:200
    
    
    V = zeros(length(cortex.vert),1);
    V_color = 0.85*ones(length(cortex.vert),3);
    
    for v = 1:length(a)
        aeconn = find(pdist2(cortex.vert(a(v),:), cortex.vert)<=de);
        aconn = find(pdist2(cortex.vert(a(v),:), cortex.vert)>de & ...
            pdist2(cortex.vert(a(v),:), cortex.vert)<=d);
        dconn = pdist2(cortex.vert(a(v),:), cortex.vert(aconn,:));
        V(aeconn) = V(aeconn)+Val(t,v);
        V(aconn) = V(aconn)+Val(t,v)*exp(-(dconn-de)/tau)';
    end
    
    for v = find(V~=0)'
        V_color(v,:) = getColor(V(v), [0 1], cm);
    end

    if t==1

        hh_Vtrace = subplot('Position',[0 2/4 1 1/4-0.01]);
        plot(Vtrace(1:(t*120000/200))); xlim([0 120000]);  ylim([-80 60]);
        axis off;
        
        hh(1)=subplot('Position',[0 0.01 1 2/4-0.01]);
        Hp = patch('vertices',cortex.vert,'faces',cortex.tri,'FaceVertexCData', V_color,'edgecolor','none','FaceColor','interp');
        %text(0, -.1, .09, 'IPSILATERAL', 'color', 'k', 'FontSize', 16, 'HorizontalAlignment', 'center')
        axis equal
        camlight('headlight','infinite');
        axis off;
        colormap jet
        set(gca,'CameraPosition',DispCamPos.cp,...
            'CameraTarget',DispCamPos.ct,...
            'CameraViewAngle',DispCamPos.cva,...
            'CameraUpVector',DispCamPos.uv);
        %camzoom(1.5)
        M(t) = getframe(gcf);
        

    else
        t
        axes(hh_Vtrace);
        plot(Vtrace(1:(t*120000/200))); xlim([0 120000]);  ylim([-80 60]); axis off;
        
        set(Hp,'FaceVertexCData',V_color);
        
        M(t) = getframe(gcf);
    end
    pause(0.01)
end