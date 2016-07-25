ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
ICBM_CortLoc_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
unit_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/group_analysis/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

dat_files = dir('*.mat');

epoch = 2;

V_lfa_comm = zeros(length(Vertices),1);

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    SS= load(filename);
    
    %left
    if isfield(SS, 'unitsL')
        
        LFAWl = []; %(trials x epochs x contacts)
        LFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsL)
            UU = load([unit_path,SS.unitsL{u},'_LFPresponse']);
            LFAWl = cat(1, LFAWl, squeeze(UU.LFAWl(:,epoch,:)));
            LFAWr = cat(1, LFAWr, squeeze(UU.LFAWr(:,epoch,:)));
        end
        
        p=[]; h=[];
        for contact=1:size(LFAWr,2)
            [h(contact), p(contact)] = ttest2(LFAWl(:,contact),LFAWr(:,contact),'Alpha',0.05/size(LFAWr,2));
        end
        
        VL_lfa_indiv = zeros(size(SS.VL_indiv));
        %VL_lfa_indiv(cell2mat(SS.al))=-log(p).*h;
        VL_lfa_indiv(cell2mat(SS.al))=squeeze((mean(LFAWr,1)-mean(LFAWl,1))).*h;
        V_lfa_comm = V_lfa_comm + SS.Wmat*VL_lfa_indiv;
        
        fprintf('%s Left contacts: %s\n', SS.id, num2str(find(h==1)));
    end
    
    %right
    if isfield(SS, 'unitsR')
        
        LFAWl = []; %(trials x epochs x contacts)
        LFAWr = []; %(trials x epochs x contacts)
        for u = 1:length(SS.unitsR)
            UU = load([unit_path,SS.unitsR{u},'_LFPresponse']);
            LFAWl = cat(1, LFAWl, squeeze(UU.LFAWl(:,epoch,:)));
            LFAWr = cat(1, LFAWr, squeeze(UU.LFAWr(:,epoch,:)));
        end
        
%         if strcmp(SS.id,'VK052715')
%            disp('debug') 
%         end
        
        p=[]; h=[];
        for contact=1:size(LFAWr,2)
            [h(contact), p(contact)] = ttest2(LFAWl(:,contact),LFAWr(:,contact),'Alpha',0.05/size(LFAWr,2));
        end
        
        VR_lfa_indiv = zeros(size(SS.VR_indiv));
        %VR_lfa_indiv(cell2mat(SS.ar))=-log(p).*h;
        VR_lfa_indiv(cell2mat(SS.ar))=squeeze((mean(LFAWl,1)-mean(LFAWr,1))).*h;
        V_lfa_comm = V_lfa_comm + SS.Wmat*VR_lfa_indiv;
        
        fprintf('%s Right contacts: %s\n', SS.id, num2str(find(h==1)));
    end
end

% plot
figure;
Vraw = V_lfa_comm;
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
colorbar('Ticks', [-1 0 1], 'TickLabels', {num2str(min(V_lfa_comm)), 0, num2str(max(V_lfa_comm))})