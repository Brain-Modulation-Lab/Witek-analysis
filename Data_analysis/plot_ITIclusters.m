region=2;
% lowB
SPLregion(region).RecInfo_lowBiti.RecID = unique(cellfun(@(x) x.RecID, SPLregion(region).lowBiti_blob, 'uniformoutput', false));

for rec=1:length(SPLregion(region).RecInfo_lowBiti.RecID)
    
    idx = find(strcmp(SPLregion(region).RecInfo_lowBiti.RecID{rec}, ...
        cellfun(@(x) x.RecID, SPLregion(region).lowBiti_blob, 'uniformoutput', false)));
        
    
    [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).lowBiti_blob(idx)));
    
    SPLregion(region).lowBiti_blob_Max{rec} = SPLregion(region).lowBiti_blob{idx(idxMax)};
    
    figure;
    clear h
    for contact=1:length(idx)
        color = 'k';
        if contact == idxMax
            color = 'r';
        end
        h(contact) = subplot(1,length(idx),contact);
        imagesc(t, 12:40, (SPLregion(region).lowBiti_blob{idx(contact)}.L.* ...
            SPLregion(region).iti(:,:,SPLregion(region).lowBiti_blob{idx(contact)}.itiCount))'); 
        hold on; 
        plot(SPLregion(region).lowBiti_blob{idx(contact)}.max_unit(2), SPLregion(region).lowBiti_blob{idx(contact)}.max_unit(1), 'r.', 'MarkerSize', 24)
        plot(t(SPLregion(region).lowBiti_blob{idx(contact)}.idxQMax(1,:)), fq(SPLregion(region).lowBiti_blob{idx(contact)}.idxQMax(2,:)), 'k.', 'MarkerSize', 6)
        set(gca,'YDir','normal');
        title([SPLregion(region).RecInfo_lowBiti.RecID{rec}, ' contact ' num2str(SPLregion(region).lowBiti_blob{idx(contact)}.contact)], ...
            'color', color);
    end
    CommonCaxis = caxis((h(1)));
    for i=1:length(h)
        thisCaxis = caxis((h(i)));
        CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
        CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
    end
    for i=1:length(h)
        caxis(h(i), CommonCaxis);
        %caxis(hh(i), [-max(abs(CommonCaxis)), max(abs(CommonCaxis))]);
    end
end

% hiB
SPLregion(region).RecInfo_hiBiti.RecID = unique(cellfun(@(x) x.RecID, SPLregion(region).hiBiti_blob, 'uniformoutput', false));

for rec=1:length(SPLregion(region).RecInfo_hiBiti.RecID)
    
    idx = find(strcmp(SPLregion(region).RecInfo_hiBiti.RecID{rec}, ...
        cellfun(@(x) x.RecID, SPLregion(region).hiBiti_blob, 'uniformoutput', false)));
        
    [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).hiBiti_blob(idx)));
    
    SPLregion(region).hiBiti_blob_Max{rec} = SPLregion(region).hiBiti_blob{idx(idxMax)};
    
    figure;
    clear h
    for contact=1:length(idx)
        color = 'k';
        if contact == idxMax
            color = 'r';
        end
        h(contact) = subplot(1,length(idx),contact);
        imagesc(t, 12:40, (SPLregion(region).hiBiti_blob{idx(contact)}.L.* ...
            SPLregion(region).iti(:,:,SPLregion(region).hiBiti_blob{idx(contact)}.itiCount))'); 
        hold on; 
        plot(SPLregion(region).hiBiti_blob{idx(contact)}.max_unit(2), SPLregion(region).hiBiti_blob{idx(contact)}.max_unit(1), 'r.', 'MarkerSize', 24)
        plot(t(SPLregion(region).hiBiti_blob{idx(contact)}.idxQMax(1,:)), fq(SPLregion(region).hiBiti_blob{idx(contact)}.idxQMax(2,:)), 'k.', 'MarkerSize', 6)
        set(gca,'YDir','normal');
        title([SPLregion(region).RecInfo_hiBiti.RecID{rec}, ' contact ' num2str(SPLregion(region).hiBiti_blob{idx(contact)}.contact)], ...
            'color', color);
    end
    CommonCaxis = caxis((h(1)));
    for i=1:length(h)
        thisCaxis = caxis((h(i)));
        CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
        CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
    end
    for i=1:length(h)
        caxis(h(i), CommonCaxis);
        %caxis(hh(i), [-max(abs(CommonCaxis)), max(abs(CommonCaxis))]);
    end
end