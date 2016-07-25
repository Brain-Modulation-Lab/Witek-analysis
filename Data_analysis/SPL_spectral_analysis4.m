

window=256;
epoch_length = 1;
epoch_num=5;
fs=1000;


S = load('SPL4_cleanup/SPL4_cleanup.mat', 'Epoch');
Siti = load('ITI_cleanup/SPLall_ITIcleanup.mat', 'ForceLabel_good');

FB{1} = [25 40];
FB{2} = [12 24];
FB{3} = [50 200];

dat_files = dir('*.mat');

for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    SS= load(filename, 'LFP', 'RecSide', 'RecID');
    
    fprintf('%s... ', SS.RecID);
    
    for ep=1:epoch_num
        
        idx_Lclean = find([strcmp(SS.RecID, S.Epoch(ep).ForceLLabel_good(:,1))]);
        idx_Rclean = find([strcmp(SS.RecID, S.Epoch(ep).ForceRLabel_good(:,1))]);
        idx_ITIclean = find([strcmp(SS.RecID, Siti.ForceLabel_good(:,1))]);
        
        for contact =1:size(SS.LFP,2);
            
            % Left Responses
            for trial=1:length(idx_Lclean)
                
                t1 = S.Epoch(ep).ForceLLabel_good{idx_Lclean(trial),4};
                t2 = S.Epoch(ep).ForceLLabel_good{idx_Lclean(trial),4} + fs*epoch_length;
                if (t2-t1) < epoch_length
                    t2 = t1 + epoch_length;
                    fprintf('\nWarning: epoch too short (%d)...\n', round((t2-t1)));
                end
                [lr_psd(:,ep,trial,contact), f] = pwelch(SS.LFP(t1:t2,contact), window, 0.5, [], fs);
                
            end                

            % Right Responses
            for trial=1:length(idx_Rclean)
                
                t1 = S.Epoch(ep).ForceRLabel_good{idx_Rclean(trial),4};
                t2 = S.Epoch(ep).ForceRLabel_good{idx_Rclean(trial),4} + fs*epoch_length;
                if (t2-t1) < epoch_length
                    t2 = t1 + epoch_length;
                    fprintf('\nWarning: epoch too short (%d)...\n', round((t2-t1)));
                end
                [rr_psd(:,ep,trial,contact), f] = pwelch(SS.LFP(t1:t2,contact), window, 0.5, [], fs);
            end
            
            % ITI baseline
            for trial=1:length(idx_ITIclean)               
                t1 = Siti.ForceLabel_good{idx_ITIclean(trial),4};
                t2 = Siti.ForceLabel_good{idx_ITIclean(trial),4} + fs*epoch_length;
                [base_psd(:,trial,contact), f] = pwelch(SS.LFP(t1:t2,contact), window, 0.5, [], fs);
            end
            
            min_trialL = min([size(lr_psd,3), size(base_psd,2)]);
            min_trialR = min([size(rr_psd,3), size(base_psd,2)]);
            for fb = 1:length(FB)
                AWl{fb}(ep,contact) = mean(KMtest(squeeze(lr_psd(findfreq(FB{fb}(1),FB{fb}(2),f),ep,1:min_trialL,contact)), ...
                    squeeze(base_psd(findfreq(FB{fb}(1),FB{fb}(2),f),1:min_trialL,contact))));
                AWr{fb}(ep,contact) = mean(KMtest(squeeze(rr_psd(findfreq(FB{fb}(1),FB{fb}(2),f),ep,1:min_trialR,contact)), ...
                    squeeze(base_psd(findfreq(FB{fb}(1),FB{fb}(2),f),1:1:min_trialR,contact))));
            end
            
        end
    end
    
    RecID = SS.RecID;
    RecSide  = SS.RecSide;
    save(['group_analysis/',RecID, '_LFPresponse4'], ...
        'RecID', 'RecSide', 'f', 'lr_psd', 'rr_psd', 'base_psd', 'AWl', 'AWr');
    
    clear('RecID', 'RecSide', 'f', 'lr_psd', 'rr_psd', 'base_psd', 'AWl', 'AWr');
    
    fprintf('done.\n');
end
% figure;
% subplot(1,2,1);
% plot(f, squeeze(mean(lr_psd(:,1,:),3)), 'b'); xlim([0 150]); set(gca,'yscale','log')
% hold on; plot(f, squeeze(mean(lr_psd(:,2,:),3)), 'r');
% hold on; plot(f, mean(lbase_psd(:,2,:),3), 'g');
% subplot(1,2,2);
% plot(f, squeeze(mean(rr_psd(:,1,:),3)), 'b'); xlim([0 150]); set(gca,'yscale','log')
% hold on; plot(f, squeeze(mean(rr_psd(:,2,:),3)), 'r');
% hold on; plot(f, mean(rbase_psd(:,2,:),3), 'g');

