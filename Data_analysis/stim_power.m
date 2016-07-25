function [ DATA ] = stim_power( Rec, params )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pre = 2.5;
post = 2.5;
window = 5;

[RightN, notched] = iterative_notch3(Rec.Data(:,3), params.Fs, [2.5, 1], 4, 100);


for k=1:floor(length(Rec.marker)/2)
    %Raw:
    [Sb(:,k),f,~]=mtspectrumc(Rec.Data((params.Fs*(Rec.marker(2*k-1)-pre-window)):(params.Fs*(Rec.marker(2*k-1)-pre)),3),params);
    [Ss(:,k),f,~]=mtspectrumc(Rec.Data((params.Fs*(Rec.marker(2*k-1)+post)):(params.Fs*(Rec.marker(2*k-1)+post+window)),3),params);
    [Sp(:,k),f,~]=mtspectrumc(Rec.Data((params.Fs*(Rec.marker(2*k)+post)):(params.Fs*(Rec.marker(2*k)+post+window)),3),params);
    
    %Notched:
    [SbN(:,k),f,~]=mtspectrumc(RightN((params.Fs*(Rec.marker(2*k-1)-pre-window)):(params.Fs*(Rec.marker(2*k-1)-pre))),params);
    [SsN(:,k),f,~]=mtspectrumc(RightN((params.Fs*(Rec.marker(2*k-1)+post)):(params.Fs*(Rec.marker(2*k-1)+post+window))),params);
    [SpN(:,k),f,~]=mtspectrumc(RightN((params.Fs*(Rec.marker(2*k)+post)):(params.Fs*(Rec.marker(2*k)+post+window))),params);
    
    if (Rec.marker(2*k-1)+post+window)>(Rec.marker(2*k)-pre)
        fprintf('Warning: stim period %d too short.\n', k);
    end
    if k<6 && (Rec.marker(2*k)+post+window)>(Rec.marker(2*(k+1)-1)-pre)
        fprintf('Warning: post-stim period %d too short.\n', k);
    end
end

freq = findfreq(4,40,f);

for i=1:floor(length(Rec.marker)/2)
    Sbsum(i).freq = sum(Sb(freq, i));
    Sssum(i).freq = sum(Ss(freq, i));
    Spsum(i).freq = sum(Sp(freq, i));
    
    SbsumN(i).freq = sum(SbN(freq, i));
    SssumN(i).freq = sum(SsN(freq, i));
    SpsumN(i).freq = sum(SpN(freq, i));
    
    DATA(i,1) = SbsumN(i).freq; 
    DATA(i,2) = SssumN(i).freq; 
    DATA(i,3) = SpsumN(i).freq;
end

for i=1:floor(length(Rec.marker)/2)
    h=figure; axes('YScale', 'log'); hold on;
    plot(f, Sb(:,i));
    plot(f, Ss(:,i), 'r');
    plot(f, SbN(:,i), 'k');
    plot(f, SsN(:,i), 'g');
    title(['Stim ', num2str(i)]);
    xlim([0 60]);
end

end

