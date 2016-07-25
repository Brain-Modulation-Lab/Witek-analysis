
%% Mark Response Times
%=======================================
TrialNum = 120;

EventTimes1 = [EventTimes EventTimes(end)+2];

figure;
for trial=1:TrialNum
    StimulusEvent1 = SkipEvents + 4*trial;
    StimulusEvent2 = SkipEvents + 4*trial + 1;
    
    AudioTrials{trial} = Audio(round(30000*EventTimes1(StimulusEvent1)): ...
        round(30000*EventTimes1(StimulusEvent2)));
    
    AudioTrials{trial} = 2*(AudioTrials{trial} - mean(AudioTrials{trial}))/ ...
        (max(AudioTrials{trial}) - min(AudioTrials{trial}));
    
    thisAudioenv = AudioEnv(round(30000*EventTimes1(StimulusEvent1)): ...
        round(30000*EventTimes1(StimulusEvent2)));
    
    hold off
    plot(AudioTrials{trial})
    hold on; plot(thisAudioenv/100)
    AudioStart{trial} = 1;
    button=1;
    while button == 1
        player = audioplayer(AudioTrials{trial}(AudioStart{trial}:end), 30000); play(player);
        [x,~,button] = ginput(1);
        if button == 1
            AudioStart{trial} = round(x);
            hold on; plot(AudioStart{trial}*[1 1], ylim, 'g')
        elseif button == 32
            AudioStart{trial} = [];
            hold on; text(30000,100,'NO RESPONSE');
        end
    end
end

k=0;
for trial=1:TrialNum
    StimulusEvent1 = 2 + 4*trial;
    if ~isempty(AudioStart{trial})
        k=k+1;
        ResponseTimes(k) = EventTimes1(StimulusEvent1) + AudioStart{trial}/30000;
    end
end

clear AudioEnvTrials;
for trial=1:length(ResponseTimes)
    AudioEnvTrials(:,trial) = AudioEnv((round(30000*ResponseTimes(trial))-30000*2.5):(round(30000*ResponseTimes(trial))+30000*2.5));
end

%% Get LFP responses
%=======================================

for i = 1:length(ResponseTimes)
    LFPTrials(:,:,i) = LFP((round(1000*ResponseTimes(i))-1000*2.5):(round(1000*ResponseTimes(i))+1000*2.5),:);
end

for i = 1:length(ResponseTimes)
    VLFPTrials(:,:,i) = VLFP((round(1000*ResponseTimes(i))-1000*2.5):(round(1000*ResponseTimes(i))+1000*2.5),:);
end
for i = 1:length(ResponseTimes)
    MLFPTrials(:,:,i) = MLFP((round(1000*ResponseTimes(i))-1000*2.5):(round(1000*ResponseTimes(i))+1000*2.5),:);
end

% SPECTRA
nch = 28;

PowerLFP = abs(fast_wavtransform(fq, LFP, 1000, 7));
PowerVLFP = abs(fast_wavtransform(fq, VLFP, 1000, 7));
PowerMLFP = abs(fast_wavtransform(fq, MLFP, 1000, 7));

for trial=1:TrialNum
    PowerTrials(:,:,:,trial) = abs(fast_wavtransform(fq, squeeze(LFPTrials(:,:,trial)), 1000, 7));
end

nch = 3;
for trial=1:TrialNum
    VPowerTrials(:,:,:,trial) = abs(fast_wavtransform(fq, squeeze(VLFPTrials(:,:,trial)), 1000, 7));
end
for trial=1:TrialNum
    MPowerTrials(:,:,:,trial) = abs(fast_wavtransform(fq, squeeze(MLFPTrials(:,:,trial)), 1000, 7));
end

% Simple z-score method
MeanPowerTrials = mean(PowerTrials,4);
for f = 1:length(fq)
    for ch=1:nch
        MeanPowerTrialsNorm(:,f,ch) = (MeanPowerTrials(:,f,ch)-mean(MeanPowerTrials(1:2500,f,ch)))/std(MeanPowerTrials(1:2500,f,ch));
    end
end

MeanMPowerTrials = mean(MPowerTrials,4);
for f = 1:length(fq)
    for ch=1:nch
        MeanMPowerTrialsNorm(:,f,ch) = (MeanMPowerTrials(:,f,ch)-mean(MeanMPowerTrials(1:2500,f,ch)))/std(MeanMPowerTrials(1:2500,f,ch));
    end
end
MeanVPowerTrials = mean(VPowerTrials,4);
for f = 1:length(fq)
    for ch=1:nch
        MeanVPowerTrialsNorm(:,f,ch) = (MeanVPowerTrials(:,f,ch)-mean(MeanVPowerTrials(1:2500,f,ch)))/std(MeanVPowerTrials(1:2500,f,ch));
    end
end

h=figure;
for ch=1:nch
    %hh(ch)=subplot(1,nch,ch);
    sprow = floor(2*(ch-1)/(nch))+1;
    spcol = ch - (sprow-1)*nch/2;
    hh(ch)=subplot('Position',[0.005+2*(spcol-1)/nch (2-sprow)/2 (2/nch-0.01) (1/2-0.01)]);
    imagesc((1:(4001))/1000-2.001, fq, MeanPowerTrialsTstat5(500:4500,:,ch)'); set(gca,'YDir','normal'); set(gca,'FontSize',6); hold on; plot([0 0], ylim, ':', 'Color', 'w');
end
CommonCaxis = caxis((hh(1)));
for i=1:nch
    thisCaxis = caxis((hh(i)));
    CommonCaxis(1) = min(CommonCaxis(1), thisCaxis(1));
    CommonCaxis(2) = max(CommonCaxis(2), thisCaxis(2));
end
for i=1:nch
    caxis(hh(i), CommonCaxis);
end

cm= colormap;

for i=find(linspace(CommonCaxis(1), CommonCaxis(2), 64)>tinv(0.05/5001, 179),1,'first'):...
        find(linspace(CommonCaxis(1), CommonCaxis(2), 64)<tinv(1-0.05/5001, 179),1,'last')
    cm(i,:) = [0;0;0];
end

colormap(cm)

% % pre-task baseline method
% LFP_base = LFP(30*1000:60*1000,:);
% 
% PowerBase(:,:,:) = abs(fast_wavtransform(fq, LFP_base, 1000, 7)); 
% for f = 1:length(fq)
%     for ch=1:nch
%         MeanPowerTrialsNorm(:,f,ch) = (MeanPowerTrials(:,f,ch)-mean(PowerBase(:,f,ch)))/std(PowerBase(:,f,ch));
%     end
% end
% 
% %tstat
% trial_length = size(PowerTrials,1);
% for ch = 1:nch
%     rand_base(:,ch) = randi([1 length(PowerBase)], [1 TrialNum]);
% end
% nf = length(fq);
% MeanPowerTrialsTstat = single(zeros(trial_length, nf, nch));
% MeanPowerTrialsP = single(zeros(trial_length, nf, nch));
% stats = zeros(1,nf);
% 
% stats = struct('tstat',num2cell(zeros(1,trial_length)), ...
%     'df',num2cell(zeros(1,trial_length)), ...
%     'sd',num2cell(zeros(1,trial_length)));
% 
% % pre-task baseline method
% parfor t = 1:trial_length
%     for f = 1:nf
%         for ch = 1:nch
%             [~,MeanPowerTrialsP(t,f,ch),~,stats(t)] = ttest2(squeeze(PowerTrials(t,f,ch,:))', squeeze(PowerBase(rand_base(:,ch),f,ch))');
%             MeanPowerTrialsTstat(t,f,ch) = stats(t).tstat;
%         end
%     end
% end

%% ITI method
%=======================================
trial_length = size(PowerTrials,1);
nf = length(fq);

for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    ITIbase(:,:,trial) = squeeze(PowerLFP(round(1000*EventTimes(baseEvent)),:,:));
end

MeanPowerTrialsTstat = single(zeros(nf, nch,trial_length));
x1 = ITIbase;
parfor t = 1:trial_length
    x2 = squeeze(PowerTrials(t,:,:,:));
    MeanPowerTrialsTstat(:,:,t) = (mean(x2,3) - mean(x1,3))./sqrt(std(x1,0,3).^2/size(x1,3) + std(x2,0,3).^2/size(x2,3));
end
MeanPowerTrialsTstat = permute(MeanPowerTrialsTstat,[3,1,2]);


nch=3;

for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    ITIbaseM(:,:,trial) = squeeze(PowerMLFP(round(1000*EventTimes(baseEvent)),:,:));
end
MeanPowerMTrialsTstat = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(ITIbaseM(f,ch,:));
            x2 = squeeze(MPowerTrials(t,f,ch,:));
            MeanPowerMTrialsTstat(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

for trial=1:TrialNum
    baseEvent = SkipEvents + 4*trial -2;
    ITIbaseV(:,:,trial) = squeeze(PowerVLFP(round(1000*EventTimes(baseEvent)),:,:));
end
MeanPowerVTrialsTstat = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(ITIbaseV(f,ch,:));
            x2 = squeeze(VPowerTrials(t,f,ch,:));
            MeanPowerVTrialsTstat(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

%% Get LFP responses for subests of trials
%=======================================

nch = 28;

TrialGroup1 = find(cell2mat(cellfun(@(x) min(x==5), L(:,4), 'uniformoutput', false)));
TrialGroup2 = find(cell2mat(cellfun(@(x) min(x==1)||min(x==3), L(:,4), 'uniformoutput', false)));

MeanPowerTrialsTstat13 = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(ITIbase(f,ch,TrialGroup2));
            x2 = squeeze(PowerTrials(t,f,ch,TrialGroup2));
            MeanPowerTrialsTstat13(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

DiffPowerTrialsTstat = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(PowerTrials(t,f,ch,TrialGroup1));
            x2 = squeeze(PowerTrials(t,f,ch,TrialGroup2));
            DiffPowerTrialsTstat(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

nch=3;

PowerVTrialsTstat5 = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(ITIbaseV(f,ch,TrialGroup1));
            x2 = squeeze(VPowerTrials(t,f,ch,TrialGroup1));
            PowerVTrialsTstat5(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

PowerVTrialsTstat13 = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(ITIbaseV(f,ch,TrialGroup2));
            x2 = squeeze(VPowerTrials(t,f,ch,TrialGroup2));
            PowerVTrialsTstat13(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

DiffPowerVTrialsTstat = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = squeeze(VPowerTrials(t,f,ch,TrialGroup1));
            x2 = squeeze(VPowerTrials(t,f,ch,TrialGroup2));
            DiffPowerVTrialsTstat(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end


%% Combined Analysis
%=======================================

nch = 28;

PowerTrialsTstat5 = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = cat(1, squeeze(ITIbase01(f,ch,TrialGroup1_01)), squeeze(ITIbase02(f,ch,TrialGroup1_02)));
            x2 = cat(1, squeeze(PowerTrials01(t,f,ch,TrialGroup1_01)), squeeze(PowerTrials02(t,f,ch,TrialGroup1_02)));
            MeanPowerTrialsTstat5(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

PowerTrialsTstat13 = single(zeros(trial_length, nf, nch));
parfor t = 1:trial_length
    for f = 1:nf
        for ch = 1:nch
            x1 = cat(1, squeeze(ITIbase01(f,ch,TrialGroup2_01)), squeeze(ITIbase02(f,ch,TrialGroup2_02)));
            x2 = cat(1, squeeze(PowerTrials01(t,f,ch,TrialGroup2_01)), squeeze(PowerTrials02(t,f,ch,TrialGroup2_02)));
            MeanPowerTrialsTstat13(t,f,ch) = (mean(x2) - mean(x1))/sqrt(std(x1)^2/numel(x1) + std(x2)^2/numel(x2));
        end
    end
end

PowerTrialsG1 = cat(4, PowerTrials01(:,:,:,TrialGroup1_01), PowerTrials02(:,:,:,TrialGroup1_02));
PowerTrialsG2 = cat(4, PowerTrials01(:,:,:,TrialGroup2_01), PowerTrials02(:,:,:,TrialGroup2_02));

DiffPowerTrialsTstat = single(zeros(nf, nch,trial_length));
parfor t = 1:trial_length
    x1 = squeeze(PowerTrialsG1(t,:,:,:));
    x2 = squeeze(PowerTrialsG2(t,:,:,:));
    DiffPowerTrialsTstat(:,:,t) = (mean(x2,3) - mean(x1,3))./sqrt(std(x1,0,3).^2/size(x1,3) + std(x2,0,3).^2/size(x2,3));
end
DiffPowerTrialsTstat = permute(DiffPowerTrialsTstat,[3,1,2]);

% figure; hold on;
% for trial = 1:TrialNum
%     if ~isempty(AudioStart{trial})
%         StimulusEvent1 = 2 + 4*trial;
%         StimulusEvent2 = 2 + 4*trial + 1;
%         thisAudioenv = AudioEnv(round(30000*EventTimes1(StimulusEvent1)): ...
%         round(30000*EventTimes1(StimulusEvent2)));
%         plot((1:length(AudioTrials{trial}))/30000, AudioTrials{trial})
%         hold on; plot((1:length(AudioTrials{trial}))/30000, thisAudioenv/200)
%         hold on; plot(AudioStart{trial}*[1 1]/30000, ylim, 'g')
%         hold on; text(.1,1,L4{trial,1}, 'FontSize', 24);
%         player = audioplayer(AudioTrials{trial}(AudioStart{trial}:end), 30000); play(player);
% %         for k=1:(length(AudioTrials{trial})/300)
% %             plot(((300*(k-1)+1):(300*k))/30000, AudioTrials{trial}((300*(k-1)+1):(300*k)), 'r')
% %             M(k) = getframe(gcf);
% %         end
% 
%         ginput(1);
%     end
% 
%     hold off;
% end
% 
% 
% for trial = 1:TrialNum
%     if ~isempty(AudioStart{trial})
%         filename = ['trial',num2str(trial),'.wav'];
%         AudioNorm = 2*AudioTrials{trial}/(max(AudioTrials{trial})-min(AudioTrials{trial}));
%         AudioNorm = AudioNorm - (max(AudioNorm)-1);
%         audiowrite(['audio/',filename],AudioNorm,30000);
%     end
% end