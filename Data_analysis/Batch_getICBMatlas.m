subject_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/';
%FS_subject_path = '/Users/Witek/Dropbox/electrode_imaging/Fluoro_Imaging/Subjects/';
ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
%output_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

k=0;
dat_files = dir('*.mat');

%for s=1:length(dat_files)
for s=1:length(subjects)
    %filename=dat_files(s).name;
    filename=subjects{s};
    fprintf('%s...\n', filename);
    S = load(filename);
    
    subject=load([subject_path,S.id,'/tess_cortex_pial_high.mat'],'Reg','Atlas','Faces','Vertices');
    Anatomy = [];
    
    Anatomy.Atlas = subject.Atlas;
    for atlas=1:length(subject.Atlas)
        Anatomy.Atlas(atlas).V = zeros(length(subject.Vertices),3);
        for region=1:length(subject.Atlas(atlas).Scouts)
            Anatomy.Atlas(atlas).V(subject.Atlas(atlas).Scouts(region).Vertices,:) = ...
                repmat(subject.Atlas(atlas).Scouts(region).Color,length(subject.Atlas(atlas).Scouts(region).Vertices),1);
        end
    end
    
    if isfield(S, 'al')
        for contact=1:length(S.al)
            for atlas=1:length(subject.Atlas)
                Anatomy.Atlas(atlas).CortElecLocL{contact} = ...
                    find(arrayfun(@(x) ~isempty(intersect(S.al{contact},x.Vertices)), subject.Atlas(atlas).Scouts));
            end
        end
    end
    if isfield(S, 'ar')
        for contact=1:length(S.ar)
            for atlas=1:length(subject.Atlas)
                Anatomy.Atlas(atlas).CortElecLocR{contact} = ...
                    find(arrayfun(@(x) ~isempty(intersect(S.ar{contact},x.Vertices)), subject.Atlas(atlas).Scouts));
            end
        end
    end
    
    save(filename, 'Anatomy', '-append');
    
    fprintf(' done\n');
end
