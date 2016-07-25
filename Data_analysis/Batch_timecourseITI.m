 AnatomyPath = '/Users/Witek/Documents/Data/Brainstorm_CortLoc/';
 TimecoursePath = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL_ITIclean_B_clusters/';

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

nframes = 1;
            

for r = 1:length(regions_cats)
    SPLregion(r).iti = [];
    SPLregion(r).itiCount = 0;
    
    SPLregion(r).itiRecInfo = {};
    
    SPLregion(r).lowBiti_blob = {};
    SPLregion(r).hiBiti_blob = {};
end


basefield = 'ITI';
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
            SU = load([TimecoursePath, S.unitsL{unit},'_ITI_plf2.mat']);
            fprintf('Recording (left) %s...\n',SU.RecID);
            
            %find what anatomical category each contact belongs to
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocL, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.(basefield))     
                if sum(isnan(SU.(basefield)(contact).SPL_ITI.(field)))>0
                    fprintf('WARNING: NaN datapoints found!\n');
                    fprintf('         contact %d\n', contact);
                end
                
                % plf
                SPLregion(reg_cats(contact)).iti = cat(3, ...
                    SPLregion(reg_cats(contact)).iti, ...
                    SU.(basefield)(contact).SPL_ITI.(field));
                SPLregion(reg_cats(contact)).itiCount = ...
                    SPLregion(reg_cats(contact)).itiCount + 1;
                % blobzplf
                blobstats = blob_stats_sub( SU.(basefield)(contact).SPL_ITI, blobfield, fq, t, [12 40], []);
                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                        blobstats.blob(iblob).RecID = SU.RecID;
                        blobstats.blob(iblob).contact = contact;
                        blobstats.blob(iblob).itiCount = SPLregion(reg_cats(contact)).itiCount;
                        if blobstats.blob(iblob).max_unit(1) >= lowB(1) && blobstats.blob(iblob).max_unit(1) < lowB(2)
                            SPLregion(reg_cats(contact)).lowBiti_blob = cat(2, ...
                                SPLregion(reg_cats(contact)).lowBiti_blob, ...
                                blobstats.blob(iblob));
                        elseif blobstats.blob(iblob).max_unit(1) >= hiB(1) && blobstats.blob(iblob).max_unit(1) <= hiB(2)
                            SPLregion(reg_cats(contact)).hiBiti_blob = cat(2, ...
                                SPLregion(reg_cats(contact)).hiBiti_blob, ...
                                blobstats.blob(iblob));
                        end
                        fprintf('ITI blob: Contact %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, blobstats.blob(iblob).max_unit(1), blobstats.blob(iblob).max_unit(2), blobstats.blob(iblob).TotalValue);
                    end
                end
                
                SPLregion(reg_cats(contact)).itiRecInfo( ...
                            SPLregion(reg_cats(contact)).itiCount,:) = ...
                            {SU.RecID contact};
            end
        end
    end
    
    if isfield(S, 'unitsR')
        
        % Recordings on the RIGHT side of the brain
        for unit=1:length(S.unitsR)
            SU = load([TimecoursePath, S.unitsR{unit},'_ITI_plf2.mat']);
            fprintf('Recording (right) %s...\n',SU.RecID);
            
            regs = cellfun(@(x) S.Anatomy.Atlas(3).Scouts(x).Label, S.Anatomy.Atlas(3).CortElecLocR, 'uniformoutput', false)';
            reg_cats = cellfun(which_regcat, regs);
            
            for contact=1:length(SU.(basefield))
                    
                if sum(isnan(SU.(basefield)(contact).SPL_ITI.(field)))>0
                    fprintf('WARNING: NaN datapoints found!\n');
                    fprintf('         contact %d\n', contact);
                end
                
                % plf
                SPLregion(reg_cats(contact)).iti = cat(3, ...
                    SPLregion(reg_cats(contact)).iti, ...
                    SU.(basefield)(contact).SPL_ITI.(field));
                SPLregion(reg_cats(contact)).itiCount = ...
                    SPLregion(reg_cats(contact)).itiCount + 1;
                % blobzplf
                blobstats = blob_stats_sub( SU.(basefield)(contact).SPL_ITI, blobfield, fq, t, [12 40], []);
                for iblob=1:length(blobstats.blob)
                    if ~isempty(iblob) && blobstats.blob(iblob).MeanValue ~= 0
                        blobstats.blob(iblob).RecID = SU.RecID;
                        blobstats.blob(iblob).contact = contact;
                        blobstats.blob(iblob).itiCount = SPLregion(reg_cats(contact)).itiCount;                        
                        if blobstats.blob(iblob).max_unit(1) >= lowB(1) && blobstats.blob(iblob).max_unit(1) < lowB(2)
                            SPLregion(reg_cats(contact)).lowBiti_blob = cat(2, ...
                                SPLregion(reg_cats(contact)).lowBiti_blob, ...
                                blobstats.blob(iblob));
                        elseif blobstats.blob(iblob).max_unit(1) >= hiB(1) && blobstats.blob(iblob).max_unit(1) <= hiB(2)
                            SPLregion(reg_cats(contact)).hiBiti_blob = cat(2, ...
                                SPLregion(reg_cats(contact)).hiBiti_blob, ...
                                blobstats.blob(iblob));
                        end
                        fprintf('ITI blob: Contact %d: f = %4.2f, t = %4.2f, value = %4.2f\n', contact, blobstats.blob(iblob).max_unit(1), blobstats.blob(iblob).max_unit(2), blobstats.blob(iblob).TotalValue);
                    end
                end
                
                SPLregion(reg_cats(contact)).itiRecInfo( ...
                    SPLregion(reg_cats(contact)).itiCount,:) = ...
                    {SU.RecID contact};
                
            end
        end
    end
end

for region=1:4
    % lowB
    SPLregion(region).RecInfo_lowBiti.RecID = unique(cellfun(@(x) x.RecID, SPLregion(region).lowBiti_blob, 'uniformoutput', false));
    
    for rec=1:length(SPLregion(region).RecInfo_lowBiti.RecID)
        idx = find(strcmp(SPLregion(region).RecInfo_lowBiti.RecID{rec}, ...
            cellfun(@(x) x.RecID, SPLregion(region).lowBiti_blob, 'uniformoutput', false)));
        [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).lowBiti_blob(idx)));
        SPLregion(region).lowBiti_blob_Max{rec} = SPLregion(region).lowBiti_blob{idx(idxMax)};
    end
    
    % hiB
    SPLregion(region).RecInfo_hiBiti.RecID = unique(cellfun(@(x) x.RecID, SPLregion(region).hiBiti_blob, 'uniformoutput', false));
    
    for rec=1:length(SPLregion(region).RecInfo_hiBiti.RecID)  
        idx = find(strcmp(SPLregion(region).RecInfo_hiBiti.RecID{rec}, ...
            cellfun(@(x) x.RecID, SPLregion(region).hiBiti_blob, 'uniformoutput', false)));
        [~,idxMax] = max(cellfun(@(x) x.QMaxValue, SPLregion(region).hiBiti_blob(idx)));
        SPLregion(region).hiBiti_blob_Max{rec} = SPLregion(region).hiBiti_blob{idx(idxMax)};  
    end
    
end

for r=1:4
    thisidx = cellfun(@(x) x.itiCount, SPLregion(r).lowBiti_blob_Max);
    plot_temp.reg_low(r).iti = [];
    for i=1:length(thisidx)
        plot_temp.reg_low(r).iti = cat(3, plot_temp.reg_low(r).iti, ...
            SPLregion(r).lowBiti_blob_Max{i}.L.*squeeze(SPLregion(r).iti(:,:,thisidx(i))));
    end
    thisidx = cellfun(@(x) x.itiCount, SPLregion(r).hiBiti_blob_Max);
    plot_temp.reg_hi(r).iti = [];
    for i=1:length(thisidx)
        plot_temp.reg_hi(r).iti = cat(3, plot_temp.reg_hi(r).iti, ...
            SPLregion(r).hiBiti_blob_Max{i}.L.*squeeze(SPLregion(r).iti(:,:,thisidx(i))));
    end
end

plot_group_timecourse5( plot_temp.reg_low, 'iti', 'iti', 500, 12:40, 500, 500)
plot_group_timecourse5( plot_temp.reg_hi, 'iti', 'iti', 500, 12:40, 500, 500)