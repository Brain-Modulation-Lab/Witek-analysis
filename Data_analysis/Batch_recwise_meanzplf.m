for fb=1:3
    
    idx = find(idx_1Dcat==fb);
    
    L{fb} = sum(cat(3,BlobData{idx,11}),3);
    L{fb}=L{fb}./sum(sum(L{fb}));
    %L{fb}(L{fb}~=0)=1;
end

for fb=1:3
    for tblock=1:4
        for r=1:4
            for s=1:2
                zplf{fb,tblock,r,s} = [];
                blobplf{fb,tblock,r,s} = [];
            end
        end
    end
end

regions_index = cellfun(@(x) regions(x), bilateral4_regions_index, 'uniformoutput', 0);

atlas = 3; % K-D

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s... ', filename);
    S = load(filename);
    
    for fb=1:3
        for tblock=1:4
            for r=1:4
                for s=1:2
                    this_zplf_mean{fb,tblock,r,s} = [];
                    this_zplf{fb,tblock,r,s} = [];
                    this_blobplf{fb,tblock,r,s} = [];
                end
            end
        end
    end
    
    for contact=1:length(S.timecourse)
        
        atlas_index = [];
        if ~strcmp(S.id, 'RS3')
            anatomy_filename = anatomy_files(find(cellfun(@(s) ~isempty(strfind(s, S.id(1:2))), {anatomy_files(:).name}))).name;
            A = load([anatomy_path,anatomy_filename],'Anatomy');
            if S.RecSide==1
                atlas_index = A.Anatomy.Atlas(atlas).CortElecLocL{contact};
            else
                atlas_index = A.Anatomy.Atlas(atlas).CortElecLocR{contact};
            end
            reg_idx = find(cellfun(@(x) ~isempty(find(x==atlas_index)), regions_index));

            if ~isempty(reg_idx)
                for fb=1:3
                    switch fb
                        case 1
                            fq_range = [4 12];
                        case 2
                            fq_range = [12 25];
                        case 3
                            fq_range = [25 40];
                    end
                    for tblock=1:4
                        
                        blobstats_LR = blob_stats( S.timecourse(contact).SPL_LR(tblock), 'blobplf', fq, (1:501)/500-.5 );
                        blobstats_RR = blob_stats( S.timecourse(contact).SPL_RR(tblock), 'blobplf', fq, (1:501)/500-.5 );
                        
                        thisL_LR = zeros(501,37);
                        for iblob=1:length(blobstats_LR.blob)
                            if ~isempty(iblob) && blobstats_LR.blob(iblob).MeanValue ~= 0 && ...
                                    blobstats_LR.blob(iblob).wcent_unit(1) >= fq_range(1) && ...
                                    blobstats_LR.blob(iblob).wcent_unit(1) < fq_range(2)
                                thisL_LR = thisL_LR + blobstats_LR.blob(iblob).L;
                                thisL_LR(thisL_LR~=0) = 1;
                            end
                        end
                        
                        thisL_RR = zeros(501,37);
                        for iblob=1:length(blobstats_RR.blob)
                            if ~isempty(iblob) && blobstats_RR.blob(iblob).MeanValue ~= 0 && ...
                                    blobstats_RR.blob(iblob).wcent_unit(1) > fq_range(1) && ...
                                    blobstats_RR.blob(iblob).wcent_unit(1) < fq_range(2)
                                thisL_RR = thisL_RR + blobstats_RR.blob(iblob).L;
                                thisL_RR(thisL_RR~=0) = 1;
                            end
                        end
                        
                        if dat_files(i).RecSide==1
                            
                            this_zplf{fb,tblock,reg_idx,1} = cat(3, this_zplf{fb,tblock,reg_idx,1}, ...
                                L{fb}.*S.timecourse(contact).SPL_LR(tblock).zplf);
                            this_blobplf{fb,tblock,reg_idx,1} = cat(3, this_blobplf{fb,tblock,reg_idx,1}, ...
                                thisL_LR.*S.timecourse(contact).SPL_LR(tblock).blobplf);
                            
                            this_zplf{fb,tblock,reg_idx,2} = cat(3, this_zplf{fb,tblock,reg_idx,2}, ...
                                L{fb}.*S.timecourse(contact).SPL_RR(tblock).zplf);
                            this_blobplf{fb,tblock,reg_idx,2} = cat(3, this_blobplf{fb,tblock,reg_idx,2}, ...
                                thisL_RR.*S.timecourse(contact).SPL_RR(tblock).blobplf);
                            
                        else
                            
                            this_zplf{fb,tblock,reg_idx,1} = cat(3, this_zplf{fb,tblock,reg_idx,1}, ...
                                L{fb}.*S.timecourse(contact).SPL_RR(tblock).zplf);
                            this_blobplf{fb,tblock,reg_idx,1} = cat(3, this_blobplf{fb,tblock,reg_idx,1}, ...
                                thisL_RR.*S.timecourse(contact).SPL_RR(tblock).blobplf);

                            
                            this_zplf{fb,tblock,reg_idx,2} = cat(3, this_zplf{fb,tblock,reg_idx,2}, ...
                                L{fb}.*S.timecourse(contact).SPL_LR(tblock).zplf);
                            this_blobplf{fb,tblock,reg_idx,2} = cat(3, this_blobplf{fb,tblock,reg_idx,2}, ...
                                thisL_LR.*S.timecourse(contact).SPL_LR(tblock).blobplf);
                            
                        end
                    end
                end
            end
        end
    end
    
    if max(max(max(this_blobplf{2,3,3,2}))) > 0
        disp(S.id)
    end
    
    if ~strcmp(S.id, 'RS3')
        for fb=1:3
            for tblock=1:4
                for r=1:4
                    for s=1:2
                        zplf{fb,tblock,r,s} = cat(1, zplf{fb,tblock,r,s}, mean(mean(mean(this_zplf{fb,tblock,r,s},1),2),3));
                        blobplf{fb,tblock,r,s} = cat(1, blobplf{fb,tblock,r,s}, mean(mean(mean(this_blobplf{fb,tblock,r,s},1),2),3));
                    end
                end
            end
        end
        
        
%         h=figure;
%         prespike = 500;
%         postspike = 500;
%         fs = 500;
%         fb=2; reg_idx=3;
%         k=1; j=1;
%         h_title = subplot('Position',[0 7/8 (1-0.01) (1/8-0.01)]);
%         xlim([-1 1])
%         ylim([-1 1])
%         text(0, 0, filename(1:4))
%         for t=1:4
%             hh(k)=subplot('Position',[(t-1)/4 21/32 (1/4-0.01) (7/32-0.01)]); k=k+1;
%             M = mean(this_zplf{fb,t,reg_idx,1},3)';
%             imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
%             
%             x1limits = get(hh(k-1), 'xlim');
%             set(hh(k-1), 'xtick', x1limits(1)-1);
%             y1limits = get(hh(k-1), 'ylim');
%             set(hh(k-1), 'ytick', y1limits(1)-1);
%             
%             hh(k)=subplot('Position',[(t-1)/4 14/32 (1/4-0.01) (7/32-0.01)]); k=k+1;
%             M = mean(this_zplf{fb,t,reg_idx,2},3)';
%             imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w')
%             
%             x1limits = get(hh(k-1), 'xlim');
%             set(hh(k-1), 'xtick', x1limits(1)-1);
%             y1limits = get(hh(k-1), 'ylim');
%             set(hh(k-1), 'ytick', y1limits(1)-1);
%             
%             hh(k)=subplot('Position',[(t-1)/4 7/32 (1/4-0.01) (7/32-0.01)]); k=k+1;
%             M = mean(this_blobplf{fb,t,reg_idx,1},3)';
%             imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w');
%             
%             x1limits = get(hh(k-1), 'xlim');
%             set(hh(k-1), 'xtick', x1limits(1)-1);
%             y1limits = get(hh(k-1), 'ylim');
%             set(hh(k-1), 'ytick', y1limits(1)-1);
%             
%             hh(k)=subplot('Position',[(t-1)/4 0 (1/4-0.01) (7/32-0.01)]); k=k+1;
%             M = mean(this_blobplf{fb,t,reg_idx,2},3)';
%             imagesc((1:(prespike+postspike+1))/fs-(prespike+postspike)/(2*fs), fq, M); set(gca,'YDir','normal'); set(gca,'FontSize',5); hold on; plot([0 0], ylim, ':', 'Color', 'w')
%             
%             x1limits = get(hh(k-1), 'xlim');
%             set(hh(k-1), 'xtick', x1limits(1)-1);
%             y1limits = get(hh(k-1), 'ylim');
%             set(hh(k-1), 'ytick', y1limits(1)-1);
%         end
%         CommonCaxis = caxis((hh(1)));
%         for t=1:16
%             thisCaxis = caxis((hh(t)));
%             CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
%             CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
%         end
%         for t=1:16
%             caxis(hh(t), CommonCaxis);
%         end
    end
    fprintf(' done.\n');
end

% fb=1; region=3;
% for tblock=1:4
%     DATA{:,tblock,1} = zplf{fb,tblock,region,1};
%     time_group{:,tblock,1} = tblock*ones(size(DATA{:,tblock,1}));
%     side_group{:,tblock,1} = 1*ones(size(DATA{:,tblock,1}));
%     DATA{:,tblock,2} = zplf{fb,tblock,region,2};
%     time_group{:,tblock,2} = tblock*ones(size(DATA{:,tblock,2}));
%     side_group{:,tblock,2} = 2*ones(size(DATA{:,tblock,2}));
% end

% for fb=1:3
%     for t=1:4
%         for s=1:2
%             for region=1:4
%                 DATA{fb,t,s,region} = blobplf{fb,t,region,s};
%                 DATA_Gfb{fb,t,s,region} = fb*ones(size(DATA{fb,t,s,region}));
%                 DATA_Gtime{fb,t,s,region} = t*ones(size(DATA{fb,t,s,region}));
%                 DATA_Gside{fb,t,s,region} = s*ones(size(DATA{fb,t,s,region}));
%                 DATA_Greg{fb,t,s,region} = region*ones(size(DATA{fb,t,s,region}));
%             end
%         end
%     end
% end
% 
% anovan(cat(1,DATA{:}), {cat(1,DATA_Gfb{:}), cat(1,DATA_Gtime{:}), cat(1,DATA_Gside{:}), cat(1,DATA_Greg{:})})
% 
% DATAstats = [cat(1,DATA{:}), repmat((1:27)',96,1), cat(1,DATA_Gfb{:}), cat(1,DATA_Gtime{:}), cat(1,DATA_Gside{:}), cat(1,DATA_Greg{:})];
% 
% boxplot(cat(1,DATA{:}), {cat(1,DATA_Gfb{:}), cat(1,DATA_Gtime{:}), cat(DATA_Gside{:}), cat(DATA_Greg{:})})
% 
% 


% [p,tbl,stats] = anovan(DATAstats(:,1), {DATAstats(:,3), DATAstats(:,4), DATAstats(:,5), DATAstats(:,6)}, 'model', 'interaction', 'display', 'off');


clear DATA;
clear DATA_Gfb;
clear DATA_Gtime;
clear DATA_Gside;
clear DATA_Greg;
clear DATAstats;

fb=3; region=3;
for t=1:4
    for s=1:2
        DATA{t,s} = blobplf{fb,t,region,s};
        DATA_Gtime{t,s} = t*ones(size(DATA{t,s}));
        DATA_Gside{t,s} = s*ones(size(DATA{t,s}));
    end
end

nsubjects = 27;
ncond = 4*2;

DATAstats = [cat(1,DATA{:}), repmat((1:nsubjects)',ncond,1), cat(1,DATA_Gtime{:}), cat(1,DATA_Gside{:})];

[~,I] = sort(DATAstats(:,2));
DATAstats = DATAstats(I,:);

[p,tbl,stats] = anovan(DATAstats(:,1), {DATAstats(:,3), DATAstats(:,4)}, 'model', 'interaction', 'display', 'off');

figure; boxplot(cat(1,DATA{:}), {cat(1,DATA_Gtime{:}), cat(1,DATA_Gside{:})})

multcompare(stats,'Dimension',[1 2])