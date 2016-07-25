 AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
 TimecoursePath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL5/';

 cd(AnatomyPath);

dat_files = dir('*.mat');

regions = {};

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s... \n', filename);
    S = load(filename);
    
    if isfield(S.Anatomy.Atlas(3), 'CortElecLocL')
        regions = cat(1, regions, cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)');
    end
    if isfield(S.Anatomy.Atlas(3), 'CortElecLocR')
        regions = cat(1, regions, cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)');
    end
    
end

regions = unique(regions);

regions_cats = {'frontal', 'precentral', 'postcentral', 'parietal'};

region_groups = {{'caudalmiddlefrontal L';'caudalmiddlefrontal R';'superiorfrontal L';'superiorfrontal R'}, ...
                {'precentral L';'precentral R'}, ...
                {'postcentral L','postcentral R'}, ...
                {'inferiorparietal L';'inferiorparietal R';'superiorparietal L';'superiorparietal R';'supramarginal L';'supramarginal R'}};

nframes = 5;
            
for tblock=1:nframes
    for r = 1:length(regions_cats)
%         SPLregion(r).group_timecourse(tblock).ipsi = zeros(501,37);
        SPLregion(r).group_timecourse(tblock).ipsi = [];
%         SPLregion(r).group_timecourse(tblock).contra = zeros(501,37);
        SPLregion(r).group_timecourse(tblock).contra = [];
        SPLregion(r).group_timecourse(tblock).ipsiCount = 0;
        SPLregion(r).group_timecourse(tblock).contraCount = 0;
        
        SPLregion(r).group_timecourse(tblock).lowBipsi_blob = {};
        SPLregion(r).group_timecourse(tblock).lowBcontra_blob = {};
        SPLregion(r).group_timecourse(tblock).hiBipsi_blob = {};
        SPLregion(r).group_timecourse(tblock).hiBcontra_blob = {};
    end
end
 
field = 'blobplf';
prespike = 250;
postspike = 250;
fs = 500;
t = (1:(prespike+postspike+1))/fs-(prespike+postspike+2)/(2*fs);
fq = 4:40;

lowB = [12 25];
hiB = [25 40];
trange = [-.25 .25];

% find which set of region_groups the string y belongs to
which_regcat = @(y) find(cell2mat(cellfun(@(x) sum(strcmp(y, x))>0, region_groups, 'uniformoutput', false)));

cd(AnatomyPath);

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s... \n', filename);
    S = load(filename);
    
    if isfield(S, 'unitsL')
        
        % Recordings on the LEFT side of the brain
        for unit=1:length(S.unitsL)
            
            SU = load([TimecoursePath, S.unitsL{unit},'_timecourse2_plf.mat']);
            fprintf('Recording (left) %s...\n',SU.RecID);
            
            %find what anatomical category each contact belongs to
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.timecourse)
                for tblock = 1:nframes
                    
                    if sum(isnan(SU.timecourse(contact).SPL_LR(tblock).(field)))>0 | ...
                            sum(isnan(SU.timecourse(contact).SPL_RR(tblock).(field)))>0
                        fprintf('WARNING: NaN datapoints found!\n');
                        fprintf('         contact %d, tblock %d\n', contact, tblock);
                    end
                    
                    % plf
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi, ...
                        SU.timecourse(contact).SPL_LR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount + 1;
                    % blobzplf
                    blobstats = blob_stats( SU.timecourse(contact).SPL_LR(tblock), 'blobplf', fq, t );
                    for iblob=1:length(blobstats.blob)
                        if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                            if blobstats.blob(iblob).wcent_unit(1) >= lowB(1) && blobstats.blob(iblob).wcent_unit(1) < lowB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob, ...
                                    blobstats.blob(iblob));
                            elseif blobstats.blob(iblob).wcent_unit(1) >= hiB(1) && blobstats.blob(iblob).wcent_unit(1) <= hiB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob, ...
                                    blobstats.blob(iblob));
                            end
                            fprintf('Ipsi blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                        end
                    end
                    
                    % plf
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contra, ...
                        SU.timecourse(contact).SPL_RR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount + 1;
                    % blobzplf
                    blobstats = blob_stats( SU.timecourse(contact).SPL_RR(tblock), 'blobplf', fq, t );
                    for iblob=1:length(blobstats.blob)
                        if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                            if blobstats.blob(iblob).wcent_unit(1) >= lowB(1) && blobstats.blob(iblob).wcent_unit(1) < lowB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob, ...
                                    blobstats.blob(iblob));
                            elseif blobstats.blob(iblob).wcent_unit(1) >= hiB(1) && blobstats.blob(iblob).wcent_unit(1) <= hiB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob, ...
                                    blobstats.blob(iblob));
                            end
                            fprintf('Contra blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                        end
                    end
                end
            end
        end
    end
    
    if isfield(S, 'unitsR')
        
        % Recordings on the RIGHT side of the brain
        for unit=1:length(S.unitsR)
            SU = load([TimecoursePath, S.unitsR{unit},'_timecourse2_plf.mat']);
            fprintf('Recording (right) %s...\n',SU.RecID);
            
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.timecourse)
                for tblock = 1:nframes
                    
                    if sum(isnan(SU.timecourse(contact).SPL_LR(tblock).(field)))>0 | ...
                            sum(isnan(SU.timecourse(contact).SPL_RR(tblock).(field)))>0
                        fprintf('WARNING: NaN datapoints found!\n');
                        fprintf('         contact %d, tblock %d\n', contact, tblock);
                    end
                    
                    % plf
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi, ...
                        SU.timecourse(contact).SPL_RR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount + 1;
                    % blobzplf
                    blobstats = blob_stats( SU.timecourse(contact).SPL_RR(tblock), 'blobplf', fq, t );
                    for iblob=1:length(blobstats.blob)
                        if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                            if blobstats.blob(iblob).wcent_unit(1) >= lowB(1) && blobstats.blob(iblob).wcent_unit(1) < lowB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob, ...
                                    blobstats.blob(iblob));
                            elseif blobstats.blob(iblob).wcent_unit(1) >= hiB(1) && blobstats.blob(iblob).wcent_unit(1) <= hiB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob, ...
                                    blobstats.blob(iblob));
                            end
                            fprintf('Ipsi blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                        end
                    end
                    
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contra, ...
                        SU.timecourse(contact).SPL_LR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount + 1;
                     % blobzplf
                    blobstats = blob_stats( SU.timecourse(contact).SPL_LR(tblock), 'blobplf', fq, t );
                    for iblob=1:length(blobstats.blob)
                        if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                            if blobstats.blob(iblob).wcent_unit(1) >= lowB(1) && blobstats.blob(iblob).wcent_unit(1) < lowB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob, ...
                                    blobstats.blob(iblob));
                            elseif blobstats.blob(iblob).wcent_unit(1) >= hiB(1) && blobstats.blob(iblob).wcent_unit(1) <= hiB(2)
                                SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob = cat(2, ...
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob, ...
                                    blobstats.blob(iblob));
                            end
                            fprintf('Contra blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).wcent_unit(1), blobstats.blob(iblob).wcent_unit(2), blobstats.blob(iblob).TotalValue);
                        end
                    end
                end
            end
        end
    end
    
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% T = 1;
% t_subset = 1:5;
% 
% STATS = [];
% STATS_loB_lag = [];
% STATS_hiB_lag = [];
% TimeGroup = [];
% SideGroup = [];
% TimeGroup_loB_lag = [];
% SideGroup_loB_lag = [];
% TimeGroup_hiB_lag = [];
% SideGroup_hiB_lag = [];
% 
% nbins = 25;
% fq = 4:40;
% t = ((1:nframes))/T - 2.5;
% t = t(t_subset);
% tval = -0.5:.002:0.5;
% r=4;
% fqrange = [25 40];
% trange = [-.251 .25];
% clear SPLVal_ipsi SPLVal_contra
% for tblock = 1:length(t_subset)
%     ipsi = mean(SPLregion(r).group_timecourse(t_subset(tblock)).ipsi( ...
%         findval(trange(1),trange(2),tval), ...
%         findval(fqrange(1),fqrange(2),fq),:),3);
%     
%     [~, idx] = max(mean(ipsi,2));
%     temp = linspace(trange(1), trange(2), size(ipsi,1));
%     LAGVal_ipsi(tblock) = temp(idx);
%     
%     binsize = floor(size(ipsi,1)/nbins);
%     ipsi = bin(mean(ipsi,2),nbins)/binsize;
%     
%     contra = mean(SPLregion(r).group_timecourse(t_subset(tblock)).contra( ...
%         findval(trange(1),trange(2),tval), ...
%         findval(fqrange(1),fqrange(2),fq),:),3);
%     
%     [~, idx] = max(mean(contra,2));
%     temp = linspace(trange(1), trange(2), size(contra,1));
%     LAGVal_contra(tblock) = temp(idx);
%     
%     binsize = floor(size(contra,1)/nbins);
%     contra = bin(mean(contra,2),nbins)/binsize;
%     
%     SPLVal_ipsi(tblock).mean = mean(ipsi(:));
%     SPLVal_ipsi(tblock).sterr = std(ipsi(:))/sqrt(numel(ipsi(:))-1);
%     SPLVal_ipsi(tblock).std = std(ipsi(:));
%     SPLVal_contra(tblock).mean = mean(contra(:));
%     SPLVal_contra(tblock).sterr = std(contra(:))/sqrt(numel(contra(:))-1);
%     SPLVal_contra(tblock).std = std(contra(:));
%     
%     STATS = cat(1, STATS, ipsi(:));
%     TimeGroup = cat(1, TimeGroup, t(tblock)*ones(size(ipsi(:))));
%     SideGroup = cat(1, SideGroup, 1*ones(size(ipsi(:))));
%     STATS = cat(1, STATS, contra(:));
%     TimeGroup = cat(1, TimeGroup, t(tblock)*ones(size(contra(:))));
%     SideGroup = cat(1, SideGroup, 2*ones(size(contra(:))));
%     
%     if ~isempty(SPLregion(r).group_timecourse(tblock).lowBipsi_blob)
%         ipsi_loB_lag = cellfun(@(x) x.wcent_unit(2), SPLregion(r).group_timecourse(tblock).lowBipsi_blob)';
%     else
%         ipsi_loB_lag = NaN;
%     end
%     if ~isempty(SPLregion(r).group_timecourse(tblock).lowBcontra_blob)
%         contra_loB_lag = cellfun(@(x) x.wcent_unit(2), SPLregion(r).group_timecourse(tblock).lowBcontra_blob)';
%     else
%         contra_loB_lag = NaN;
%     end
%     if ~isempty(SPLregion(r).group_timecourse(tblock).hiBipsi_blob)
%         ipsi_hiB_lag = cellfun(@(x) x.wcent_unit(2), SPLregion(r).group_timecourse(tblock).hiBipsi_blob)';
%     else
%         ipsi_hiB_lag = NaN;
%     end
%     if ~isempty(SPLregion(r).group_timecourse(tblock).hiBcontra_blob)
%         contra_hiB_lag = cellfun(@(x) x.wcent_unit(2), SPLregion(r).group_timecourse(tblock).hiBcontra_blob)';
%     else
%         contra_hiB_lag = NaN;
%     end
%     
%     LAGVal_loB_ipsi(tblock).mean = mean(ipsi_loB_lag);
%     LAGVal_loB_ipsi(tblock).sterr = std(ipsi_loB_lag)/sqrt(numel(ipsi_loB_lag)-1);
%     LAGVal_loB_ipsi(tblock).std = std(ipsi_loB_lag);
%     LAGVal_loB_contra(tblock).mean = mean(contra_loB_lag);
%     LAGVal_loB_contra(tblock).sterr = std(contra_loB_lag)/sqrt(numel(contra_loB_lag)-1);
%     LAGVal_loB_contra(tblock).std = std(contra_loB_lag);
%     
%     LAGVal_hiB_ipsi(tblock).mean = mean(ipsi_hiB_lag);
%     LAGVal_hiB_ipsi(tblock).sterr = std(ipsi_hiB_lag)/sqrt(numel(ipsi_hiB_lag)-1);
%     LAGVal_hiB_ipsi(tblock).std = std(ipsi_hiB_lag);
%     LAGVal_hiB_contra(tblock).mean = mean(contra_hiB_lag);
%     LAGVal_hiB_contra(tblock).sterr = std(contra_hiB_lag)/sqrt(numel(contra_hiB_lag)-1);
%     LAGVal_hiB_contra(tblock).std = std(contra_hiB_lag);
%     
%     STATS_loB_lag = cat(1, STATS_loB_lag, ipsi_loB_lag);
%     TimeGroup_loB_lag = cat(1, TimeGroup_loB_lag, t(tblock)*ones(size(ipsi_loB_lag)));
%     SideGroup_loB_lag = cat(1, SideGroup_loB_lag, 1*ones(size(ipsi_loB_lag)));
%     STATS_loB_lag = cat(1, STATS_loB_lag, contra_loB_lag);
%     TimeGroup_loB_lag = cat(1, TimeGroup_loB_lag, t(tblock)*ones(size(contra_loB_lag)));
%     SideGroup_loB_lag = cat(1, SideGroup_loB_lag, 2*ones(size(contra_loB_lag)));
%     STATS_hiB_lag = cat(1, STATS_hiB_lag, ipsi_hiB_lag);
%     TimeGroup_hiB_lag = cat(1, TimeGroup_hiB_lag, t(tblock)*ones(size(ipsi_hiB_lag)));
%     SideGroup_hiB_lag = cat(1, SideGroup_hiB_lag, 1*ones(size(ipsi_hiB_lag)));
%     STATS_hiB_lag = cat(1, STATS_hiB_lag, contra_hiB_lag);
%     TimeGroup_hiB_lag = cat(1, TimeGroup_hiB_lag, t(tblock)*ones(size(contra_hiB_lag)));
%     SideGroup_hiB_lag = cat(1, SideGroup_hiB_lag, 2*ones(size(contra_hiB_lag)));
% end
% 
% %% blob lag times loB
% figure; 
% shadedErrorBar(t, [LAGVal_loB_ipsi(:).mean], [LAGVal_loB_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% hold on
% shadedErrorBar(t, [LAGVal_loB_contra(:).mean], [LAGVal_loB_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
% hold on
% set(gca, 'FontSize', 20)
% %ylim([-.5 .5])
% xlim([-2.1 2.6])
% plot(xlim, [0 0], 'k:')
% plot([0 0], ylim, 'k:')
% title('loB');
% 
% %% blob lag times hiB
% figure; 
% shadedErrorBar(t, [LAGVal_hiB_ipsi(:).mean], [LAGVal_hiB_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% hold on
% shadedErrorBar(t, [LAGVal_hiB_contra(:).mean], [LAGVal_hiB_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
% hold on
% set(gca, 'FontSize', 20)
% %ylim([-.5 .5])
% xlim([-2.1 2.6])
% plot(xlim, [0 0], 'k:')
% plot([0 0], ylim, 'k:')
% title('hiB');
% 
% figure; 
% plot(t, LAGVal_ipsi);
% hold on; plot(t, LAGVal_contra)
% plot(xlim, [0 0], 'k:')
% plot([0 0], ylim, 'k:')
% 
% figure; 
% shadedErrorBar(t, [SPLVal_ipsi(:).mean], [SPLVal_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% hold on
% shadedErrorBar(t, [SPLVal_contra(:).mean], [SPLVal_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
% hold on
% set(gca, 'FontSize', 20)
% ylim([-.2 .5])
% xlim([-2.1 2.6])
% plot(xlim, [0 0], 'k:')
% plot([0 0], ylim, 'k:')
% 
% [p,tbl,stats] = anovan(STATS, {SideGroup, TimeGroup}, 'model', 'interaction','Display','off');
% mc = multcompare(stats,'Dimension',[1 2],'ctype', 'bonferroni','Display','off');
% clear mc_p
% for i=1:length(t_subset)
%     idx1=2*i-1;
%     idx2=2*i;
%     mc_p(i,1) = mc(find(mc(:,1)==idx1 & mc(:,2)==idx2),6);
%     mc_p(i,2) = mc_p(i,1)<0.05;
% end
% 
% clear hc_p0ipsi hc_p0contra
% for i=1:length(t_subset)
% 	hc_p0ipsi(i) = ttest(STATS(intersect(find(SideGroup==1), find(TimeGroup==t(i)))), 0, 'Alpha', 0.05/(2*length(t_subset)));
%     hc_p0contra(i) = ttest(STATS(intersect(find(SideGroup==2), find(TimeGroup==t(i)))), 0, 'Alpha', 0.05/(2*length(t_subset)));
% end
% 
% tsig = t(find(mc_p(:,2)==1));
% for i=1:length(tsig)
%     hold on; text(tsig(i), 0.45, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 24);
% end
% 
% tsig = t(find(hc_p0ipsi==1));
% for i=1:length(tsig)
%     hold on; text(tsig(i), -0.15, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 24);
% end
% 
% tsig = t(find(hc_p0contra==1));
% for i=1:length(tsig)
%     hold on; text(tsig(i), -0.175, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 24);
% end