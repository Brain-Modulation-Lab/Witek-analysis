ICBM152_path = '/Users/Witek/Documents/Data/Brainstorm_db/DBS/anat/@default_subject/';
load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');

atlas=3;

V = zeros(length(Vertices),3);
for region=1:length(Atlas(atlas).Scouts)
V(Atlas(atlas).Scouts(region).Vertices,:) = repmat(Atlas(atlas).Scouts(region).Color,length(Atlas(atlas).Scouts(region).Vertices),1);
end
figure; patch('vertices',Vertices,'faces',Faces,'FaceVertexCData',V,'edgecolor','none','FaceColor','interp');
axis equal
camlight('headlight','infinite');
fh(1)=gcf;
axis off;

%===========
% draw DK4 regions

colors = {[1,0.752941176470588,0.125490196078431], ...
          [0.862745098039216,0.0784313725490196,0.0784313725490196], ...
          [0.235294117647059,0.0784313725490196,0.862745098039216], ...
          [0.0784313725490196,0.862745098039216,0.627450980392157]};
figure;
for reg_idx=1:4
    V = ones(length(Vertices),3)*0.75;
    for region=1:length(bilateral4_regions_index{reg_idx})
        V(Atlas(atlas).Scouts(regions(bilateral4_regions_index{reg_idx}(region))).Vertices,:) = ...
            repmat(colors{reg_idx}, ...
            length(Atlas(atlas).Scouts(regions(bilateral4_regions_index{reg_idx}(region))).Vertices),1);
    end
    hh_cort(reg_idx) = subplot(2,4,reg_idx);
    patch('vertices',Vertices,'faces',Faces,'FaceVertexCData',V,'edgecolor','none','FaceColor','interp');
    axis equal
    camlight('headlight','infinite');
    fh(1)=gcf;
    axis off;
end

for reg_idx=1:4
    camzoom(hh_cort(reg_idx), 1.3);
end

