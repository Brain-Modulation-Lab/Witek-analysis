AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';

load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

cd(AnatomyPath);
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
% %%%

% find which set of region_groups the string y belongs to
% which_regcat = @(y) find(cell2mat(cellfun(@(x) sum(strcmp(y, x))>0, region_groups, 'uniformoutput', false)));


for r=1:4
    Region(r).V = zeros(length(Vertices),1);
    Region(r).V_color = 0.85*ones(length(Vertices),3);
end

for i=1:length(dat_files)
    filename=dat_files(i).name;
    fprintf('%s... \n', filename);
    S = load(filename);
    
    if isfield(S.Anatomy.Atlas(3), 'CortElecLocL')
        regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)';
        reg_cats = cellfun(which_regcat, regs);
        
        for contact=1:length(reg_cats)
            Vtemp = zeros(size(S.Wmat,2),1);
            Vtemp(S.al{contact})=1;
            Vtemp = S.Wmat*Vtemp;
            Region(reg_cats(contact)).V = Region(reg_cats(contact)).V + Vtemp;
        end
    end
    if isfield(S.Anatomy.Atlas(3), 'CortElecLocR')
        regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
        reg_cats = cellfun(which_regcat, regs);
        
        for contact=1:length(reg_cats)
            Vtemp = zeros(size(S.Wmat,2),1);
            Vtemp(S.ar{contact})=1;
            Vtemp = S.Wmat*Vtemp;
            Region(reg_cats(contact)).V = Region(reg_cats(contact)).V + Vtemp;
        end
    end
    
end


de = 0.005;
colors = {[1,0.752941176470588,0.125490196078431], ...
          [0.862745098039216,0.0784313725490196,0.0784313725490196], ...
          [0.235294117647059,0.0784313725490196,0.862745098039216], ...
          [0.0784313725490196,0.862745098039216,0.627450980392157]};

for r=1:4
    idx = find(Region(r).V~=0);
    idxe = [];
    for i=1:length(idx) 
        idxe = [idxe, find(pdist2(Vertices(idx(i),:), Vertices)<=de)];
    end
    idx = unique(union(idx, idxe));
    
    idx_reg = [];
    for rg = 1:length(region_groups{r})
        idx_reg = [idx_reg, ...
            Atlas(3).Scouts(find(strcmp(region_groups{r}{rg}, {Atlas(3).Scouts(:).Label}))).Vertices];
    end
    
    idx = intersect(idx, idx_reg);
    
    for i=1:length(idx)
        Region(r).V_color(idx(i),:) = colors{r};
    end
    
end

for r=1:4
    figure;
    Hp = patch('vertices',Vertices,'faces',Faces,'FaceVertexCData', Region(r).V_color, ...
        'edgecolor','none','FaceColor','interp', ...
        'FaceLighting', 'gouraud', 'SpecularStrength', 0.1);
    axis equal
    camlight('headlight','infinite');
    axis off;
end