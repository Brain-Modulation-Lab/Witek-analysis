
L{1} = zeros(501,37);
L{2} = zeros(501,37);
L{3} = zeros(501,37);

for fb=1:3
    
    idx = find(idx_1Dcat==fb);
    
    L{fb} = sum(cat(3,BlobData{idx,11}),3);

end

for fb=1:3
    for t=1:4
        for s=1:2
            idx = intersect(intersect( ...
                find([BlobData{:,5}]==t), ...
                find(idx_1Dcat==fb)), ...
                find([BlobData{:,4}]==s));

            L{fb} = L{fb} + sum(cat(3,BlobData{idx,11}),3);
        end
    end
    
    %L{fb}(L{fb}~=0)=1;
end

clear L;

for fb=1:3
    for region=1:4
        idx = intersect( ...
            find(DKatlas_bilateral4==region), ...
            find(idx_1Dcat==fb));
        
        L{fb,region} = sum(cat(3,BlobData{idx,11}),3);
        %L{fb,region}(L{fb}~=0)=1;
    end
end

for fb=1:3
    for t=1:4
        for region=1:4
            idx = intersect(intersect( ...
            find([BlobData{:,5}]==t), ...
            find(DKatlas_bilateral4==region)), ...
            find(idx_1Dcat==fb));
            
            L{fb,t,region} = sum(cat(3,BlobData{idx,11}),3);
            L{fb,t,region}(L{fb}~=0)=1;
        end
    end
end

for fb=1:3
    for t=1:4
        for s=1:2
            for region=1:4
                idx = intersect(intersect(intersect( ...
                    find([BlobData{:,5}]==t), ...
                    find(DKatlas_bilateral4==region)), ...
                    find(idx_1Dcat==fb)), ...
                    find([BlobData{:,4}]==s));
                
                if isempty(idx)
                    L{fb,t,s,region} = zeros(501,37);
                else
                    L{fb,t,s,region} = sum(cat(3,BlobData{idx,11}),3);
                end

            end
        end
    end
end

for fb=1:3
    for t=1:4
        for s=1:2
            for region=1:4
                idx = intersect(intersect(intersect( ...
                    find([BlobData{:,5}]==t), ...
                    find(DKatlas_bilateral4==region)), ...
                    find(idx_1Dcat==fb)), ...
                    find([BlobData{:,4}]==s));
                
                if isempty(idx)
                    L{fb,t,s,region} = zeros(501,37);
                else
                    temp = cellfun(@(A,B) A.*B,BlobData(idx,11),BlobData(idx,12), 'uniformoutput', false);
                    L{fb,t,s,region} = mean(cat(3,temp{:}),3);
                end

            end
        end
    end
end

for fb=1:3
    figure; 
    for region=1:4
        hh(region)=subplot(2,4,region);
        imagesc((1:(500+1))/500-(500)/(2*500), 4:40, L{fb,region}'); set(gca,'YDir','normal'); set(gca,'FontSize',14); hold on; plot([0 0], ylim, ':', 'Color', 'w');
        xlim([-0.5 0.5])
        set(gca, 'xtick', [-0.5 0 0.5]);
    end
    CommonCaxis = caxis((hh(1)));
    for i=1:4
        thisCaxis = caxis((hh(i)));
        CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
        CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
    end
    for i=1:4
        caxis(hh(i), CommonCaxis);
    end
end

for fb=1:3
    for t=1:4
        figure;
        for region=1:4
            hh(4*(t-1)+region)=subplot(2,4,region);
            imagesc((1:(500+1))/500-(500)/(2*500), 4:40, L{fb,t,region}'); set(gca,'YDir','normal'); set(gca,'FontSize',14); hold on; plot([0 0], ylim, ':', 'Color', 'w');
            xlim([-0.5 0.5])
            set(gca, 'xtick', [-0.5 0 0.5]);
            title(['fb',num2str(fb),' t',num2str(t),' reg',num2str(region)]);
        end
    end
    CommonCaxis = caxis((hh(1)));
    for i=1:16
        thisCaxis = caxis((hh(i)));
        CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
        CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
    end
    for i=1:16
        caxis(hh(i), CommonCaxis);
    end
end


for fb=1:3
    for t=1:4
        figure;
        for s=1:2
            for region=1:4
                hh(8*(t-1)+4*(s-1)+region)=subplot(2,4,4*(s-1)+region);
                imagesc((1:(500+1))/500-(500)/(2*500), 4:40, L{fb,t,s,region}'); set(gca,'YDir','normal'); set(gca,'FontSize',14); hold on; plot([0 0], ylim, ':', 'Color', 'w');
                xlim([-0.5 0.5])
                set(gca, 'xtick', [-0.5 0 0.5]);
                title(['fb',num2str(fb),' t',num2str(t),' reg',num2str(region)]);
            end
        end
    end
    CommonCaxis = caxis((hh(1)));
    for i=1:32
        thisCaxis = caxis((hh(i)));
        CommonCaxis(1) = 0;%min(CommonCaxis(1), thisCaxis(1));
        CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
    end
    for i=1:32
        caxis(hh(i), CommonCaxis);
    end
end

for fb=1:3    
    idx = find(idx_1Dcat==fb);
    Lbands{fb} = sum(cat(3,BlobData{idx,11}),3);
    Lbands{fb}(Lbands{fb}~=0)=1;
end

for fb=1:3
    for t=1:4
        for s=1:2
            for region=1:4
                Lstat{fb,t,s,region} = L{fb,t,s,region}(find(Lbands{fb}));
                Lstat_Gfb{fb,t,s,region} = fb*ones(size(Lstat{fb,t,s,region}));
                Lstat_Gtime{fb,t,s,region} = t*ones(size(Lstat{fb,t,s,region}));
                Lstat_Gside{fb,t,s,region} = s*ones(size(Lstat{fb,t,s,region}));
                Lstat_Greg{fb,t,s,region} = region*ones(size(Lstat{fb,t,s,region}));
            end
        end
    end
end

anovan(cat(1,Lstat{:}), {cat(1,Lstat_Gfb{:}), cat(1,Lstat_Gtime{:}), cat(1,Lstat_Gside{:}), cat(1,Lstat_Greg{:})})

boxplot(cat(1,Lstat{:}), {cat(1,Lstat_Gfb{:}), cat(1,Lstat_Gtime{:}), cat(1,Lstat_Gside{:}), cat(1,Lstat_Greg{:})})

fb=2; 

clear L;

for fb=1:3
    for t=1:4
        for s=1:2
            for region=1:4
                idx = intersect(intersect(intersect( ...
                    find([BlobData{:,5}]==t), ...
                    find(DKatlas_bilateral4==region)), ...
                    find(idx_1Dcat==fb)), ...
                    find([BlobData{:,4}]==s));
                
                if isempty(idx)
                    L{fb,t,s,region} = zeros(501,37);
                else
                    temp = cellfun(@(A) A.*Lbands{fb},BlobData(idx,12), 'uniformoutput', false);
                    L{fb,t,s,region} = mean(cat(3,temp{:}),3);
                end

            end
        end
    end
end


% for fb=1:3
%     for tblock=1:4
%         zplf(fb).group_timecourse(tblock).ipsi = 0;
%         zplf(fb).group_timecourse(tblock).contra = 0;
%     end
% end

for fb=1:3
    for t=1:4
        for s=1:2
            for region=1:4
                idx = intersect(intersect(intersect( ...
                    find([BlobData{:,5}]==t), ...
                    find(DKatlas_bilateral4==region)), ...
                    find(idx_1Dcat==fb)), ...
                    find([BlobData{:,4}]==s));
                
            
                    temp = cellfun(@(A) L{fb,region}.*A, BlobData(idx,12), 'uniformoutput', false);
                    if ~isempty(find(isnan([temp{:}])))
                        disp(idx)
                    end
                    zplf{fb,t,s,region} = mean(mean(cat(3,temp{:}),2));
                    if isnan(zplf{fb,t,s,region})
                        zplf{fb,t,s,region} =0;
                    end
            end
        end
    end
end


fb=1; region=3;
for tblock=1:4
    DATA{:,tblock,1} = squeeze(zplf{fb,tblock,1,region});
    time_group{:,tblock,1} = tblock*ones(size(DATA{:,tblock,1}));
    side_group{:,tblock,1} = 1*ones(size(DATA{:,tblock,1}));
    DATA{:,tblock,2} = squeeze(zplf{fb,tblock,2,region});
    time_group{:,tblock,2} = tblock*ones(size(DATA{:,tblock,2}));
    side_group{:,tblock,2} = 2*ones(size(DATA{:,tblock,2}));
end

anovan(cat(1,DATA{:})', {cat(1,time_group{:})', cat(1,side_group{:})'})

boxplot(cat(1,DATA{:})', {cat(1,time_group{:})', cat(1,side_group{:})'})