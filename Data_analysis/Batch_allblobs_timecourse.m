iblob=0;
BlobData = {};
dat_files = dir('*.mat');

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s...\n', filename);
    S = load(filename);

    for contact=1:length(S.timecourse)
        for tblock=1:10
            if S.RecSide==1  % LEFT side

                % get Left Response blobs (IPSI)
                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobzmi', S.fq, S.t );
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        iblob=iblob+1;
                        BlobData{iblob,1} = S.id;
                        BlobData{iblob,2} = 1; %ipsi
                        BlobData{iblob,3} = tblock;
                        BlobData{iblob,4} = contact;
                        BlobData{iblob,5} = blobstats.blob(nblob).wcent_unit(1);
                        BlobData{iblob,6} = blobstats.blob(nblob).wcent_unit(2);
                        BlobData{iblob,7} = blobstats.blob(nblob).MeanValue;
                        BlobData{iblob,8} = blobstats.blob(nblob).TotalValue;
                        BlobData{iblob,9} = S.timecourse(contact).SPL_LR(tblock).sfc.PLFph(blobstats.blob(nblob).wcent_unit_idx(2),blobstats.blob(nblob).wcent_unit_idx(1));
                    end
                end
                
                % get Right Response blobs (CONTRA)
                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobzmi', S.fq, S.t );
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        iblob=iblob+1;
                        BlobData{iblob,1} = S.id;
                        BlobData{iblob,2} = 2; %contra
                        BlobData{iblob,3} = tblock;
                        BlobData{iblob,4} = contact;
                        BlobData{iblob,5} = blobstats.blob(nblob).wcent_unit(1);
                        BlobData{iblob,6} = blobstats.blob(nblob).wcent_unit(2);
                        BlobData{iblob,7} = blobstats.blob(nblob).MeanValue;
                        BlobData{iblob,8} = blobstats.blob(nblob).TotalValue;
                        BlobData{iblob,9} = S.timecourse(contact).SPL_RR(tblock).sfc.PLFph(blobstats.blob(nblob).wcent_unit_idx(2),blobstats.blob(nblob).wcent_unit_idx(1));
                    end
                end

            else  % RIGHT side
                
                % get Left Response blobs (CONTRA)
                blobstats = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobzmi', S.fq, S.t );
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        iblob=iblob+1;
                        BlobData{iblob,1} = S.id;
                        BlobData{iblob,2} = 2; %contra
                        BlobData{iblob,3} = tblock;
                        BlobData{iblob,4} = contact;
                        BlobData{iblob,5} = blobstats.blob(nblob).wcent_unit(1);
                        BlobData{iblob,6} = blobstats.blob(nblob).wcent_unit(2);
                        BlobData{iblob,7} = blobstats.blob(nblob).MeanValue;
                        BlobData{iblob,8} = blobstats.blob(nblob).TotalValue;
                        BlobData{iblob,9} = S.timecourse(contact).SPL_LR(tblock).sfc.PLFph(blobstats.blob(nblob).wcent_unit_idx(2),blobstats.blob(nblob).wcent_unit_idx(1));
                    end
                end

                % get Right Response blobs (IPSI)
                blobstats = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobzmi', S.fq, S.t );
                for nblob=1:length(blobstats.blob)
                    if ~isempty(blobstats.blob(nblob).wcent_unit)
                        iblob=iblob+1;
                        BlobData{iblob,1} = S.id;
                        BlobData{iblob,2} = 2; %ipsi
                        BlobData{iblob,3} = tblock;
                        BlobData{iblob,4} = contact;
                        BlobData{iblob,5} = blobstats.blob(nblob).wcent_unit(1);
                        BlobData{iblob,6} = blobstats.blob(nblob).wcent_unit(2);
                        BlobData{iblob,7} = blobstats.blob(nblob).MeanValue;
                        BlobData{iblob,8} = blobstats.blob(nblob).TotalValue;
                        BlobData{iblob,9} = S.timecourse(contact).SPL_RR(tblock).sfc.PLFph(blobstats.blob(nblob).wcent_unit_idx(2),blobstats.blob(nblob).wcent_unit_idx(1));
                    end
                end
            end
        end
    end
    fprintf(' done.\n');
end