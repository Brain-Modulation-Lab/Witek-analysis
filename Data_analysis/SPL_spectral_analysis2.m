

window=256;
epoch_length = 1;
epoch_num=3;
fs=1000;

% TrialEpochs
% 1 - preFeedback
% 2 - preITI
% 3 - Cue
% 4 - Command
% 5 - ForceResponseStart
% 6 - ForceResponseEnd
% 7 - Feedback
% 8 - postITI

epochs1 = [3 5 6];
epochs2 = [4 6 8];

FB{1} = [25 40];
FB{2} = [12 24];
FB{3} = [50 200];

dat_files = dir('*.mat');

for i=1:length(dat_files)
        
    filename=dat_files(i).name;
    
    SS= load(filename, 'LFP', 'RecSide', 'RecID', 'SPLtrial4');
    
    fprintf('%s... ', SS.RecID);
    
    for contact =1:size(SS.LFP,2);
        
        % Left Responses
        for trial=1:length(SS.SPLtrial.Left)
            for ep=1:epoch_num
                t1 = SS.SPLtrial.Left(trial).epoch(epochs1(ep));
                t2 = SS.SPLtrial.Left(trial).epoch(epochs2(ep));
                if round(fs*(t2-t1)) < window
                    t2 = t1 + window/fs;
                    fprintf('\nWarning: epoch too short (%d)...\n', round(fs*(t2-t1)));
                end
                [lr_psd(:,ep,trial,contact), f] = pwelch(SS.LFP(round(fs*t1):round(fs*t2),contact), window, 0.5, [], fs);
            end
            
            %     baseline
            t1 = SS.SPLtrial.Left(trial).epoch(3)-1;
            t2 = SS.SPLtrial.Left(trial).epoch(3);
            [lbase_psd(:,trial,contact), f] = pwelch(SS.LFP(round(fs*t1):round(fs*t2),contact), window, 0.5, [], fs);
        end
        
        % Right Responses
        for trial=1:length(SS.SPLtrial.Right)
            for ep=1:epoch_num
                t1 = SS.SPLtrial.Right(trial).epoch(epochs1(ep));
                t2 = SS.SPLtrial.Right(trial).epoch(epochs2(ep));
                if round(fs*(t2-t1)) < window
                    t2 = t1 + window/fs;
                    fprintf('\nWarning: epoch too short (%d)...\n', round(fs*(t2-t1)));
                end
                [rr_psd(:,ep,trial,contact), f] = pwelch(SS.LFP(round(fs*t1):round(fs*t2),contact), window, 0.5, [], fs);
            end
            
            %     baseline
            t1 = SS.SPLtrial.Right(trial).epoch(3)-1;
            t2 = SS.SPLtrial.Right(trial).epoch(3);
            [rbase_psd(:,trial,contact), f] = pwelch(SS.LFP(round(fs*t1):round(fs*t2),contact), window, 0.5, [], fs);
        end
        
        for fb = 1:length(FB)
            for ep=1:epoch_num
                AWl{fb}(:,ep,contact) = KMtest(squeeze(lr_psd(findfreq(FB{fb}(1),FB{fb}(2),f),ep,:,contact)), squeeze(lbase_psd(findfreq(FB{fb}(1),FB{fb}(2),f),:,contact)))';
                AWr{fb}(:,ep,contact) = KMtest(squeeze(rr_psd(findfreq(FB{fb}(1),FB{fb}(2),f),ep,:,contact)), squeeze(rbase_psd(findfreq(FB{fb}(1),FB{fb}(2),f),:,contact)))';
            end
        end
        
    end
    
    RecID = SS.RecID;
    RecSide  = SS.RecSide;
    save(['group_analysis/',RecID, '_LFPresponse2'], ...
        'RecID', 'RecSide', 'f', 'lr_psd', 'rr_psd', 'lbase_psd', 'rbase_psd', 'AWl', 'AWr');
    
    clear('RecID', 'RecSide', 'f', 'lr_psd', 'rr_psd', 'lbase_psd', 'rbase_psd', 'AWl', 'AWr');
    
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

