subject_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/';
FS_subject_path = '/Users/Witek/Dropbox/electrode_imaging/Fluoro_Imaging/Subjects/';
ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
output_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

% fndvert = {@(A,B) min(pdist2(A,B));...
%     @(A,B) B(A,:);...
%     @(A,B,C) find(uint16(round(pdist2(A,B)))'<C);};

k=0;
for s=to_do
    k=k+1;
    fprintf('%s...', BS_subjects{k});
    
    subject=load([subject_path,BS_subjects{k},'/tess_cortex_pial_high.mat'],'Reg','Atlas','Faces','Vertices');
    [Wmat]=S(Faces,Vertices,Reg,Atlas,subject);
    
    save([output_path,BS_subjects{k}], 'Wmat');
    
    SS = load([FS_subject_path,subjects.id{s},'_FS/cortex_indiv']);
    cortex = SS.cortex;
    
    h(k) = figure;
    Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', CData ,'edgecolor','none','FaceColor','interp');
    axis equal
    camlight('headlight','infinite');
    fh(1)=gcf;
    vertnormals = get(Hp,'vertexnormals');
    axis off;
    colormap jet
    
    if ~isempty(subjects.LeftLoc_path{s})
        SS = load([FS_subject_path,subjects.id{s},'/Electrode_Locations/SPL_Electrodes/',subjects.LeftLoc_path{s}]);
        CortElecLocL = SS.CortElecLoc;
        [~,al]  = cellfun(fndvert{1}, CortElecLocL', repmat({cortex.vert}, size(CortElecLocL',1),1), 'uniformoutput', false );
        ElecVertsL = cellfun(fndvert{2}, al, repmat({cortex.vert}, size(al,1),1), 'uniformoutput', false )';
        VL_indiv = zeros(length(cortex.vert),1);
        VL_indiv(cell2mat(al))=1;
        VL_comm = Wmat*VL_indiv;
        
        save([output_path,BS_subjects{k}], 'CortElecLocL', 'VL_indiv', 'VL_comm', 'al', '-append');
        
    end
    if ~isempty(subjects.RightLoc_path{s})
        SS = load([FS_subject_path,subjects.id{s},'/Electrode_Locations/SPL_Electrodes/',subjects.RightLoc_path{s}]);
        CortElecLocR = SS.CortElecLoc;
        [~,ar]  = cellfun(fndvert{1}, CortElecLocR', repmat({cortex.vert}, size(CortElecLocR',1),1), 'uniformoutput', false );
        ElecVertsL = cellfun(fndvert{2}, ar, repmat({cortex.vert}, size(ar,1),1), 'uniformoutput', false )';
        VR_indiv = zeros(length(cortex.vert),1);
        VR_indiv(cell2mat(ar))=1;
        VR_comm = Wmat*VR_indiv;
        
        save([output_path,BS_subjects{k}], 'CortElecLocR', 'VR_indiv', 'VR_comm', 'ar', '-append');
    end
    
    fprintf(' done\n');
end



dat_files = dir('*.mat');

V_comm = zeros(length(Vertices),1);

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    SS= load(filename, 'VL_comm', 'VR_comm');
    
    if isfield(SS, 'VL_comm')
        V_comm = V_comm + SS.VL_comm;
    end
    if isfield(SS, 'VR_comm')
        V_comm = V_comm + SS.VR_comm;
    end
end

V_comm(find(V_comm~=0)) = 1;