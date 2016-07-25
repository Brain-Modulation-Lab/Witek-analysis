function [ f, sfft, sfft_norm, sfftsurr, sfft_thresh ] = spike_fft( ts, fs, nfft, window, fqrange)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ts = sort(ts);
ts1kHz = round(1000*(ts-ts(1)));
window = 2^nextpow2(fs*window);

if isempty(nfft)
    nfft = 2^nextpow2(fs*(max(ts)-min(ts)));
    if nfft < window
        nfft = window;
    end
end

D = zeros(nfft,1);
D(ts1kHz(ts1kHz<nfft)+1) = 1;

res = fs/(nfft+1); %determine frequency resolution of FFT
%sfft=abs(fft(D));

%[sfft, f] = pwelch(D(find(D~=0,1,'first'):find(D~=0,1,'last')), window, 0.5, [], fs);
[sfft, f] = pwelch(D, window, 0.5, [], fs);

%shuffle
iter=100;
I = isi(D);
sfftsurr = zeros(window/2+1, iter);
for i=1:iter
    %Isurr = knuth(I);
    Isurr = I(randperm(length(I)));
    Dsurr = zeros(nfft,1);
    Dsurr(1:length(I2D(Isurr))) = I2D(Isurr);
    [sfftsurr(:,i), ~] = pwelch(Dsurr, window, 0.5, [], fs);
end

ncomparisons = length(f(find(f>=fqrange(1), 1, 'first'):find(f<=fqrange(2), 1, 'last')));
alpha = 0.05/ncomparisons;

% normalize pdf to power in [300 500] Hz band (???)
%%norm_factor = sum(sfft(findfreq(300,500,f)))/sum(mean_sfftsurr(findfreq(300,500,f)));

% sfft_thresh = norm_factor*prctile(sfftsurr',100*(1-alpha/2))';

sfft_norm = sfft./mean(sfftsurr,2);
sfft_thresh = 1 + 2*std(sfft_norm(findfreq(300,500,f)));

% figure; plot(f, sfft, 'LineWidth', 3); set(gca,'FontSize', 24); xlim(fqrange)
% hold on; plot(f, sfft_thresh, 'LineWidth', 3);

%sfft=sfft(1:floor(end/2));
%f = res*(1:nfft/2);


end

