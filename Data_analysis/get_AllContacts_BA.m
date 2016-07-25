subject_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/';
%FS_subject_path = '/Users/Witek/Dropbox/electrode_imaging/Fluoro_Imaging/Subjects/';
%ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
%output_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';

%load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

k=0;
dat_files = dir('*.mat');

AllContacts = {};
icontact = 0;

thisAtlas = 4; %Brodmann

for s=1:length(dat_files)
    filename=dat_files(s).name;
    fprintf('%s...\n', filename);
    S = load(filename);
    
    if isfield(S, 'al')
        for contact=1:length(S.al)
            icontact = icontact+1;
            AllContacts{icontact,1} = S.id;
            AllContacts{icontact,2} = 1;
            AllContacts{icontact,3} = contact;
            AllContacts{icontact,4} = S.Anatomy.Atlas(thisAtlas).CortElecLocL{contact};
        end
    end
    if isfield(S, 'ar')
        for contact=1:length(S.ar)
            icontact = icontact+1;
            AllContacts{icontact,1} = S.id;
            AllContacts{icontact,2} = 2;
            AllContacts{icontact,3} = contact;
            AllContacts{icontact,4} = S.Anatomy.Atlas(thisAtlas).CortElecLocR{contact};
        end
    end
end
    

