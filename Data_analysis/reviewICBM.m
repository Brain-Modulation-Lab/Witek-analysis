subject_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/';
FS_subject_path = '/Users/Witek/Dropbox/electrode_imaging/Fluoro_Imaging/Subjects/';
ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
ICBM_CortLoc_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');


dat_files = dir('*.mat');

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    SS= load(filename);
    fprintf('%s...', filename);
    
    subject=load([subject_path,SS.id,'/tess_cortex_pial_high.mat'],'Reg','Atlas','Faces','Vertices');
    
%     SS = load([FS_subject_path,SS.id,'/cortex_indiv']);
%     cortex = SS.cortex;
    
    h = figure;
    
    ah_indiv = subplot(1,2,1); title(SS.id);
    patch('vertices',subject.Vertices,'faces',subject.Faces ,'edgecolor','none','FaceColor', [.65 .65 .65]);
    axis equal
    camlight('headlight','infinite');
    axis off;
    
    
    V=zeros(length(Vertices),1);
    if isfield(SS, 'al')
        axes(ah_indiv); hold on; plot3(subject.Vertices(cell2mat(SS.al),1),subject.Vertices(cell2mat(SS.al),2),subject.Vertices(cell2mat(SS.al),3),'r.','MarkerSize',25);
        V = V+SS.VL_comm;
    end
    if isfield(SS, 'ar')
        axes(ah_indiv); hold on; plot3(subject.Vertices(cell2mat(SS.ar),1),subject.Vertices(cell2mat(SS.ar),2),subject.Vertices(cell2mat(SS.ar),3),'r.','MarkerSize',25);
        V = V+SS.VR_comm;
    end
    
    ah_icbm = subplot(1,2,2);
    patch('vertices',Vertices,'faces',Faces,'FaceVertexCData',V,'edgecolor','none','FaceColor','interp');
    axis equal
    camlight('headlight','infinite');
    axis off;
    
    saveas(h, ['figures/',SS.id], 'pdf');
    
    fprintf(' done\n');
end
