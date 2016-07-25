function DATA = format_minsubtractdata(LTP_LFPanalysis, l, n)

tbin = floor(l/n);

i=0;
for k = 1:length(LTP_LFPanalysis)
    if ~strcmp(LTP_LFPanalysis(k).group, 'X')
        for j = 1:n
            DATA(i*n+j, 1) = j;
            DATA(i*n+j, 2) = mean(LTP_LFPanalysis(k).test.min(((j-1)*tbin+1):(j*tbin))) - mean(LTP_LFPanalysis(k).base.min);
            if strcmp(LTP_LFPanalysis(k).group, 'Y')
                DATA(i*n+j, 3) = 1;
            else
                DATA(i*n+j, 3) = 0;
            end
        end
        i = i+1;
    end
end