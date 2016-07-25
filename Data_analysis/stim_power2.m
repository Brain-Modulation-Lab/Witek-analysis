function [ DATA ] = stim_power2( Rec, fs, freqband )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pre = 2.5;
post = 2.5;
window = 5;

[RightN, notched] = iterative_notch3(Rec.Data(:,3), fs, [2.5, 1], 4, 100);

res = fs/(fs*window+1); %determine frequency resolution of FFT

for k=1:floor(length(Rec.marker)/2)
    %Raw:
    thisSb=abs(fft(Rec.Data(round(fs*(Rec.marker(2*k-1)-pre-window)):floor(fs*(Rec.marker(2*k-1)-pre)),3)));
    Sb(:,k)=thisSb(1:floor(end/2));
    thisSs=abs(fft(Rec.Data(round(fs*(Rec.marker(2*k-1)+post)):floor(fs*(Rec.marker(2*k-1)+post+window)),3)));
    Ss(:,k)=thisSs(1:floor(end/2));
    thisSp=abs(fft(Rec.Data(round(fs*(Rec.marker(2*k)+post)):floor(fs*(Rec.marker(2*k)+post+window)),3)));
    Sp(:,k)=thisSp(1:floor(end/2));
    
    %Notched:
    thisSbN=abs(fft(RightN(round(fs*(Rec.marker(2*k-1)-pre-window)):floor(fs*(Rec.marker(2*k-1)-pre)))));
    SbN(:,k)=thisSbN(1:floor(end/2));
    thisSsN=abs(fft(RightN(round(fs*(Rec.marker(2*k-1)+post)):floor(fs*(Rec.marker(2*k-1)+post+window)))));
    SsN(:,k)=thisSsN(1:floor(end/2));
    thisSpN=abs(fft(RightN(round(fs*(Rec.marker(2*k)+post)):floor(fs*(Rec.marker(2*k)+post+window)))));
    SpN(:,k)=thisSpN(1:floor(end/2));
    
    if (Rec.marker(2*k-1)+post+window)>(Rec.marker(2*k)-pre)
        fprintf('Warning: stim period %d too short.\n', k);
    end
    if k<floor(length(Rec.marker)/2) 
        if (Rec.marker(2*k)+post+window)>(Rec.marker(2*(k+1)-1)-pre)
            fprintf('Warning: post-stim period %d too short.\n', k);
        end
    end
end

f = res*(1:size(Sb,1));

freq_band = findfreq(freqband(1),freqband(2),f);

for i=1:floor(length(Rec.marker)/2)
    Sbsum(i).freq_band = sum(Sb(freq_band, i));
    Sssum(i).freq_band = sum(Ss(freq_band, i));
    Spsum(i).freq_band = sum(Sp(freq_band, i));
    
    SbsumN(i).freq_band = sum(SbN(freq_band, i));
    SssumN(i).freq_band = sum(SsN(freq_band, i));
    SpsumN(i).freq_band = sum(SpN(freq_band, i));
    
    DATA(i,1) = SbsumN(i).freq_band; 
    DATA(i,2) = SssumN(i).freq_band; 
    DATA(i,3) = SpsumN(i).freq_band;
end

% for i=1:floor(length(Rec.marker)/2)
%     h=figure; axes('YScale', 'log'); hold on;
%     plot(f, Sb(:,i));
%     plot(f, Ss(:,i), 'r');
%     plot(f, SbN(:,i), 'b');
%     plot(f, SsN(:,i), 'r');
%     plot(f, SpN(:,i), 'g');
%     title(['Stim ', num2str(i)]);
%     xlim([0 40]);
% end

end

