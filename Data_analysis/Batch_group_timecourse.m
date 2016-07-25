for tblock=1:10
    group_timecourse(tblock).ipsi = zeros(501,37);
    group_timecourse(tblock).contra = zeros(501,37);
    group_timecourse(tblock).ipsi_ElecLoc = {};
    group_timecourse(tblock).ipsi_ElecValue = {};
    group_timecourse(tblock).contra_ElecLoc = {};
    group_timecourse(tblock).contra_ElecValue = {};
end

dat_files = dir('*.mat');

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s...\n', filename);
    S = load(filename);
    sidx = find(strcmp(subjects.id,dat_files(i).subject_id));
    for contact=1:length(S.timecourse)
        for tblock=1:10
            if dat_files(i).side==1
                group_timecourse(tblock).ipsi = group_timecourse(tblock).ipsi + S.timecourse(contact).SPL_LR(tblock).blobzmi;
                
                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobzmi', fq, t );
                
                this_f = [];
                this_val = [];
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        this_f(end+1) = blobstats.blob(nblob).wcent_unit(1);
                    else
                        this_f(end+1) = 0;
                    end
                    this_val(end+1) = blobstats.blob(nblob).TotalValue;
                end
                [~, imaxval] = max(this_val);
                ihif = find(this_f>20);
                iblob = intersect(imaxval, ihif);
                
                if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx)
                    group_timecourse(tblock).ipsi_ElecLoc{end+1} = subjects.MNI.CortElecLocL{sidx}{contact};
                    group_timecourse(tblock).ipsi_ElecValue{end+1} = blobstats.blob(iblob).TotalValue;
                    fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                end
                
                group_timecourse(tblock).contra = group_timecourse(tblock).contra + S.timecourse(contact).SPL_RR(tblock).blobzmi;

                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobzmi', fq, t );
                
                this_f = [];
                this_val = [];
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        this_f(end+1) = blobstats.blob(nblob).wcent_unit(1);
                    else
                        this_f(end+1) = 0;
                    end
                    this_val(end+1) = blobstats.blob(nblob).TotalValue;
                end
                [~, imaxval] = max(this_val);
                ihif = find(this_f>20);
                iblob = intersect(imaxval, ihif);
                
                if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx)
                    group_timecourse(tblock).contra_ElecLoc{end+1} = subjects.MNI.CortElecLocL{sidx}{contact};
                    group_timecourse(tblock).contra_ElecValue{end+1} = blobstats.blob(iblob).TotalValue;
                    fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                end
            else
                group_timecourse(tblock).ipsi = group_timecourse(tblock).ipsi + S.timecourse(contact).SPL_RR(tblock).blobzmi;
                
                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobzmi', fq, t );
                
                this_f = [];
                this_val = [];
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        this_f(end+1) = blobstats.blob(nblob).wcent_unit(1);
                    else
                        this_f(end+1) = 0;
                    end
                    this_val(end+1) = blobstats.blob(nblob).TotalValue;
                end
                [~, imaxval] = max(this_val);
                ihif = find(this_f>20);
                iblob = intersect(imaxval, ihif);
                
                if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx)
                    group_timecourse(tblock).ipsi_ElecLoc{end+1} = subjects.MNI.CortElecLocR{sidx}{contact};
                    group_timecourse(tblock).ipsi_ElecValue{end+1} = blobstats.blob(iblob).TotalValue;
                    fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                end
                
                group_timecourse(tblock).contra = group_timecourse(tblock).contra + S.timecourse(contact).SPL_LR(tblock).blobzmi;

                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobzmi', fq, t );
                
                this_f = [];
                this_val = [];
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        this_f(end+1) = blobstats.blob(nblob).wcent_unit(1);
                    else
                        this_f(end+1) = 0;
                    end
                    this_val(end+1) = blobstats.blob(nblob).TotalValue;
                end
                [~, imaxval] = max(this_val);
                ihif = find(this_f>20);
                iblob = intersect(imaxval, ihif);
                
                if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0 && ~isempty(sidx)
                    group_timecourse(tblock).contra_ElecLoc{end+1} = subjects.MNI.CortElecLocR{sidx}{contact};
                    group_timecourse(tblock).contra_ElecValue{end+1} = blobstats.blob(iblob).TotalValue;
                    fprintf('Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                end
            end
        end
    end
    fprintf(' done.\n');
end