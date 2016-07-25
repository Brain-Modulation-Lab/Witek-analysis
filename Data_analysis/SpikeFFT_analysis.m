for i=1:length(SpikeFFT)
    SpikeFFT(i).sigf = spikefq(intersect(find(SpikeFFT(i).norm>(SpikeFFT(i).sfft_thresh)),findfreq(4,50,spikefq)));
    SpikeFFT(i).FB1 = 0;
    SpikeFFT(i).FB2 = 0;
    SpikeFFT(i).FB3 = 0;
    if ~isempty(intersect(spikefq(findfreq(4,11,spikefq)), SpikeFFT(i).sigf))
        SpikeFFT(i).FB1 = 1;
    end
    if ~isempty(intersect(spikefq(findfreq(12,24,spikefq)), SpikeFFT(i).sigf))
        SpikeFFT(i).FB2 = 1;
    end
    if ~isempty(intersect(spikefq(findfreq(25,40,spikefq)), SpikeFFT(i).sigf))
        SpikeFFT(i).FB3 = 1;
    end
end

