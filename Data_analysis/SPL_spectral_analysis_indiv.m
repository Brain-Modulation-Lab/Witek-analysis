function [LeftPower, RightPower, LeftPowerBase, RightPowerBase] = SPL_spectral_analysis_indiv(filename)

window=256;
epoch_length = 0.5;
epoch_num=2;
fs=1000;

HFB = [50 200];
LFB = [12 40];

fq = 4:4:200;

dat_files = dir('*.mat');

% HILBERT OPTION
% fqres = fq(2)-fq(1);
% fq_filt = ([fq(1)-fqres, fq] + [fq, fq(end)+fqres])./2;
% ph=angle(Hilbert_Time_Freq(LFP, fs, fq_filt, 0));
% ph=single(ph);

SS= load(filename, 'LFP', 'RecID', 'RecSide', 'QLeftResponseTimes', 'QRightResponseTimes', 'EventTimes');

LFAWl = zeros(length(SS.QLeftResponseTimes), epoch_num, size(SS.LFP,2));
HFAWl = zeros(length(SS.QLeftResponseTimes), epoch_num, size(SS.LFP,2));
LFAWr = zeros(length(SS.QRightResponseTimes), epoch_num, size(SS.LFP,2));
HFAWr = zeros(length(SS.QRightResponseTimes), epoch_num, size(SS.LFP,2));
lr_psd = zeros((floor(window/2))+1, epoch_num, length(SS.QLeftResponseTimes), size(SS.LFP,2));
lbase_psd = zeros((floor(window/2))+1, length(SS.QLeftResponseTimes), size(SS.LFP,2));
rr_psd = zeros((floor(window/2))+1, epoch_num, length(SS.QRightResponseTimes), size(SS.LFP,2));
rbase_psd = zeros((floor(window/2))+1, length(SS.QRightResponseTimes), size(SS.LFP,2));

for contact =1:size(SS.LFP,2);
    
    % Left Responses
    for trial=1:length(SS.QLeftResponseTimes)
        for epoch=1:epoch_num
            t0 = SS.QLeftResponseTimes(trial) + fs*(epoch-2)*epoch_length;
            t1 = SS.QLeftResponseTimes(trial) + fs*(epoch-1)*epoch_length;
            [lr_psd(:,epoch,trial,contact), f] = pwelch(SS.LFP(t0:t1,contact), window, 0.5, [], fs);
        end

        %     baseline
        tCue = SS.EventTimes(find(SS.EventTimes < SS.QLeftResponseTimes(trial)/fs,1,'last') - 1);
        t0 = round(fs*(tCue - epoch_length));
        t1 = round(fs*tCue);
        [lbase_psd(:,trial,contact), f] = pwelch(SS.LFP(t0:t1,contact), window, 0.5, [], fs);

%         thisLFP = SS.LFP((SS.QLeftResponseTimes(trial)-fs*epoch_length):(SS.QLeftResponseTimes(trial)+fs*epoch_length),contact);
%         thisLFPbase = SS.LFP(round(fs*(tCue - 2*epoch_length)):t1,contact);
%         % WAVELET OPTION
%         LeftPower(:,:,trial,contact) = abs(fast_wavtransform(fq, thisLFP, fs, 7));
%         LeftPowerBase(:,:,trial,contact) = abs(fast_wavtransform(fq, thisLFPbase, fs, 7));
    end
    
    for epoch=1:epoch_num
        LFAWl(:,epoch,contact) = KMtest(squeeze(lr_psd(findfreq(LFB(1),LFB(2),f),epoch,:,contact)), squeeze(lbase_psd(findfreq(LFB(1),LFB(2),f),:,contact)))';
        HFAWl(:,epoch,contact) = KMtest(squeeze(lr_psd(findfreq(HFB(1),HFB(2),f),epoch,:,contact)), squeeze(lbase_psd(findfreq(HFB(1),HFB(2),f),:,contact)))';
    end
    
    % Right Responses
    for trial=1:length(SS.QRightResponseTimes)
        for epoch=1:epoch_num
            t0 = SS.QRightResponseTimes(trial) + fs*(epoch-2)*epoch_length;
            t1 = SS.QRightResponseTimes(trial) + fs*(epoch-1)*epoch_length;
            [rr_psd(:,epoch,trial,contact), f] = pwelch(SS.LFP(t0:t1,contact), window, 0.5, [], fs);
        end
        %     baseline
        tCue = SS.EventTimes(find(SS.EventTimes < SS.QRightResponseTimes(trial)/fs,1,'last') - 1);
        t0 = round(fs*(tCue - epoch_length));
        t1 = round(fs*tCue);
        [rbase_psd(:,trial,contact), f] = pwelch(SS.LFP(t0:t1,contact), window, 0.5, [], fs);
        
%         thisLFP = SS.LFP((SS.QRightResponseTimes(trial)-fs*epoch_length):(SS.QRightResponseTimes(trial)+fs*epoch_length),contact);
%         thisLFPbase = SS.LFP(round(fs*(tCue - 2*epoch_length)):t1,contact);
%         % WAVELET OPTION
%         RightPower(:,:,trial,contact) = abs(fast_wavtransform(fq, thisLFP, fs, 7));
%         RightPowerBase(:,:,trial,contact) = abs(fast_wavtransform(fq, thisLFPbase, fs, 7));
    end
    
    for epoch=1:epoch_num
        LFAWr(:,epoch,contact) = KMtest(squeeze(rr_psd(findfreq(LFB(1),LFB(2),f),epoch,:,contact)), squeeze(rbase_psd(findfreq(LFB(1),LFB(2),f),:,contact)))';
        HFAWr(:,epoch,contact) = KMtest(squeeze(rr_psd(findfreq(HFB(1),HFB(2),f),epoch,:,contact)), squeeze(rbase_psd(findfreq(HFB(1),HFB(2),f),:,contact)))';
    end
    
end

RecID = SS.RecID;
RecSide  = SS.RecSide;
save(['group_analysis/',RecID, '_LFPresponse'], ...
    'RecID', 'RecSide', 'f', 'lr_psd', 'rr_psd', 'lbase_psd', 'rbase_psd', ...
    'LFAWl', 'HFAWl', 'LFAWr', 'HFAWr');

fprintf('done.\n');

figure;
subplot(1,2,1);
plot(f, squeeze(mean(lr_psd(:,1,:),3)), 'b'); xlim([0 150]); set(gca,'yscale','log')
hold on; plot(f, squeeze(mean(lr_psd(:,2,:),3)), 'r');
hold on; plot(f, mean(lbase_psd(:,2,:),3), 'g');
subplot(1,2,2);
plot(f, squeeze(mean(rr_psd(:,1,:),3)), 'b'); xlim([0 150]); set(gca,'yscale','log')
hold on; plot(f, squeeze(mean(rr_psd(:,2,:),3)), 'r');
hold on; plot(f, mean(rbase_psd(:,2,:),3), 'g');

