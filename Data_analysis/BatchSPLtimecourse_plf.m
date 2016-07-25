dat_files = dir('*.mat');

SPL5cleanup = load('SPL5_cleanup/SPL5_cleanup.mat', 'ForceLLabel_good', 'ForceRLabel_good');

for i=1:length(dat_files)
    tic
    Rec(i).Filename=dat_files(i).name;
    fq=4:40;
    nbin=30;
    dsr = 2; %downsampling rate
    S = load(Rec(i).Filename);
    S.phfs = S.fs/dsr;
    
    idx_Lclean = find([strcmp(S.RecID, SPL5cleanup.ForceLLabel_good(:,1))]);
    clear SPL5_Ltrial
    for trial=1:length(idx_Lclean)
        SPL5_Ltrial(trial) = SPL5cleanup.ForceLLabel_good{idx_Lclean(trial),4};
    end
    idx_Rclean = find([strcmp(S.RecID, SPL5cleanup.ForceRLabel_good(:,1))]);
    clear SPL5_Rtrial
    for trial=1:length(idx_Rclean)
        SPL5_Rtrial(trial) = SPL5cleanup.ForceRLabel_good{idx_Rclean(trial),4};
    end
    
    for contact = 1:size(S.LFP,2)
        tic
        
        %ph = angle(fast_wavtransform(fq, S.LFP(:,contact) - mean( S.LFP(:,contact)), S.fs, 7));
        ph = fast_wavtransform(fq, S.LFP(:,contact) - mean( S.LFP(:,contact)), S.fs, 7);
        ph = downsample(ph,dsr);
        ph = single(ph);
        
        fprintf('%s: contact %d\n', S.RecID, contact);
        timecourse(contact).SPL_LR = timecourse_evoked_plfSPL_TW(ph, S.qts, SPL5_Ltrial/dsr, S.phfs, fq, nbin, 100, 0.5, 0.5);
        timecourse(contact).SPL_RR = timecourse_evoked_plfSPL_TW(ph, S.qts, SPL5_Rtrial/dsr, S.phfs, fq, nbin, 100, 0.5, 0.5);        
%         timecourse(contact).SPL_LR = timecourse_evoked_plfSPL_TW(ph, S.qts, S.QLeftResponseTimes/dsr, S.phfs, fq, nbin, 100, 0.5, 0.5);
%         timecourse(contact).SPL_RR = timecourse_evoked_plfSPL_TW(ph, S.qts, S.QRightResponseTimes/dsr, S.phfs, fq, nbin, 100, 0.5, 0.5);
        toc
    end
    fprintf('%s processed successfully...\n', S.RecID);
    toc
    RecID = S.RecID;
    save(['SPL6/', S.RecID, '_SPLtimecourse'], 'fq', 'timecourse', 'RecID');
    clear('timecourse');
    
    
end