function pp = fishers_multi(LL1, LL2, TT1, TT2)

binsize1 = floor(length(LL1)/length(TT1));
binsize2 = floor(length(LL2)/length(TT2));
for j=1:length(TT1)
    for k=1:length(TT2)
        pp(j,k) = chisqtestind(nnz(LL1((1+(j-1)*binsize1):(j*binsize1))), length(LL1((1+(j-1)*binsize1):(j*binsize1))), nnz(LL2((1+(k-1)*binsize2):(k*binsize2))), length(LL2((1+(k-1)*binsize2):(k*binsize2))));
    end
end