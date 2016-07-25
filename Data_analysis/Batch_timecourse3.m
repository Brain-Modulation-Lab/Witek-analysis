%  AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
%  TimecoursePath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL3/';
% 
% 
% dat_files = dir('*.mat');
% 
% regions = {};
% 
% for i=1:length(dat_files)
%     filename=dat_files(i).name;
%     fprintf('%s... \n', filename);
%     S = load(filename);
%     
%     if isfield(S.Anatomy.Atlas(3), 'CortElecLocL')
%         regions = cat(1, regions, cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)');
%     end
%     if isfield(S.Anatomy.Atlas(3), 'CortElecLocR')
%         regions = cat(1, regions, cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)');
%     end
%     
% end
% 
% regions = unique(regions);
% 
% regions_cats = {'frontal', 'precentral', 'postcentral', 'parietal'};
% 
% region_groups = {{'caudalmiddlefrontal L';'caudalmiddlefrontal R';'superiorfrontal L';'superiorfrontal R'}, ...
%                 {'precentral L';'precentral R'}, ...
%                 {'postcentral L','postcentral R'}, ...
%                 {'inferiorparietal L';'inferiorparietal R';'superiorparietal L';'superiorparietal R';'supramarginal L';'supramarginal R'}};
% 
% nframes = 26;
%             
% for tblock=1:nframes
%     for r = 1:length(regions_cats)
%         SPLregion(r).group_timecourse(tblock).ipsi = zeros(501,37);
%         SPLregion(r).group_timecourse(tblock).contra = zeros(501,37);
%         SPLregion(r).group_timecourse(tblock).ipsiCount = 0;
%         SPLregion(r).group_timecourse(tblock).contraCount = 0;
%     end
% end
%  
% field = 'zplf';
% 
% % find which set of region_groups the string y belongs to
% which_regcat = @(y) find(cell2mat(cellfun(@(x) sum(strcmp(y, x))>0, region_groups, 'uniformoutput', false)));
% 
% cd(AnatomyPath);
% 
% for i=1:length(dat_files)
%     filename=dat_files(i).name;
%     fprintf('%s... \n', filename);
%     S = load(filename);
%     
%     if isfield(S, 'unitsL')
%         
%         % Recordings on the LEFT side of the brain
%         for unit=1:length(S.unitsL)
%             
%             SU = load([TimecoursePath, S.unitsL{unit},'_SPLtimecourse.mat']);
%             fprintf('Recording (left) %s...\n',SU.RecID);
%             
%             %find what anatomical category each contact belongs to
%             regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)';
%             reg_cats = cellfun(which_regcat, regs);
%             
%             for contact=1:length(SU.timecourse)
%                 for tblock = 1:nframes
%                     
%                     if sum(isnan(SU.timecourse(contact).SPL_LR(tblock).(field)))>0 | ...
%                             sum(isnan(SU.timecourse(contact).SPL_RR(tblock).(field)))>0
%                         fprintf('WARNING: NaN datapoints found!\n');
%                         fprintf('         contact %d, tblock %d\n', contact, tblock);
%                     end
%                     
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi + ...
%                         SU.timecourse(contact).SPL_LR(tblock).(field);
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount + 1;
% 
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).contra + ...
%                         SU.timecourse(contact).SPL_RR(tblock).(field);
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount + 1;
%                 end
%             end
%         end
%     end
%     
%     if isfield(S, 'unitsR')
%         
%         % Recordings on the RIGHT side of the brain
%         for unit=1:length(S.unitsR)
%             SU = load([TimecoursePath, S.unitsR{unit},'_SPLtimecourse.mat']);
%             fprintf('Recording (right) %s...\n',SU.RecID);
%             
%             regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
%             reg_cats = cellfun(which_regcat, regs);
%             
%             for contact=1:length(SU.timecourse)
%                 for tblock = 1:nframes
%                     
%                     if sum(isnan(SU.timecourse(contact).SPL_LR(tblock).(field)))>0 | ...
%                             sum(isnan(SU.timecourse(contact).SPL_RR(tblock).(field)))>0
%                         fprintf('WARNING: NaN datapoints found!\n');
%                         fprintf('         contact %d, tblock %d\n', contact, tblock);
%                     end
%                     
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi + ...
%                         SU.timecourse(contact).SPL_RR(tblock).(field);
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount + 1;
%                     
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).contra + ...
%                         SU.timecourse(contact).SPL_LR(tblock).(field);
%                     SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount = ...
%                         SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount + 1;
%                 end
%             end
%         end
%     end
%     
% end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = 5;
t_subset = 4:26;

STATS = [];
TimeGroup = [];
SideGroup = [];

fq = 4:40;
t = ((1:nframes)-1)/T - 2.5;
t = t(t_subset);
tval = -0.5:.002:0.5;
r=3;
fqrange = [12 25];
trange = [-.25 .25];
clear SPLVal_ipsi SPLVal_contra
for tblock = 1:length(t_subset)
    ipsi = SPLregion(r).group_timecourse(t_subset(tblock)).ipsi( ...
        findval(trange(1),trange(2),tval), ...
        findval(fqrange(1),fqrange(2),fq));
    ipsi = mean(ipsi,1)/SPLregion(r).group_timecourse(t_subset(tblock)).ipsiCount;
    
    contra = SPLregion(r).group_timecourse(t_subset(tblock)).contra( ...
        findval(trange(1),trange(2),tval), ...
        findval(fqrange(1),fqrange(2),fq));
    contra = mean(contra,1)/SPLregion(r).group_timecourse(t_subset(tblock)).contraCount;
    
    SPLVal_ipsi(tblock).mean = mean(ipsi(:));
    SPLVal_ipsi(tblock).sterr = std(ipsi(:))/sqrt(numel(ipsi(:))-1);
    SPLVal_ipsi(tblock).std = std(ipsi(:));
    SPLVal_contra(tblock).mean = mean(contra(:));
    SPLVal_contra(tblock).sterr = std(contra(:))/sqrt(numel(contra(:))-1);
    SPLVal_contra(tblock).std = std(contra(:));
    
    STATS = cat(1, STATS, ipsi(:));
    TimeGroup = cat(1, TimeGroup, t(tblock)*ones(size(ipsi(:))));
    SideGroup = cat(1, SideGroup, 1*ones(size(ipsi(:))));
    STATS = cat(1, STATS, contra(:));
    TimeGroup = cat(1, TimeGroup, t(tblock)*ones(size(contra(:))));
    SideGroup = cat(1, SideGroup, 2*ones(size(contra(:))));
end

figure; 
shadedErrorBar(t, [SPLVal_ipsi(:).mean], [SPLVal_ipsi(:).sterr], {'-b.', 'MarkerSize', 12} ,1);
hold on
shadedErrorBar(t, [SPLVal_contra(:).mean], [SPLVal_contra(:).sterr], {'-r.', 'MarkerSize', 12} ,1);
hold on
set(gca, 'FontSize', 20)
ylim([-.2 .6])
xlim([-2 2.6])
plot(xlim, [0 0], 'k:')
plot([0 0], ylim, 'k:')


[p,tbl,stats] = anovan(STATS, {SideGroup, TimeGroup}, 'model', 'interaction','Display','off');
mc = multcompare(stats,'Dimension',[1 2],'ctype', 'bonferroni','Display','off');
clear mc_p
for i=1:length(t_subset)
    idx1=2*i-1;
    idx2=2*i;
    mc_p(i,1) = mc(find(mc(:,1)==idx1 & mc(:,2)==idx2),6);
    mc_p(i,2) = mc_p(i,1)<0.05;
end