 AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
 TimecoursePath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL3/';


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

region_groups = {{'caudalmiddlefrontal L';'caudalmiddlefrontal R';'superiorfrontal L'}, ...
                {'precentral L';'precentral R'}, ...
                {'postcentral L','postcentral R'}, ...
                {'inferiorparietal L';'superiorparietal R';'supramarginal R'}};

nframes = 26;
            
for tblock=1:nframes
    for r = 1:length(regions_cats)
%         SPLregion(r).group_timecourse(tblock).ipsi = zeros(501,37);
        SPLregion(r).group_timecourse(tblock).ipsi = [];
%         SPLregion(r).group_timecourse(tblock).contra = zeros(501,37);
        SPLregion(r).group_timecourse(tblock).contra = [];
        SPLregion(r).group_timecourse(tblock).ipsiCount = 0;
        SPLregion(r).group_timecourse(tblock).contraCount = 0;
    end
end
 
field = 'zplf';

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
            
            SU = load([TimecoursePath, S.unitsL{unit},'_SPLtimecourse.mat']);
            fprintf('Recording (left) %s...\n',SU.RecID);
            
            %find what anatomical category each contact belongs to;
            %atlas 3 = Desikan-Killiany 
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.timecourse)
                for tblock = 1:nframes
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi, ...
                        SU.timecourse(contact).SPL_LR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount + 1;

                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contra, ...
                        SU.timecourse(contact).SPL_RR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount + 1;
                end
            end
        end
    end
    
    if isfield(S, 'unitsR')
        
        % Recordings on the RIGHT side of the brain
        for unit=1:length(S.unitsR)
            SU = load([TimecoursePath, S.unitsR{unit},'_SPLtimecourse.mat']);
            fprintf('Recording (right) %s...\n',SU.RecID);
            
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.timecourse)
                for tblock = 1:nframes
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsi, ...
                        SU.timecourse(contact).SPL_RR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).ipsiCount + 1;
                    
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contra = cat(3, ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contra, ...
                        SU.timecourse(contact).SPL_LR(tblock).(field));
                    SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount = ...
                        SPLregion(reg_cats(contact)).group_timecourse(tblock).contraCount + 1;
                end
            end
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
r=2;
fqrange = [12 25];
trange = [-.25 .25];
clear SPLVal_ipsi SPLVal_contra
for tblock = 1:length(t_subset)
    ipsi = SPLregion(r).group_timecourse(t_subset(tblock)).ipsi( ...
        findval(trange(1),trange(2),tval), ...
        findval(fqrange(1),fqrange(2),fq), ...
        :);
%     ipsi = mean(ipsi,1)/SPLregion(r).group_timecourse(t_subset(tblock)).ipsiCount;
    
    contra = SPLregion(r).group_timecourse(t_subset(tblock)).contra( ...
        findval(trange(1),trange(2),tval), ...
        findval(fqrange(1),fqrange(2),fq), ...
        :);
%     contra = mean(contra,1)/SPLregion(r).group_timecourse(t_subset(tblock)).contraCount;
    
    ipsi = reshape(ipsi,[],size(ipsi,3));
    contra = reshape(contra,[],size(contra,3));

    SPLVal_ipsi(tblock).mean = mean(ipsi,1)';
    SPLVal_ipsi(tblock).sterr = std(ipsi,0,1)'/sqrt(size(ipsi,1)-1);
    SPLVal_ipsi(tblock).std = std(ipsi,0,1)';
    SPLVal_contra(tblock).mean = mean(contra,1)';
    SPLVal_contra(tblock).sterr = std(contra,0,1)'/sqrt(size(contra,1)-1);
    SPLVal_contra(tblock).std = std(contra,0,1)';
    
    STATS = cat(1, STATS, ipsi(:));
    TimeGroup = cat(1, TimeGroup, t(tblock)*ones(size(ipsi(:))));
    SideGroup = cat(1, SideGroup, 1*ones(size(ipsi(:))));
    STATS = cat(1, STATS, contra(:));
    TimeGroup = cat(1, TimeGroup, t(tblock)*ones(size(contra(:))));
    SideGroup = cat(1, SideGroup, 2*ones(size(contra(:))));
end

offset = 2;
figure; hold on;
for rec=1:size(SPLVal_ipsi(1).mean,1)
    this_mean = [SPLVal_ipsi(:).mean];
    this_sterr = [SPLVal_ipsi(:).sterr];
    %plot(t, this_mean(rec,:)-offset*(rec-1), 'b')
    shadedErrorBar(t, this_mean(rec,:)-offset*(rec-1), this_sterr(rec,:), {'-b.', 'MarkerSize', 12} ,1);
    hold on
    this_mean = [SPLVal_contra(:).mean];
    this_sterr = [SPLVal_contra(:).sterr];
    %plot(t, this_mean(rec,:)-offset*(rec-1), 'r')
    shadedErrorBar(t, this_mean(rec,:)-offset*(rec-1), this_sterr(rec,:), {'-r.', 'MarkerSize', 12} ,1);
    hold on
end
set(gca, 'FontSize', 20)
%ylim([-.2 .6])
%xlim([-2 2.6])
plot(xlim, [0 0], 'k:')
plot([0 0], ylim, 'k:')

% color plot of individual recs
clear ColorplorVal
for rec=1:size(SPLVal_ipsi(1).mean,1)
    this_mean = [SPLVal_ipsi(:).mean];
    ColorplotValIpsi(rec,:) = (this_mean(rec,:)-mean(this_mean(rec,1:5)))/std(this_mean(rec,1:5));
    this_mean = [SPLVal_contra(:).mean];
    ColorplotValContra(rec,:) = (this_mean(rec,:)-mean(this_mean(rec,1:5)))/std(this_mean(rec,1:5));
end
figure; 
colormap jet;
imagesc(t, 1:size(SPLVal_ipsi(1).mean,1), ColorplotValIpsi); set(gca,'YDir','normal'); 
set(gca,'FontSize',20); 
hold on; 
plot([0 0], ylim, ':', 'Color', 'w');
figure; 
colormap jet;
imagesc(t, 1:size(SPLVal_contra(1).mean,1), ColorplotValContra); set(gca,'YDir','normal'); 
set(gca,'FontSize',20); 
hold on; 
plot([0 0], ylim, ':', 'Color', 'w');
figure; 
colormap jet;
imagesc(t, 1:size(SPLVal_contra(1).mean,1), ColorplotValContra-ColorplotValIpsi); set(gca,'YDir','normal'); 
set(gca,'FontSize',20); 
hold on; 
plot([0 0], ylim, ':', 'Color', 'w');

% [p,tbl,stats] = anovan(STATS, {SideGroup, TimeGroup}, 'model', 'interaction','Display','off');
% mc = multcompare(stats,'Dimension',[1 2],'ctype', 'lsd','Display','off');
% clear mc_p
% for i=1:length(t_subset)
%     idx1=2*i-1;
%     idx2=2*i;
%     mc_p(i,1) = mc(find(mc(:,1)==idx1 & mc(:,2)==idx2),6);
%     mc_p(i,2) = mc_p(i,1)<0.05;
% end