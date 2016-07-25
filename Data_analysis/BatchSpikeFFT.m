function [spikefq, SpikeFFT] = BatchSpikeFFT(dat_files)

%dat_files = dir('*.mat');
fq=[1 50];

fs=1000;


for i=1:length(dat_files)
    
    filename=dat_files(i).name;
    
    S = load(filename, 'RecID', 'qts', 'fs', 'V');
    
    [spikefq, spikefft, spikefft_norm, ~, sfft_thresh] = spike_fft(S.qts, S.fs, [], 2, fq);
    
    SpikeFFT(i).RecID=filename;
    SpikeFFT(i).NumSpikes=length(S.qts);
    QD = zeros(size(S.V));
    QD(round(30000*S.qts))=1;
    SpikeFFT(i).I = isi(QD);
    [SpikeFFT(i).Ihist, SpikeFFT(i).It] = histcounts(SpikeFFT(i).I/30000, (0:300)/3000);
    SpikeFFT(i).isi3ms = nnz(SpikeFFT(i).I<(.003*30000))/length(SpikeFFT(i).I);
    SpikeFFT(i).fr = length(S.qts)/(S.qts(end)-S.qts(1));
    SpikeFFT(i).fft = spikefft;
    SpikeFFT(i).norm = spikefft_norm;
    SpikeFFT(i).sfft_thresh = sfft_thresh;
    %STATS(:,i) = spikefft > spikefft_thresh;
    fprintf('%s processed successfully...\n', S.RecID);
    
    figure; %plot(spikefq, spikefft)
    hold on; plot(spikefq, spikefft_norm)
    hold on; plot(xlim, sfft_thresh*[1 1])
    xlim(fq)
    title(S.RecID)
    
    vars=fieldnames(S);
    for i = 1:length(vars)
        clear(vars{i})
    end
    
end

end