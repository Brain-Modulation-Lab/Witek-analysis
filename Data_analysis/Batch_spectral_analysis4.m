AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
AWPath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/group_analysis/';

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
        SPLregion(r).AW(tblock).ipsi = [];
        SPLregion(r).AW(tblock).contra = [];
    end
end

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
            
            SU = load([AWPath, S.unitsL{unit},'_LFPresponse4.mat']);
            fprintf('Recording (left) %s...\n',SU.RecID);
            
            %find what anatomical category each contact belongs to
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:size(SU.AWl{1},2)
                for tblock = 1:nframes
                    
                    % ipsi
                    SPLregion(reg_cats(contact)).AW(tblock).ipsi = cat(1, ...
                        SPLregion(reg_cats(contact)).AW(tblock).ipsi, ...
                        cellfun(@(x) x(tblock,contact), SU.AWl));
                    % contra
                    SPLregion(reg_cats(contact)).AW(tblock).contra = cat(1, ...
                        SPLregion(reg_cats(contact)).AW(tblock).contra, ...
                        cellfun(@(x) x(tblock,contact), SU.AWr)); 
                end
            end
        end
    end
    
    if isfield(S, 'unitsR')
        
        % Recordings on the RIGHT side of the brain
        for unit=1:length(S.unitsR)
            SU = load([AWPath, S.unitsR{unit},'_LFPresponse4.mat']);
            fprintf('Recording (right) %s...\n',SU.RecID);
            
            %find what anatomical category each contact belongs to
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:size(SU.AWr{1},2)
                for tblock = 1:nframes
                    
                    % ipsi
                    SPLregion(reg_cats(contact)).AW(tblock).ipsi = cat(1, ...
                        SPLregion(reg_cats(contact)).AW(tblock).ipsi, ...
                        cellfun(@(x) x(tblock,contact), SU.AWr));
                    % contra
                    SPLregion(reg_cats(contact)).AW(tblock).contra = cat(1, ...
                        SPLregion(reg_cats(contact)).AW(tblock).contra, ...
                        cellfun(@(x) x(tblock,contact), SU.AWl)); 
                end
            end
        end
    end
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STATS = [];
RegionGroup = [];
TimeGroup = [];
SideGroup = [];
fb=1;
for r=1:4
    for ep=1:5
        STATS = cat(1, STATS, SPLregion(r).AW(ep).ipsi(:,fb));
        RegionGroup = cat(1, RegionGroup, r*ones(size(SPLregion(r).AW(ep).ipsi(:,fb))));
        TimeGroup = cat(1, TimeGroup, ep*ones(size(SPLregion(r).AW(ep).ipsi(:,fb))));
        SideGroup = cat(1, SideGroup, 1*ones(size(SPLregion(r).AW(ep).ipsi(:,fb))));
        STATS = cat(1, STATS, SPLregion(r).AW(ep).contra(:,fb));
        RegionGroup = cat(1, RegionGroup, r*ones(size(SPLregion(r).AW(ep).contra(:,fb))));
        TimeGroup = cat(1, TimeGroup, ep*ones(size(SPLregion(r).AW(ep).contra(:,fb))));
        SideGroup = cat(1, SideGroup, 2*ones(size(SPLregion(r).AW(ep).contra(:,fb))));
    end
end

[p,tbl,stats] = anovan(STATS, {SideGroup, TimeGroup, RegionGroup}, 'model', 'interaction');
mc = multcompare(stats,'Dimension',[1 2 3],'ctype', 'bonferroni');
mc_p = zeros([5 3 2]);
for ep=1:5
    for r=1:4
        idx1=10*(r-1)+2*ep-1;
        idx2=10*(r-1)+2*ep;
        mc_p(ep,r,1) = mc(find(mc(:,1)==idx1 & mc(:,2)==idx2),6);
        mc_p(ep,r,2) = mc_p(ep,r,1)<0.05;
    end
end


sterr = @(x) std(x,[], 1)/sqrt(size(x,1)-1);

figure;

YLIM = [-0.3 0.2];

for r=1:4
    ipsi = [];
    contra = [];
    for ep=1:5
        ipsi = cat(2, ipsi, SPLregion(r).AW(ep).ipsi(:,fb));
        contra = cat(2, contra, SPLregion(r).AW(ep).contra(:,fb));
    end
    %[h, p] = ttest2(x.ipsi(:,fb), x.contra(:,fb));
    subplot(4,1,r);
    errorbar(mean(ipsi, 1), sterr(ipsi));
    hold on; errorbar(mean(contra, 1), sterr(contra));
    idxsig = find(squeeze(mc_p(:,r,2)));
    if ~isempty(idxsig)
        hold on; text(idxsig, 0.5*YLIM(2)*ones(size(idxsig)),'*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 24);
    end
    ylim(YLIM);
    title(['FB',num2str(fb), ' R',num2str(r)]);
end
