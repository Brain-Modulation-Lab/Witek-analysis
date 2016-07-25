ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

valuefield = 'MeanValue';
fq_range = [4 40];

dat_files=dir('*.mat');
fq=4:40;
t=(1:501)/500-.5;

for tblock=1:10
    group_timecourse(tblock).ipsi = zeros(501,37);
    group_timecourse(tblock).contra = zeros(501,37);
    group_timecourse(tblock).ipsi_Vcomm = zeros(size(Vertices,1),1);
    %group_timecourse(tblock).ipsi_ElecValue = {};
    group_timecourse(tblock).contra_Vcomm = zeros(size(Vertices,1),1);
    %group_timecourse(tblock).contra_ElecValue = {};
end

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s...\n', filename);
    S = load(filename);
    sidx = find(cellfun(@(s) ~isempty(strfind(s, S.id(1:2))), subjects.id));
    if strcmp(S.id,'RS3')
        sidx = [];
    end
    for contact=1:length(S.timecourse)
        for tblock=1:10
            if S.RecSide==1
                
                Count = S.timecourse(contact).SPL_LR(tblock).blobzmi; Count(Count~=0)=1;
                group_timecourse(tblock).ipsi = group_timecourse(tblock).ipsi + Count;
                
                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobzmi', fq, t );

                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(2) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1); 
                        Vind(subjects.ICBM.CortElecLocL{sidx}{contact})=blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).ipsi_Vcomm = group_timecourse(tblock).ipsi_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
                
                Count = S.timecourse(contact).SPL_RR(tblock).blobzmi; Count(Count~=0)=1;
                group_timecourse(tblock).contra = group_timecourse(tblock).contra + Count;

                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobzmi', fq, t );

                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(2) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1);
                        Vind(subjects.ICBM.CortElecLocL{sidx}{contact})=blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).contra_Vcomm = group_timecourse(tblock).contra_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
            else
                
                Count = S.timecourse(contact).SPL_RR(tblock).blobzmi; Count(Count~=0)=1;
                group_timecourse(tblock).ipsi = group_timecourse(tblock).ipsi + Count;
                
                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobzmi', fq, t );
                
                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(2) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1);
                        Vind(subjects.ICBM.CortElecLocR{sidx}{contact})=blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).ipsi_Vcomm = group_timecourse(tblock).ipsi_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
                
                Count = S.timecourse(contact).SPL_LR(tblock).blobzmi; Count(Count~=0)=1;
                group_timecourse(tblock).contra = group_timecourse(tblock).contra + Count;

                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobzmi', fq, t );
                
                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx) && ...
                            blobstats.blob(iblob).wcent_unit(1) > fq_range(1) && blobstats.blob(iblob).wcent_unit(2) < fq_range(2)
                        Vind = zeros(size(subjects.ICBM.Wmat{sidx},2),1);
                        Vind(subjects.ICBM.CortElecLocR{sidx}{contact}) = blobstats.blob(iblob).(valuefield);
                        group_timecourse(tblock).contra_Vcomm = group_timecourse(tblock).contra_Vcomm + subjects.ICBM.Wmat{sidx}*Vind;
                        
                        fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).(valuefield));
                    end
                end
            end
        end
    end
    fprintf(' done.\n');
end