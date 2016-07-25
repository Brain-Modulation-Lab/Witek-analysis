LFP_dat_files = dir('*LFPresponse2.mat');

AWipsi = {{[] [] []} {[] [] []} {[] [] []} {[] [] []}};
AWcontra = {{[] [] []} {[] [] []} {[] [] []} {[] [] []}};

for i=1:length(LFP_dat_files)
    filename=LFP_dat_files(i).name;
    fprintf('%s... \n', filename);
    S = load(filename);
    
    thisAWipsi = {{[] [] []} {[] [] []} {[] [] []} {[] [] []}};
    thisAWcontra = {{[] [] []} {[] [] []} {[] [] []} {[] [] []}};

    for contact=1:size(S.AWl{1},3)
        
        atlas_index = [];
        atlas_index = [];
        if ~strcmp(S.RecID, 'RS3')
            anatomy_filename = anatomy_files(find(cellfun(@(s) ~isempty(strfind(s, S.RecID(1:2))), {anatomy_files(:).name}))).name;
            A = load([anatomy_path,anatomy_filename],'Anatomy');
            if S.RecSide==1
                atlas_index = A.Anatomy.Atlas(atlas).CortElecLocL{contact};
            else
                atlas_index = A.Anatomy.Atlas(atlas).CortElecLocR{contact}; 
            end
            reg_idx = find(cellfun(@(x) ~isempty(find(x==atlas_index)), regions_index));

            if ~isempty(reg_idx)
                
                fprintf('%d \n', reg_idx);
                
                if S.RecSide==1
                    for fb=1:length(S.AWl)
                        thisAWipsi{reg_idx}{fb} = cat(1, thisAWipsi{reg_idx}{fb}, squeeze(mean(S.AWl{fb}(:,:,contact),1)));
                        thisAWcontra{reg_idx}{fb} = cat(1, thisAWcontra{reg_idx}{fb}, squeeze(mean(S.AWr{fb}(:,:,contact),1)));
                    end
                else
                    for fb=1:length(S.AWl)
                        thisAWipsi{reg_idx}{fb} = cat(1, thisAWipsi{reg_idx}{fb}, squeeze(mean(S.AWr{fb}(:,:,contact),1)));
                        thisAWcontra{reg_idx}{fb} = cat(1, thisAWcontra{reg_idx}{fb}, squeeze(mean(S.AWl{fb}(:,:,contact),1)));
                    end
                end
            end
        end
    end
    
    for r=1:4
        for fb=1:length(S.AWl)
            if ~isempty(thisAWipsi{r}{fb})
                AWipsi{r}{fb} = cat(1, AWipsi{r}{fb}, squeeze(mean(thisAWipsi{r}{fb},1)));
            end
            if ~isempty(thisAWcontra{r}{fb})
                AWcontra{r}{fb} = cat(1, AWcontra{r}{fb}, squeeze(mean(thisAWcontra{r}{fb},1)));
            end
        end
    end
end

% for r=1:4
%     fprintf('============================================================\n');
%     fprintf('Region %d\n', r);
%     fprintf('  LFAW\n');
%     fprintf('  ipsi pre    = %6.4f +/- %6.4f\n', mean(LFAWipsi{r}(:,1)), std(LFAWipsi{r}(:,1))/sqrt(numel(LFAWipsi{r}(:,1))));
%     fprintf('  ipsi post   = %6.4f +/- %6.4f\n', mean(LFAWipsi{r}(:,2)), std(LFAWipsi{r}(:,2))/sqrt(numel(LFAWipsi{r}(:,2))));
%     x = LFAWipsi{r}(:,1);
%     y = LFAWipsi{r}(:,2);
%     [h,p,ci,stats] = ttest(x, y)
%     fprintf('  contra pre  = %6.4f +/- %6.4f\n', mean(LFAWcontra{r}(:,1)), std(LFAWcontra{r}(:,1))/sqrt(numel(LFAWcontra{r}(:,2))));
%     fprintf('  contra post = %6.4f +/- %6.4f\n', mean(LFAWcontra{r}(:,2)), std(LFAWcontra{r}(:,2))/sqrt(numel(LFAWcontra{r}(:,2))));
%     x = LFAWcontra{r}(:,1);
%     y = LFAWcontra{r}(:,2);
%     [h,p,ci,stats] = ttest(x, y)
%     
%     fprintf('  HFAW\n');
%     fprintf('  ipsi pre    = %6.4f +/- %6.4f\n', mean(HFAWipsi{r}(:,1)), std(HFAWipsi{r}(:,1))/sqrt(numel(HFAWipsi{r}(:,1))));
%     fprintf('  ipsi post   = %6.4f +/- %6.4f\n', mean(HFAWipsi{r}(:,2)), std(HFAWipsi{r}(:,2))/sqrt(numel(HFAWipsi{r}(:,2))));
%     x = HFAWipsi{r}(:,1);
%     y = HFAWipsi{r}(:,2);
%     [h,p,ci,stats] = ttest(x, y)
%     fprintf('  contra pre  = %6.4f +/- %6.4f\n', mean(HFAWcontra{r}(:,1)), std(HFAWcontra{r}(:,1))/sqrt(numel(HFAWcontra{r}(:,2))));
%     fprintf('  contra post = %6.4f +/- %6.4f\n\n', mean(HFAWcontra{r}(:,2)), std(HFAWcontra{r}(:,2))/sqrt(numel(HFAWcontra{r}(:,2))));
%     x = HFAWcontra{r}(:,1);
%     y = HFAWcontra{r}(:,2);
%     [h,p,ci,stats] = ttest(x, y)
% end

r=3;
fb = 3;
AWDATA = [];
SideGroup = [];
EpochGroup = [];

for i=1:length(AWipsi{r}{fb})
AWDATA = cat(1, AWDATA, AWipsi{r}{fb}(i,:)');
SideGroup = cat(1, SideGroup, ones(size(AWipsi{r}{fb}(i,:)')));
EpochGroup = cat(1, EpochGroup, [1;2;3]);
end
for i=1:length(AWcontra{r}{fb})
AWDATA = cat(1, AWDATA, AWcontra{r}{fb}(i,:)');
SideGroup = cat(1, SideGroup, 2*ones(size(AWipsi{r}{fb}(i,:)')));
EpochGroup = cat(1, EpochGroup, [1;2;3]);
end
anovan(AWDATA, {SideGroup, EpochGroup}, 'model', 'interaction')

DATA=[];
for r=1:4
    for fb=1:3
        AWDATA = [];
        SideGroup = [];
        EpochGroup = [];
        for i=1:length(AWipsi{r}{fb})
            AWDATA = cat(1, AWDATA, AWipsi{r}{fb}(i,:)');
            SideGroup = cat(1, SideGroup, ones(size(AWipsi{r}{fb}(i,:)')));
            EpochGroup = cat(1, EpochGroup, [1;2;3]);
        end
        for i=1:length(AWcontra{r}{fb})
            AWDATA = cat(1, AWDATA, AWcontra{r}{fb}(i,:)');
            SideGroup = cat(1, SideGroup, 2*ones(size(AWipsi{r}{fb}(i,:)')));
            EpochGroup = cat(1, EpochGroup, [1;2;3]);
        end
        DATA = cat(1, DATA, [AWDATA SideGroup EpochGroup r*ones(size(AWDATA)) fb*ones(size(AWDATA))]);
        [p,tbl,stats] = anovan(AWDATA, {SideGroup, EpochGroup}, 'model', 'interaction')
        figure; multcompare(stats,'Dimension',[1 2]); title(['LFPspect r', num2str(r),' fb', num2str(fb)])
        %saveas(gcf, ['LFPspect_stats/LFPspect_r', num2str(r),'_fb', num2str(fb)], 'pdf');
    end
end