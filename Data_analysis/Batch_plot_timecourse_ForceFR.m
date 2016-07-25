SPL_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPL6_B_clusters/';
Psych_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/SPLpsych/PsychometricData4.mat';
QC_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/';

output_path = '/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/SPL6_examples/';

load('/Users/Witek/Documents/Data/SPL_analysis/group_analysis/quality_control/SPL5_cleanup/SPL5_cleanup.mat', ...
    'ForceLLabel_good', 'ForceRLabel_good');

%load(Psych_path, 'Psychometrics');

dat_files = dir([SPL_path,'*.mat']);

for i=19:length(dat_files)
    filename=dat_files(i).name;
    
    RecID = strsplit(filename, '_SPL');
    RecID = RecID{1};
    
    fprintf('%s...\n', filename);
    load([SPL_path,filename]);
    
    clear timecourse
    for contact=1:size(R_LR,1)
        for t=1:size(R_LR,2)
            timecourse(contact).SPL_LR(t).corrz = R_LR{contact,t}.corrz;
            timecourse(contact).SPL_RR(t).corrz = R_RR{contact,t}.corrz;
        end
    end
    
    load([QC_path, RecID]);
    
    getQualityForceResponse
    close(h_QRR,h_QLR);
    
    CueTL = arrayfun(@(x) x.epoch(5)-x.epoch(3), SPLtrial.Left);
    CueTR = arrayfun(@(x) x.epoch(5)-x.epoch(3), SPLtrial.Right);
    FBTL = arrayfun(@(x) x.epoch(7)-x.epoch(5), SPLtrial.Left);
    FBTR = arrayfun(@(x) x.epoch(7)-x.epoch(5), SPLtrial.Right);    
    PITIL = arrayfun(@(x) x.epoch(8)-x.epoch(5), SPLtrial.Left);
    PITIR = arrayfun(@(x) x.epoch(8)-x.epoch(5), SPLtrial.Right);     
    idxpsych = find(strcmp(RecID, {Psychometrics(:).RecID}));
    RTL = [Psychometrics(idxpsych).Right(:).RT];
    RTR = [Psychometrics(idxpsych).Left(:).RT];
    
    Tpre = 2500;
    Tpost = 2500;
    Tbase = 2000;
    fs = 1000;
    
    clear F1 F2
    idx_Lclean = find([strcmp(RecID, ForceLLabel_good(:,1))]);
    F1(:,:,1) = cell2mat(arrayfun(@(x) Force((ForceLLabel_good{x,4}-Tpre):(ForceLLabel_good{x,4}+Tpost),1)', ...
        idx_Lclean, 'uniformoutput', false))';
    F1(:,:,1) = F1(:,:,1) - repmat(mean(F1(1:Tbase,:,1),1),size(F1(:,:,1),1),1,1);
    F1(:,:,2) = cell2mat(arrayfun(@(x) Force((ForceLLabel_good{x,4}-Tpre):(ForceLLabel_good{x,4}+Tpost),2)', ...
        idx_Lclean, 'uniformoutput', false))';
    F1(:,:,2) = F1(:,:,2) - repmat(mean(F1(1:Tbase,:,2),1),size(F1(:,:,2),1),1,1);
    
    idx_Rclean = find([strcmp(RecID, ForceRLabel_good(:,1))]);
    F2(:,:,1) = cell2mat(arrayfun(@(x) Force((ForceRLabel_good{x,4}-Tpre):(ForceRLabel_good{x,4}+Tpost),2)', ...
        idx_Rclean, 'uniformoutput', false))';
    F2(:,:,1) = F2(:,:,1) - repmat(mean(F2(1:Tbase,:,1),1),size(F2(:,:,1),1),1,1);
    F2(:,:,2) = cell2mat(arrayfun(@(x) Force((ForceRLabel_good{x,4}-Tpre):(ForceRLabel_good{x,4}+Tpost),1)', ...
        idx_Rclean, 'uniformoutput', false))';
    F2(:,:,2) = F2(:,:,2) - repmat(mean(F2(1:Tbase,:,2),1),size(F2(:,:,2),1),1,1);
    
    clear h
    if RecSide==1
        for contact=1:length(timecourse)
            psych.CueT1 = CueTL;
            psych.CueT2 = CueTR;
            psych.FBT1 = FBTL;
            psych.FBT2 = FBTR;
            psych.PITI1 = PITIL;
            psych.PITI2 = PITIR;
            psych.RT1 = RTL;
            psych.RT2 = RTR;
            h(contact) = plot_timecourse_ForceFR( timecourse(contact), 'SPL_LR', 'SPL_RR', 'corrz', t, ...
                Nbin_LR, Nbin_RR, Nbin_LR_thresh, Nbin_RR_thresh, F1, F2, psych, fs, 12:40, 500, 500);
            saveas(h(contact), [output_path, RecID,'_timecourse_c',num2str(contact),'.pdf'], 'pdf');
        end
    else
        for contact=1:length(timecourse)
            psych.CueT1 = CueTR;
            psych.CueT2 = CueTL;
            psych.FBT1 = FBTR;
            psych.FBT2 = FBTL;
            psych.PITI1 = PITIR;
            psych.PITI2 = PITIL;
            psych.RT1 = RTR;
            psych.RT2 = RTL;
            h(contact) = plot_timecourse_ForceFR( timecourse(contact), 'SPL_RR', 'SPL_LR', 'corrz', t, ...
                Nbin_RR, Nbin_LR, Nbin_RR_thresh, Nbin_LR_thresh, F2, F1, psych, fs, 12:40, 500, 500);
            saveas(h(contact), [output_path, RecID,'_timecourse_c',num2str(contact),'.pdf'], 'pdf');
        end
    end
    for contact=1:length(h)
        close(h(contact))
    end
end