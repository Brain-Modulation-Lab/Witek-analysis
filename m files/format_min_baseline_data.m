function DATA = format_min_baseline_data(LTP_LFPanalysis, l, n)

tbin = floor(l/n);

i=0;
for k = 1:length(LTP_LFPanalysis)
    if ~strcmp(LTP_LFPanalysis(k).group, 'X')
        for j = 1:n
            DATA(i*n+j, 1) = {LTP_LFPanalysis(k).label};
            DATA(i*n+j, 2) = {num2str(j)};
            DATA(i*n+j, 3) = {num2str(mean(LTP_LFPanalysis(k).base.min))};
            DATA(i*n+j, 4) = {num2str(mean(LTP_LFPanalysis(k).test.min(((j-1)*tbin+1):(j*tbin))))};
            if strcmp(LTP_LFPanalysis(k).group, 'Y')
                DATA(i*n+j, 5) = {num2str(1)};
            else
                DATA(i*n+j, 5) = {num2str(0)};
            end
        end
        i = i+1;
    end
end