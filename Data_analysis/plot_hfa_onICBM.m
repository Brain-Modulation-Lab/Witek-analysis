ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
ICBM_CortLoc_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
unit_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/group_analysis/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

dat_files = dir('*.mat');

epoch = 2;

V_hfa_comm = zeros(length(Vertices),1);

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    SS= load(filename);
    
    %left
    if isfield(SS, 'unitsL')
        
        HFAWl = []; %(trials x epochs x contacts)
        HFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsL)
            UU = load([unit_path,SS.unitsL{u},'_LFPresponse']);
            HFAWl = cat(1, HFAWl, squeeze(UU.HFAWl(:,epoch,:)));
            HFAWr = cat(1, HFAWr, squeeze(UU.HFAWr(:,epoch,:)));
        end
        
        p=[]; h=[];
        for contact=1:size(HFAWr,2)
            [h(contact), p(contact)] = ttest2(HFAWl(:,contact),HFAWr(:,contact),'Alpha',0.05/size(HFAWr,2));
        end
        
        VL_hfa_indiv = zeros(size(SS.VL_indiv));
        %VL_hfa_indiv(cell2mat(SS.al))=-log(p).*h;
        VL_hfa_indiv(cell2mat(SS.al))=squeeze((mean(HFAWr,1)-mean(HFAWl,1)).*h);
        V_hfa_comm = V_hfa_comm + SS.Wmat*VL_hfa_indiv;
        
        fprintf('%s Left contacts: %s\n', SS.id, num2str(find(h==1)));
    end
    
    %right
    if isfield(SS, 'unitsR')
        
        HFAWl = []; %(trials x epochs x contacts)
        HFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsR)
            UU = load([unit_path,SS.unitsR{u},'_LFPresponse']);
            HFAWl = cat(1, HFAWl, squeeze(UU.HFAWl(:,epoch,:)));
            HFAWr = cat(1, HFAWr, squeeze(UU.HFAWr(:,epoch,:)));
        end
        
%         if strcmp(SS.id,'VK052715')
%            disp('debug') 
%         end
        
        p=[]; h=[];
        for contact=1:size(HFAWr,2)
            [h(contact), p(contact)] = ttest2(HFAWl(:,contact),HFAWr(:,contact),'Alpha',0.05/size(HFAWr,2));
        end
        
        VR_hfa_indiv = zeros(size(SS.VR_indiv));
        %VR_hfa_indiv(cell2mat(SS.ar))=-log(p).*h;
        VR_hfa_indiv(cell2mat(SS.ar))=squeeze((mean(HFAWl,1)-mean(HFAWr,1))).*h;
        V_hfa_comm = V_hfa_comm + SS.Wmat*VR_hfa_indiv;
        
        fprintf('%s Right contacts: %s\n', SS.id, num2str(find(h==1)));
    end
end

% plot
figure;
Vraw = V_hfa_comm;
a = find(Vraw~=0);
d = 0.005;
tau = 0.0025;
V = zeros(size(Vraw));
for i =1:length(a)
    
    aconn = find(pdist2(Vertices(a(i),:), Vertices)<=d);
    dconn = pdist2(Vertices(a(i),:), Vertices(aconn,:));
    V(aconn) = V(aconn)+Vraw(a(i))*exp(-dconn/tau)';
    
end
Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', V/(max(V)-min(V)),'edgecolor','none','FaceColor','interp');
axis equal
camlight('headlight','infinite');
fh(1)=gcf;
vertnormals = get(Hp,'vertexnormals');
axis off;
colormap jet
colorbar('Ticks', [-1 0 1], 'TickLabels', {num2str(min(V_hfa_comm)), 0, num2str(max(V_hfa_comm))})