subject_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/';
FS_subject_path = '/Users/Witek/Dropbox/electrode_imaging/Fluoro_Imaging/Subjects/';
ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
output_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

% fndvert = {@(A,B) min(pdist2(A,B));...
%     @(A,B) B(A,:);...
%     @(A,B,C) find(uint16(round(pdist2(A,B)))'<C);};

for s=1:length(subjects)
    fprintf('%s...', subjects{s});
    
    subject=load([subject_path,subjects{s},'/tess_cortex_pial_high.mat'],'Reg','Atlas','Faces','Vertices');
    [Wmat]=S(Faces,Vertices,Reg,Atlas,subject);
    
    save([output_path,subjects{s}], 'Wmat');
    
    SS = load([FS_subject_path,subjects{s},'_FS/cortex_indiv']);
    cortex = SS.cortex;
    
%left
    if exist([FS_subject_path,subjects{s},'_FS/Electrode_Locations/FinalLoc/CortElecL.mat'])
        SS = load([FS_subject_path,subjects{s},'_FS/Electrode_Locations/FinalLoc/CortElecL']);
        CortElecLocL = SS.CortElecLoc;
        [~,al]  = cellfun(@(A,B) min(pdist2(A,B)), CortElecLocL', repmat({cortex.vert}, size(CortElecLocL',1),1), 'uniformoutput', false );
        %ElecVertsL = cellfun(@(A,B) B(A,:), al, repmat({cortex.vert}, size(al,1),1), 'uniformoutput', false )';
        VL_indiv = zeros(length(cortex.vert),1);
        VL_indiv(cell2mat(al))=1;
        VL_comm = Wmat*VL_indiv;
        
       % get mean coordinate of each electrode's common brain location
       clear ElecLocCML;
       for i=1:length(al)
           Vtemp = zeros(length(cortex.vert),1);
           Vtemp(al{i})=1;
           Vtemp = Wmat*Vtemp;
           nzidx = find(Vtemp~=0);
           ElecLocCML{i} = (Vertices(nzidx,:)'*(Vtemp(nzidx)/sum(Vtemp(nzidx))))';
       end
        
        save([output_path,subjects{s}], 'CortElecLocL', 'ElecLocCML', 'VL_indiv', 'VL_comm', 'al', '-append');
    end
        
%right
    if exist([FS_subject_path,subjects{s},'_FS/Electrode_Locations/FinalLoc/CortElecR.mat'])
        SS = load([FS_subject_path,subjects{s},'_FS/Electrode_Locations/FinalLoc/CortElecR']);
        CortElecLocR = SS.CortElecLoc;
        [~,ar]  = cellfun(@(A,B) min(pdist2(A,B)), CortElecLocR', repmat({cortex.vert}, size(CortElecLocR',1),1), 'uniformoutput', false );
        %ElecVertsR = cellfun(@(A,B) B(A,:), ar, repmat({cortex.vert}, size(ar,1),1), 'uniformoutput', false )';
        VR_indiv = zeros(length(cortex.vert),1);
        VR_indiv(cell2mat(ar))=1;
        VR_comm = Wmat*VR_indiv;
        
       % get mean coordinate of each electrode's common brain location
       clear ElecLocCMR;
       for i=1:length(ar)
           Vtemp = zeros(length(cortex.vert),1);
           Vtemp(ar{i})=1;
           Vtemp = Wmat*Vtemp;
           nzidx = find(Vtemp~=0);
           ElecLocCMR{i} = (Vertices(nzidx,:)'*(Vtemp(nzidx)/sum(Vtemp(nzidx))))';
       end
        
        save([output_path,subjects{s}], 'CortElecLocR', 'ElecLocCMR', 'VR_indiv', 'VR_comm', 'ar', '-append');
    end

    
    fprintf(' done\n');
end



% dat_files = dir('*.mat');
% 
% V_comm = zeros(length(Vertices),1);
% 
% for i=1:length(dat_files)
%     
%     filename=dat_files(i).name;
%     
%     SS= load(filename, 'VL_comm', 'VR_comm');
%     
%     if isfield(SS, 'VL_comm')
%         V_comm = V_comm + SS.VL_comm;
%     end
%     if isfield(SS, 'VR_comm')
%         V_comm = V_comm + SS.VR_comm;
%     end
% end
% 
% V_comm(find(V_comm~=0)) = 1;