ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
ICBM_CortLoc_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
unit_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/group_analysis/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

dat_files = dir('*.mat');

V_lfa_ipsi_comm = zeros(length(Vertices),1);
V_lfa_contra_comm = zeros(length(Vertices),1);

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    SS= load(filename);
    
    %left
    if isfield(SS, 'unitsL')
        
        LFAWl = []; %(trials x epochs x contacts)
        LFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsL)
            UU = load([unit_path,SS.unitsL{u},'_LFPresponse']);
            LFAWl = cat(1, LFAWl, squeeze(UU.LFAWl));
            LFAWr = cat(1, LFAWr, squeeze(UU.LFAWr));
        end
        
        p_ipsi=[]; h_ipsi=[];
        p_contra=[]; h_contra=[];
        for contact=1:size(LFAWl,3)
            [h_ipsi(contact), p_ipsi(contact)] = ttest2(squeeze(LFAWl(:,1,contact)),squeeze(LFAWl(:,2,contact)),'Alpha',0.05/size(LFAWl,3));
            [h_contra(contact), p_contra(contact)] = ttest2(squeeze(LFAWr(:,1,contact)),squeeze(LFAWr(:,2,contact)),'Alpha',0.05/size(LFAWr,3));
        end
        
        VL_lfa_ipsi_indiv = zeros(size(SS.VL_indiv));
        %VL_lfa_ipsi_indiv(cell2mat(SS.al))=-log(p_ipsi).*h_ipsi;
        VL_lfa_ipsi_indiv(cell2mat(SS.al))=squeeze((mean(LFAWl(:,2,:),1)-mean(LFAWl(:,1,:),1)))'.*h_ipsi;
        V_lfa_ipsi_comm = V_lfa_ipsi_comm + SS.Wmat*VL_lfa_ipsi_indiv;
        
        VL_lfa_contra_indiv = zeros(size(SS.VL_indiv));
        %VL_lfa_contra_indiv(cell2mat(SS.al))=-log(p_contra).*h_contra;
        VL_lfa_contra_indiv(cell2mat(SS.al))=squeeze((mean(LFAWl(:,2,:),1)-mean(LFAWl(:,1,:),1)))'.*h_contra;
        V_lfa_contra_comm = V_lfa_contra_comm + SS.Wmat*VL_lfa_contra_indiv;
        
        fprintf('%s Left contacts ipsi: %s\n', SS.id, num2str(find(h_ipsi==1)));
        fprintf('%s Left contacts contra: %s\n', SS.id, num2str(find(h_contra==1)));
    end
    
    %right
    if isfield(SS, 'unitsR')
        
        LFAWl = []; %(trials x epochs x contacts)
        LFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsR)
            UU = load([unit_path,SS.unitsR{u},'_LFPresponse']);
            LFAWl = cat(1, LFAWl, squeeze(UU.LFAWl));
            LFAWr = cat(1, LFAWr, squeeze(UU.LFAWr));
        end
        
        p=[]; h=[];
        for contact=1:size(LFAWr,3)
            [h_ipsi(contact), p_ipsi(contact)] = ttest2(squeeze(LFAWr(:,1,contact)),squeeze(LFAWr(:,2,contact)),'Alpha',0.05/size(LFAWr,3));
            [h_contra(contact), p_contra(contact)] = ttest2(squeeze(LFAWl(:,1,contact)),squeeze(LFAWl(:,2,contact)),'Alpha',0.05/size(LFAWl,3));
        end
        
        VR_lfa_ipsi_indiv = zeros(size(SS.VR_indiv));
        %VR_lfa_ipsi_indiv(cell2mat(SS.ar))=-log(p_ipsi).*h_ipsi;
        VR_lfa_ipsi_indiv(cell2mat(SS.ar))=squeeze((mean(LFAWr(:,2,:),1)-mean(LFAWr(:,1,:),1)))'.*h_ipsi;
        V_lfa_ipsi_comm = V_lfa_ipsi_comm + SS.Wmat*VR_lfa_ipsi_indiv;
        
        VR_lfa_contra_indiv = zeros(size(SS.VR_indiv));
        %VR_lfa_contra_indiv(cell2mat(SS.ar))=-log(p_contra).*h_contra;
        VR_lfa_contra_indiv(cell2mat(SS.ar))=squeeze((mean(LFAWl(:,2,:),1)-mean(LFAWl(:,1,:),1)))'.*h_contra;
        V_lfa_contra_comm = V_lfa_contra_comm + SS.Wmat*VR_lfa_contra_indiv;
        
        fprintf('%s Right contacts ipsi: %s\n', SS.id, num2str(find(h_ipsi==1)));
        fprintf('%s Right contacts contra: %s\n', SS.id, num2str(find(h_contra==1)));
    end
end

% plot
figure;
Vraw = V_lfa_ipsi_comm;
%Vraw(find(Vraw~=0)) = 1;
a = find(Vraw~=0);
d = 0.005;
tau = 0.0025;
V = zeros(size(Vraw));
for i =1:length(a)
    
    aconn = find(pdist2(Vertices(a(i),:), Vertices)<=d);
    dconn = pdist2(Vertices(a(i),:), Vertices(aconn,:));
    V(aconn) = V(aconn)+Vraw(a(i))*exp(-dconn/tau)';
    
end
Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', V/(max(V)-min(V)) ,'edgecolor','none','FaceColor','interp');
axis equal
camlight('headlight','infinite');
fh(1)=gcf;
vertnormals = get(Hp,'vertexnormals');
axis off;
colormap jet
Clim = get(gca, 'clim');
colorbar('Ticks', [Clim(1), Clim(2)], 'TickLabels', {num2str(min(V_lfa_ipsi_comm)), num2str(max(V_lfa_ipsi_comm))})
title('IPSI')

% plot
figure;
Vraw = V_lfa_contra_comm;
%Vraw(find(Vraw~=0)) = 1;
a = find(Vraw~=0);
d = 0.005;
tau = 0.0025;
V = zeros(size(Vraw));
for i =1:length(a)
    
    aconn = find(pdist2(Vertices(a(i),:), Vertices)<=d);
    dconn = pdist2(Vertices(a(i),:), Vertices(aconn,:));
    V(aconn) = V(aconn)+Vraw(a(i))*exp(-dconn/tau)';
    
end
Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', V/(max(V)-min(V)) ,'edgecolor','none','FaceColor','interp');
axis equal
camlight('headlight','infinite');
fh(1)=gcf;
vertnormals = get(Hp,'vertexnormals');
axis off;
colormap jet
Clim = get(gca, 'clim');
colorbar('Ticks', [Clim(1), Clim(2)], 'TickLabels', {num2str(min(V_lfa_contra_comm)), num2str(max(V_lfa_contra_comm))})
title('CONTRA')