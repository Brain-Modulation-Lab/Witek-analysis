function [Pbase, Ptest] = pairdata_scatter(bdel, tdel, cells, effect, base, test, nbin)

for j = 1:length(cells)
    
    norm_base = base(j,:);
    norm_base(norm_base~=0)=1;
    
    fp_nb = nnz(norm_base)/length(norm_base);
    
    bin_base = bin(norm_base, nbin);
    binsize_base = floor(length(norm_base)/nbin);
    Pbase(j,:) = (1/(binsize_base*fp_nb))*bin_base;
    t_base = (binsize_base/0.5)*((1:nbin)-0.5);
    
    norm_test = test(j,:);
    norm_test(norm_test~=0)=1;
    bin_test = bin(norm_test, nbin);
    binsize_test = floor(length(norm_test)/nbin);
    Ptest(j,:) = (1/(binsize_test*fp_nb))*bin_test;
    t_test = (binsize_test/0.5)*((1:nbin)-0.5);
end

figure
hold on
for j = 1:length(cells)
    x = 1;
    m = '*';
    if strcmp(effect(j),'+')
        x = 1.2;
        m = '+';
    elseif strcmp(effect(j),'-')
        x = 0.8;
        m = 'x';
    elseif strcmp(effect(j),'~')
        x = 1;
        m = 'o';
    end
    plot([x], Ptest(j,1), m);
end
xlim([0.6 1.4])