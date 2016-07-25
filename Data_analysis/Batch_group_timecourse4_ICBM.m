ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

subject_path = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';

AnatomyFiles = dir([subject_path,'*.mat']);

%% add RecSide
qt_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/';
timecourse_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL4/';
dat_files = dir([qt_path,'*.mat']);
for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s...', filename);
    S = load([qt_path,filename], 'RecID', 'RecSide');
    if exist([timecourse_path,S.RecID,'_timecourse2_plf.mat'])==2
        RecID = S.RecID;
        RecSide = S.RecSide;
        save([timecourse_path,S.RecID,'_timecourse2_plf.mat'],'RecID', 'RecSide', '-append');
        fprintf(' done.\n');
    else
        fprintf(' timecourse not found.\n');
    end
end
%%

valuefield = 'MeanValue';
fq_range = [12 40];

nframes = 5;

for tblock=1:nframes
    group_timecourse(tblock).ipsi = []; %zeros(501,37);
    group_timecourse(tblock).contra = []; %zeros(501,37);
    group_timecourse(tblock).ipsiCount = 0;
    group_timecourse(tblock).contraCount = 0;
    group_timecourse(tblock).ipsi_Vcomm = zeros(size(Vertices,1),1);
    %group_timecourse(tblock).ipsi_ElecValue = {};
    group_timecourse(tblock).contra_Vcomm = zeros(size(Vertices,1),1);
    %group_timecourse(tblock).contra_ElecValue = {};
end

%dat_files = dir('*.mat');

fq=4:40;
t=(1:501)/500-.5;

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s...\n', filename);
    S = load(filename);
    sidx = find(cellfun(@(s) ~isempty(strfind(s, dat_files(i).name(1:2))), ...
        cellfun(@(x) x(1:2),{AnatomyFiles(:).name}, 'uniformoutput', false)));
    
%     if strcmp(dat_files(i).name(1:3),'RS3')
%         sidx = [];
%     end

    for contact=1:length(S.timecourse)
        for tblock=1:nframes
            if dat_files(i).RecSide==1
                
                TotalSPL = S.timecourse(contact).SPL_LR(tblock).zplf; %TotalSPL(TotalSPL~=0)=1;
                group_timecourse(tblock).ipsi = group_timecourse(tblock).ipsi + TotalSPL;
                group_timecourse(tblock).ipsiCount = group_timecourse(tblock).ipsiCount + 1;
                
                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'zplf', fq, t );

                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(1) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1); 
                        Vind(subjects.ICBM.CortElecLocL{sidx}{contact})=blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).ipsi_Vcomm = group_timecourse(tblock).ipsi_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Ipsi: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
                
                TotalSPL = S.timecourse(contact).SPL_RR(tblock).zplf; %TotalSPL(TotalSPL~=0)=1;
                group_timecourse(tblock).contra = group_timecourse(tblock).contra + TotalSPL;
                group_timecourse(tblock).contraCount = group_timecourse(tblock).contraCount + 1;

                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'zplf', fq, t );

                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(1) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1);
                        Vind(subjects.ICBM.CortElecLocL{sidx}{contact})=blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).contra_Vcomm = group_timecourse(tblock).contra_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Contra: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
            else
                
                TotalSPL = S.timecourse(contact).SPL_RR(tblock).zplf; %TotalSPL(TotalSPL~=0)=1;
                group_timecourse(tblock).ipsi = group_timecourse(tblock).ipsi + TotalSPL;
                group_timecourse(tblock).ipsiCount = group_timecourse(tblock).ipsiCount + 1;
                
                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'zplf', fq, t );
                
                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(1) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1);
                        Vind(subjects.ICBM.CortElecLocR{sidx}{contact})=blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).ipsi_Vcomm = group_timecourse(tblock).ipsi_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Ipsi: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
                
                TotalSPL = S.timecourse(contact).SPL_LR(tblock).zplf; %TotalSPL(TotalSPL~=0)=1;
                group_timecourse(tblock).contra = group_timecourse(tblock).contra + TotalSPL;
                group_timecourse(tblock).contraCount = group_timecourse(tblock).contraCount + 1;

                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'zplf', fq, t );
                
                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(1) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1);
                        Vind(subjects.ICBM.CortElecLocR{sidx}{contact}) = blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).contra_Vcomm = group_timecourse(tblock).contra_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Contra: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
            end
        end
    end
    fprintf(' done.\n');
end