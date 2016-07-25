ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
ICBM_CortLoc_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
unit_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/group_analysis/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

dat_files = dir('*.mat');

V_hfa_ipsi_comm = zeros(length(Vertices),1);
V_hfa_contra_comm = zeros(length(Vertices),1);


    
    %left

        
        HFAWl = []; %(trials x epochs x contacts)
        HFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsL)
            UU = load([unit_path,SS.unitsL{u},'_LFPresponse']);
            HFAWl = cat(1, HFAWl, squeeze(UU.HFAWl));
            HFAWr = cat(1, HFAWr, squeeze(UU.HFAWr));
        end
        
        p_ipsi=[]; h_ipsi=[];
        p_contra=[]; h_contra=[];
        for contact=1:size(HFAWl,3)
            [h_ipsi(contact), p_ipsi(contact)] = ttest2(squeeze(HFAWl(:,1,contact)),squeeze(HFAWl(:,2,contact)),'Alpha',0.05/size(HFAWl,3));
            [h_contra(contact), p_contra(contact)] = ttest2(squeeze(HFAWr(:,1,contact)),squeeze(HFAWr(:,2,contact)),'Alpha',0.05/size(HFAWr,3));
        end
        
        VL_hfa_ipsi_indiv = zeros(size(SS.VL_indiv));
        %VL_hfa_ipsi_indiv(cell2mat(SS.al))=-log(p_ipsi).*h_ipsi;
        VL_hfa_ipsi_indiv(cell2mat(SS.al))=squeeze((mean(HFAWl(:,2,:),1)-mean(HFAWl(:,1,:),1)))'.*h_ipsi;
        V_hfa_ipsi_comm = V_hfa_ipsi_comm + SS.Wmat*VL_hfa_ipsi_indiv;
        
        VL_hfa_contra_indiv = zeros(size(SS.VL_indiv));
        %VL_hfa_contra_indiv(cell2mat(SS.al))=-log(p_contra).*h_contra;
        VL_hfa_contra_indiv(cell2mat(SS.al))=squeeze((mean(HFAWr(:,2,:),1)-mean(HFAWr(:,1,:),1)))'.*h_contra;
        V_hfa_contra_comm = V_hfa_contra_comm + SS.Wmat*VL_hfa_contra_indiv;
        
        fprintf('%s Left contacts ipsi: %s\n', SS.id, num2str(find(h_ipsi==1)));
        fprintf('%s Left contacts contra: %s\n', SS.id, num2str(find(h_contra==1)));

    
    %right

        
        HFAWl = []; %(trials x epochs x contacts)
        HFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsR)
            UU = load([unit_path,SS.unitsR{u},'_LFPresponse']);
            HFAWl = cat(1, HFAWl, squeeze(UU.HFAWl));
            HFAWr = cat(1, HFAWr, squeeze(UU.HFAWr));
        end
        
        p=[]; h=[];
        for contact=1:size(HFAWr,3)
            [h_ipsi(contact), p_ipsi(contact)] = ttest2(squeeze(HFAWr(:,1,contact)),squeeze(HFAWr(:,2,contact)),'Alpha',0.05/size(HFAWr,3));
            [h_contra(contact), p_contra(contact)] = ttest2(squeeze(HFAWl(:,1,contact)),squeeze(HFAWl(:,2,contact)),'Alpha',0.05/size(HFAWl,3));
        end
        
        VR_hfa_ipsi_indiv = zeros(size(VR_indiv));
        %VR_hfa_ipsi_indiv(cell2mat(ar))=-log(p_ipsi).*h_ipsi;
        VR_hfa_ipsi_indiv(cell2mat(ar))=squeeze((mean(HFAWr(:,2,:),1)-mean(HFAWr(:,1,:),1)))';
        V_hfa_ipsi_comm = V_hfa_ipsi_comm + Wmat*VR_hfa_ipsi_indiv;
        
        VR_hfa_contra_indiv = zeros(size(VR_indiv));
        %VR_hfa_contra_indiv(cell2mat(ar))=-log(p_contra).*h_contra;
        VR_hfa_contra_indiv(cell2mat(ar))=squeeze((mean(HFAWl(:,2,:),1)-mean(HFAWl(:,1,:),1)))';
        V_hfa_contra_comm = V_hfa_contra_comm + Wmat*VR_hfa_contra_indiv;
        
        fprintf('%s Right contacts ipsi: %s\n', SS.id, num2str(find(h_ipsi==1)));
        fprintf('%s Right contacts contra: %s\n', SS.id, num2str(find(h_contra==1)));


% plot
figure;
Vraw = V_hfa_ipsi_comm;
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
colorbar('Ticks', [Clim(1), Clim(2)], 'TickLabels', {num2str(min(V_hfa_ipsi_comm)), num2str(max(V_hfa_ipsi_comm))})
title('IPSI')

% plot
figure;
Vraw = VR_lfa_contra_indiv;
%Vraw(find(Vraw~=0)) = 1;
a = find(Vraw~=0);
d = 0.005;
tau = 0.0025;
V = zeros(size(Vraw));
for i =1:length(a)
    
    aconn = find(pdist2(subject.Vertices(a(i),:), subject.Vertices)<=d);
    dconn = pdist2(subject.Vertices(a(i),:), subject.Vertices(aconn,:));
    V(aconn) = V(aconn)+Vraw(a(i))*exp(-dconn/tau)';
    
end
Hp = patch('vertices',subject.Vertices,'faces',subject.Faces,'FaceVertexCData', V/(max(V)-min(V)),'edgecolor','none','FaceColor','interp');
axis equal
camlight('headlight','infinite');
fh(1)=gcf;
vertnormals = get(Hp,'vertexnormals');
axis off;
colormap jet
Clim = get(gca, 'clim');
colorbar('Ticks', [Clim(1) Clim(2)], 'TickLabels', {num2str(min(Vraw)), num2str(max(Vraw))})
title('CONTRA')