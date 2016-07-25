AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
%TimecoursePath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL6/';
TimecoursePath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL6_B_clusters/';

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

nframes = 26;

for tblock=1:nframes
    for r = 1:length(regions_cats)
        %         SPLregion(r).group_timecourse(tblock).ipsi = zeros(501,37);
        SPLregion(r).group_timecourse(tblock).ipsi = [];
        %         SPLregion(r).group_timecourse(tblock).contra = zeros(501,37);
        SPLregion(r).group_timecourse(tblock).contra = [];
        SPLregion(r).group_timecourse(tblock).Count = 0;
        
        SPLregion(r).group_timecourse(tblock).RecInfo = {};
        
        SPLregion(r).group_timecourse(tblock).lowBipsi_blob = {};
        SPLregion(r).group_timecourse(tblock).lowBcontra_blob = {};
        SPLregion(r).group_timecourse(tblock).hiBipsi_blob = {};
        SPLregion(r).group_timecourse(tblock).hiBcontra_blob = {};
    end
end

field = 'corrz';
blobfield = 'corrz';
prespike = 250;
postspike = 250;
fs = 500;
t = (1:(prespike+postspike+1))/fs-(prespike+postspike+2)/(2*fs);
fq = 12:40;

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
            
            SU = load([TimecoursePath, S.unitsL{unit},'_SPLtimecourse2.mat']);
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
                    else
                        % plf
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = cat(3, ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi, ...
                            SU.timecourse(contact).SPL_LR(tblock).(field));
                        
                        ipsi_Bmax = max(max(SU.timecourse(contact).SPL_LR(tblock).(field)(:,9:end)));
                        
                        % blobzplf
                        NlowBipsi_blob = 0;
                        NhiBipsi_blob = 0;
                        blobstats = blob_stats_sub( SU.timecourse(contact).SPL_LR(tblock), blobfield, fq, t, [12 40], []);
                        for iblob=1:length(blobstats.blob)
                            if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                                blobstats.blob(iblob).RecID = SU.RecID;
                                blobstats.blob(iblob).contact = contact;      
                                blobstats.blob(iblob).Count = SPLregion(reg_cats(contact)).group_timecourse(tblock).Count;    
                                if blobstats.blob(iblob).max_unit(1) >= lowB(1) && blobstats.blob(iblob).max_unit(1) < lowB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob, ...
                                        blobstats.blob(iblob));
                                    NlowBipsi_blob = NlowBipsi_blob + 1;
                                elseif blobstats.blob(iblob).max_unit(1) >= hiB(1) && blobstats.blob(iblob).max_unit(1) <= hiB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob, ...
                                        blobstats.blob(iblob));
                                    NhiBipsi_blob = NhiBipsi_blob + 1;
                                end
                                fprintf('Ipsi blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).max_unit(1), blobstats.blob(iblob).max_unit(2), blobstats.blob(iblob).TotalValue);
                            end
                        end
                        
                        % plf
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = cat(3, ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).contra, ...
                            SU.timecourse(contact).SPL_RR(tblock).(field));
                        
                        contra_Bmax = max(max(SU.timecourse(contact).SPL_RR(tblock).(field)(:,9:end)));
                        
                        % blobzplf
                        NlowBcontra_blob = 0;
                        NhiBcontra_blob = 0;
                        blobstats = blob_stats_sub( SU.timecourse(contact).SPL_RR(tblock), blobfield, fq, t, [12 40], []);
                        for iblob=1:length(blobstats.blob)
                            if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                                blobstats.blob(iblob).RecID = SU.RecID;
                                blobstats.blob(iblob).contact = contact;
                                blobstats.blob(iblob).Count = SPLregion(reg_cats(contact)).group_timecourse(tblock).Count;
                                if blobstats.blob(iblob).max_unit(1) >= lowB(1) && blobstats.blob(iblob).max_unit(1) < lowB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob, ...
                                        blobstats.blob(iblob));
                                    NlowBcontra_blob = NlowBcontra_blob + 1;
                                elseif blobstats.blob(iblob).max_unit(1) >= hiB(1) && blobstats.blob(iblob).max_unit(1) <= hiB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob, ...
                                        blobstats.blob(iblob));
                                    NhiBcontra_blob = NhiBcontra_blob + 1;
                                end
                                fprintf('Contra blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).max_unit(1), blobstats.blob(iblob).max_unit(2), blobstats.blob(iblob).TotalValue);
                            end
                        end
                        
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).Count = ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).Count + 1;
                        
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).RecInfo( ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).Count,:) = ...
                            {SU.RecID contact ipsi_Bmax contra_Bmax ...
                            NlowBipsi_blob NhiBipsi_blob NlowBcontra_blob NhiBcontra_blob};
                        
                        
                    end
                end
            end
        end
    end
    
    if isfield(S, 'unitsR')
        
        % Recordings on the RIGHT side of the brain
        for unit=1:length(S.unitsR)
            SU = load([TimecoursePath, S.unitsR{unit},'_SPLtimecourse2.mat']);
            fprintf('Recording (right) %s...\n',SU.RecID);
            
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.timecourse)
                for tblock = 1:nframes
                    
                    if sum(isnan(SU.timecourse(contact).SPL_LR(tblock).(field)))>0 | ...
                            sum(isnan(SU.timecourse(contact).SPL_RR(tblock).(field)))>0
                        fprintf('WARNING: NaN datapoints found!\n');
                        fprintf('         contact %d, tblock %d\n', contact, tblock);
                    else
                        
                        % plf
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = cat(3, ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi, ...
                            SU.timecourse(contact).SPL_RR(tblock).(field));
                        
                        ipsi_Bmax = max(max(SU.timecourse(contact).SPL_RR(tblock).(field)(:,9:end)));
                        
                        % blobzplf
                        NlowBipsi_blob = 0;
                        NhiBipsi_blob = 0;
                        blobstats = blob_stats_sub( SU.timecourse(contact).SPL_RR(tblock), blobfield, fq, t, [12 40], []);
                        for iblob=1:length(blobstats.blob)
                            if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                                blobstats.blob(iblob).RecID = SU.RecID;
                                blobstats.blob(iblob).contact = contact;
                                blobstats.blob(iblob).Count = SPLregion(reg_cats(contact)).group_timecourse(tblock).Count;
                                if blobstats.blob(iblob).max_unit(1) >= lowB(1) && blobstats.blob(iblob).max_unit(1) < lowB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBipsi_blob, ...
                                        blobstats.blob(iblob));
                                    NlowBipsi_blob = NlowBipsi_blob + 1;
                                elseif blobstats.blob(iblob).max_unit(1) >= hiB(1) && blobstats.blob(iblob).max_unit(1) <= hiB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBipsi_blob, ...
                                        blobstats.blob(iblob));
                                    NhiBipsi_blob = NhiBipsi_blob + 1;
                                end
                                fprintf('Ipsi blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).max_unit(1), blobstats.blob(iblob).max_unit(2), blobstats.blob(iblob).TotalValue);
                            end
                        end
                        
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = cat(3, ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).contra, ...
                            SU.timecourse(contact).SPL_LR(tblock).(field));
                        
                        contra_Bmax = max(max(SU.timecourse(contact).SPL_LR(tblock).(field)(:,9:end)));
                        
                        % blobzplf
                        NlowBcontra_blob = 0;
                        NhiBcontra_blob = 0;
                        blobstats = blob_stats_sub( SU.timecourse(contact).SPL_LR(tblock), blobfield, fq, t, [12 40], []);
                        for iblob=1:length(blobstats.blob)
                            if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                                blobstats.blob(iblob).RecID = SU.RecID;
                                blobstats.blob(iblob).contact = contact;
                                blobstats.blob(iblob).Count = SPLregion(reg_cats(contact)).group_timecourse(tblock).Count;
                                if blobstats.blob(iblob).max_unit(1) >= lowB(1) && blobstats.blob(iblob).max_unit(1) < lowB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).lowBcontra_blob, ...
                                        blobstats.blob(iblob));
                                    NlowBcontra_blob = NlowBcontra_blob + 1;
                                elseif blobstats.blob(iblob).max_unit(1) >= hiB(1) && blobstats.blob(iblob).max_unit(1) <= hiB(2)
                                    SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob = cat(2, ...
                                        SPLregion(reg_cats(contact)).group_timecourse(tblock).hiBcontra_blob, ...
                                        blobstats.blob(iblob));
                                    NhiBcontra_blob = NhiBcontra_blob + 1;
                                end
                                fprintf('Contra blob: Contact %d, tblock %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, tblock, blobstats.blob(iblob).max_unit(1), blobstats.blob(iblob).max_unit(2), blobstats.blob(iblob).TotalValue);
                            end
                        end
                        
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).Count = ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).Count + 1;
                        
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).RecInfo( ...
                            SPLregion(reg_cats(contact)).group_timecourse(tblock).Count,:) = ...
                            {SU.RecID contact ipsi_Bmax contra_Bmax ...
                            NlowBipsi_blob NhiBipsi_blob NlowBcontra_blob NhiBcontra_blob};
                        
                        
                    end
                end
            end
        end
    end
    
end

for region=1:length(regions_cats)
    for tblock=1:nframes
        % lowB ipsi
        SPLregion(region).group_timecourse(tblock).RecInfo_lowBipsi.RecID = ...
            unique(cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).lowBipsi_blob, 'uniformoutput', false));
        for rec=1:length(SPLregion(region).group_timecourse(tblock).RecInfo_lowBipsi.RecID)
            idx = find(strcmp(SPLregion(region).group_timecourse(tblock).RecInfo_lowBipsi.RecID{rec}, ...
                cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).lowBipsi_blob, 'uniformoutput', false)));
            [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).group_timecourse(tblock).lowBipsi_blob(idx)));
            SPLregion(region).group_timecourse(tblock).lowBipsi_blob_Max{rec} = ...
                SPLregion(region).group_timecourse(tblock).lowBipsi_blob{idx(idxMax)};
        end
        % lowB contra
        SPLregion(region).group_timecourse(tblock).RecInfo_lowBcontra.RecID = ...
            unique(cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).lowBcontra_blob, 'uniformoutput', false));
        for rec=1:length(SPLregion(region).group_timecourse(tblock).RecInfo_lowBcontra.RecID)
            idx = find(strcmp(SPLregion(region).group_timecourse(tblock).RecInfo_lowBcontra.RecID{rec}, ...
                cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).lowBcontra_blob, 'uniformoutput', false)));
            [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).group_timecourse(tblock).lowBcontra_blob(idx)));
            SPLregion(region).group_timecourse(tblock).lowBcontra_blob_Max{rec} = ...
                SPLregion(region).group_timecourse(tblock).lowBcontra_blob{idx(idxMax)};
        end
        % hiB ipsi
        SPLregion(region).group_timecourse(tblock).RecInfo_hiBipsi.RecID = ...
            unique(cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).hiBipsi_blob, 'uniformoutput', false));
        for rec=1:length(SPLregion(region).group_timecourse(tblock).RecInfo_hiBipsi.RecID)
            idx = find(strcmp(SPLregion(region).group_timecourse(tblock).RecInfo_hiBipsi.RecID{rec}, ...
                cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).hiBipsi_blob, 'uniformoutput', false)));
            [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).group_timecourse(tblock).hiBipsi_blob(idx)));
            SPLregion(region).group_timecourse(tblock).hiBipsi_blob_Max{rec} = ...
                SPLregion(region).group_timecourse(tblock).hiBipsi_blob{idx(idxMax)};
        end
        % hiB contra
        SPLregion(region).group_timecourse(tblock).RecInfo_hiBcontra.RecID = ...
            unique(cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).hiBcontra_blob, 'uniformoutput', false));
        for rec=1:length(SPLregion(region).group_timecourse(tblock).RecInfo_hiBcontra.RecID)
            idx = find(strcmp(SPLregion(region).group_timecourse(tblock).RecInfo_hiBcontra.RecID{rec}, ...
                cellfun(@(x) x.RecID, SPLregion(region).group_timecourse(tblock).hiBcontra_blob, 'uniformoutput', false)));
            [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).group_timecourse(tblock).hiBcontra_blob(idx)));
            SPLregion(region).group_timecourse(tblock).hiBcontra_blob_Max{rec} = ...
                SPLregion(region).group_timecourse(tblock).hiBcontra_blob{idx(idxMax)};
        end
    end
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% T = 5;
% t_subset = 1:26;
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
% t = ((1:nframes)-1)/T - 2.5;
% t = t(t_subset);
% tval = -0.5:.002:0.5;
% r=4;
% fqrange = [12 25];
% trange = [-.251 .25];
%
% %%
% iti = mean(SPLregionITI(r).iti( ...
%     findval(trange(1),trange(2),tval), ...
%     findval(fqrange(1),fqrange(2),fq),:),3);
% binsize = floor(size(iti,1)/nbins);
% iti = bin(mean(iti,2),nbins)/binsize;
% SPLVal_iti.mean = mean(iti(:));
% SPLVal_iti.sterr = std(iti(:))/sqrt(numel(iti(:))-1);
% SPLVal_iti.std = std(iti(:));
%
% %%
%
% clear SPLVal_ipsi SPLVal_contra LAGVal_ipsi LAGVal_contra LAGVal_side
% for tblock = 1:length(t_subset)
%     %%
%     ipsi = mean(SPLregion(r).group_timecourse(t_subset(tblock)).ipsi( ...
%         findval(trange(1),trange(2),tval), ...
%         findval(fqrange(1),fqrange(2),fq),:),3);
%
%     %[~, idx] = max(mean(ipsi,2));
%     [~, idx] = max(squeeze(mean(SPLregion(r).group_timecourse(t_subset(tblock)).ipsi( ...
%         findval(trange(1),trange(2),tval), ...
%         findval(fqrange(1),fqrange(2),fq),:),2)),[],1);
%     temp = linspace(trange(1), trange(2), size(ipsi,1));
%     LAGVal_ipsi(tblock).peakval = temp(idx);
%     LAGVal_ipsi(tblock).mean = mean(temp(idx));
%     LAGVal_ipsi(tblock).median = median(temp(idx));
%     LAGVal_ipsi(tblock).sterr = std(temp(idx))/sqrt(numel(idx)-1);
%     clear hc_lag_p0ipsi hc_lag_p0contra
% 	[LAGVal_ipsi(tblock).h, LAGVal_ipsi(tblock).p] = ttest( ...
%         temp(idx), 0, 'Alpha', 0.05/(2*length(t_subset)));
%
%     binsize = floor(size(ipsi,1)/nbins);
%     ipsi = bin(mean(ipsi,2),nbins)/binsize;
%
%     %%
%     contra = mean(SPLregion(r).group_timecourse(t_subset(tblock)).contra( ...
%         findval(trange(1),trange(2),tval), ...
%         findval(fqrange(1),fqrange(2),fq),:),3);
%
%     %[~, idx] = max(mean(contra,2));
%     [~, idx] = max(squeeze(mean(SPLregion(r).group_timecourse(t_subset(tblock)).contra( ...
%         findval(trange(1),trange(2),tval), ...
%         findval(fqrange(1),fqrange(2),fq),:),2)),[],1);
%     temp = linspace(trange(1), trange(2), size(contra,1));
%     LAGVal_contra(tblock).peakval = temp(idx);
%     LAGVal_contra(tblock).mean = median(temp(idx));
%     LAGVal_contra(tblock).median = median(temp(idx));
%     LAGVal_contra(tblock).sterr = std(temp(idx))/sqrt(numel(idx)-1);
%     [LAGVal_contra(tblock).h, LAGVal_contra(tblock).p] = ttest( ...
%         temp(idx), 0, 'Alpha', 0.05/(length(t_subset)));
%
%     [LAGVal_side(tblock).h, LAGVal_side(tblock).p] = ttest( ...
%         LAGVal_ipsi(tblock).peakval, LAGVal_contra(tblock).peakval, 'Alpha', 0.05/(length(t_subset)));
%
%     binsize = floor(size(contra,1)/nbins);
%     contra = bin(mean(contra,2),nbins)/binsize;
%
%     %%
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
%     %%
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
% % %% blob lag times loB
% % figure;
% % shadedErrorBar(t, [LAGVal_loB_ipsi(:).mean], [LAGVal_loB_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% % hold on
% % shadedErrorBar(t, [LAGVal_loB_contra(:).mean], [LAGVal_loB_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
% % hold on
% % set(gca, 'FontSize', 20)
% % %ylim([-.5 .5])
% % xlim([-2.6 2.6])
% % plot(xlim, [0 0], 'k:')
% % plot([0 0], ylim, 'k:')
% % title('loB');
% %
% % %% blob lag times hiB
% % figure;
% % shadedErrorBar(t, [LAGVal_hiB_ipsi(:).mean], [LAGVal_hiB_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% % hold on
% % shadedErrorBar(t, [LAGVal_hiB_contra(:).mean], [LAGVal_hiB_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
% % hold on
% % set(gca, 'FontSize', 20)
% % %ylim([-.5 .5])
% % xlim([-2.6 2.6])
% % plot(xlim, [0 0], 'k:')
% % plot([0 0], ylim, 'k:')
% % title('hiB');
%
% figure;
% shadedErrorBar(t, ([SPLVal_ipsi(:).mean]-SPLVal_iti.mean), [SPLVal_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% hold on
% shadedErrorBar(t, ([SPLVal_contra(:).mean]-SPLVal_iti.mean), [SPLVal_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
% hold on
% set(gca, 'FontSize', 20)
% ylim([-0.4 0.3])
% xlim([-2.6 2.6])
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
% clear hc_p0ipsi hc_p0contra hc_iti_ipsi hc_iti_contra
% for i=1:length(t_subset)
% 	hc_p0ipsi(i) = ttest(STATS(intersect(find(SideGroup==1), find(TimeGroup==t(i)))), 0, 'Alpha', 0.05/(2*length(t_subset)));
%     hc_p0contra(i) = ttest(STATS(intersect(find(SideGroup==2), find(TimeGroup==t(i)))), 0, 'Alpha', 0.05/(2*length(t_subset)));
%
% 	hc_iti_ipsi(i) = ttest(STATS(intersect(find(SideGroup==1), find(TimeGroup==t(i)))), SPLVal_iti.mean, 'Alpha', 0.05/(2*length(t_subset)));
%     hc_iti_contra(i) = ttest(STATS(intersect(find(SideGroup==2), find(TimeGroup==t(i)))), SPLVal_iti.mean, 'Alpha', 0.05/(2*length(t_subset)));
% end
%
% tsig = t(find(mc_p(:,2)==1));
% for i=1:length(tsig)
%     hold on; text(tsig(i), 0.25, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 24);
% end
%
% %tsigipsi = t(find(hc_p0ipsi==1));
% tsigipsi = t(find(hc_iti_ipsi==1));
% for i=1:length(tsigipsi)
%     hold on; text(tsigipsi(i), -0.35, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 24);
% end
%
% %tsigcontra = t(find(hc_p0contra==1));
% tsigcontra = t(find(hc_iti_contra==1));
% for i=1:length(tsigcontra)
%     hold on; text(tsigcontra(i), -0.375, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 24);
% end
%
% figure; hold on;
% % idx = intersect(find(hc_p0ipsi==1), find([SPLVal_ipsi(:).mean]>0));
% % for i=1:length(idx)
% %     errorbar(t(idx(i)), 1000*LAGVal_ipsi(idx(i)).median, 1000*LAGVal_ipsi(idx(i)).sterr, '.', 'Color', 'b', 'MarkerSize', 24);
% % end
% % idx = intersect(find(hc_p0contra==1), find([SPLVal_contra(:).mean]>0));
% % for i=1:length(idx)
% %     errorbar(t(idx(i)), 1000*LAGVal_contra(idx(i)).median, 1000*LAGVal_contra(idx(i)).sterr, '.', 'Color', 'r', 'MarkerSize', 24);
% % end
%
% % plot(t, 1000*[LAGVal_ipsi(:).median], 'b');
% % for i=1:length(t)
% %     errorbar(t(i), 1000*LAGVal_ipsi(i).median, 1000*LAGVal_ipsi(i).sterr, 'b.', 'MarkerSize', 24);
% % end
% % plot(t, 1000*[LAGVal_contra(:).median], 'r');
% % for i=1:length(t)
% %     errorbar(t(i), 1000*LAGVal_contra(i).median, 1000*LAGVal_contra(i).sterr, 'r.', 'MarkerSize', 24);
% % end
%
% shadedErrorBar(t, 1000*[LAGVal_ipsi(:).median], 1000*[LAGVal_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
% shadedErrorBar(t, 1000*[LAGVal_contra(:).median], 1000*[LAGVal_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
%
% xlim([-2.6 2.6])
% ylim([-250 250])
% plot(xlim, [0 0], 'k:')
% plot([0 0], ylim, 'k:')
% set(gca, 'FontSize', 20)
%
% tsiglag = t([LAGVal_side(:).h]==1);
% for i=1:length(tsiglag)
%     hold on; text(tsiglag(i), 200, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 24);
% end
%
%
% % tsiglagipsi = t(intersect(intersect(find([LAGVal_ipsi(:).h]==1), find(hc_p0ipsi==1)),find([SPLVal_ipsi(:).mean]>0)));
% % for i=1:length(tsiglagipsi)
% %     hold on; text(tsiglagipsi(i), 200, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 24);
% % end
% % tsiglagcontra = t(intersect(intersect(find([LAGVal_contra(:).h]==1), find(hc_p0contra==1)),find([SPLVal_contra(:).mean]>0)));
% % for i=1:length(tsiglagcontra)
% %     hold on; text(tsiglagcontra(i), 225, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 24);
% % end