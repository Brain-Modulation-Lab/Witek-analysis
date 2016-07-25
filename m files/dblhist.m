function [H1, H2, xout] = dblhist(M1, M2, binsize)

minval = min(min(M1), min(M2));
maxval = max(max(M1), max(M2));

if((maxval-minval)<binsize)
    disp('BINSIZE is too large.');
else
    nbins = ceil((maxval-minval)/binsize);
    for(i = 1:nbins)
        H1(i) = length(find(M1>=(minval+(i-1)*binsize) & M1<(minval+i*binsize)));
        H2(i) = length(find(M2>=(minval+(i-1)*binsize) & M2<(minval+i*binsize)));
        xout(i) = (minval+(i-0.5)*binsize);
    end
end

figure;
bar(xout, [H2/sum(H2); H1/sum(H1)]', 1.5);
