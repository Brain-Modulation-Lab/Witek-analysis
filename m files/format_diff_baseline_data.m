function DATA = format_diff_baseline_data(LTP_LFPanalysis_min, LTP_LFPanalysis_max, l, n)

tbin = floor(l/n);

i=0;
for k = 1:length(LTP_LFPanalysis_min)
    if ~strcmp(LTP_LFPanalysis_min(k).group, 'X')
        
        DATA(i*(n+1)+1, 1) = {LTP_LFPanalysis_min(k).label};
        DATA(i*(n+1)+1, 2) = {num2str(0)};
        DATA(i*(n+1)+1, 3) = {num2str(mean(LTP_LFPanalysis_max(k).base.max-LTP_LFPanalysis_min(k).base.min))};
        if strcmp(LTP_LFPanalysis_min(k).group, 'Y')
            DATA(i*(n+1)+1, 4) = {num2str(1)};
        else
            DATA(i*(n+1)+1, 4) = {num2str(0)};
        end
            
        for j = 1:n
            DATA(i*(n+1)+j+1, 1) = {LTP_LFPanalysis_min(k).label};
            DATA(i*(n+1)+j+1, 2) = {num2str(j)};
            DATA(i*(n+1)+j+1, 3) = {num2str(mean(LTP_LFPanalysis_max(k).test.max(((j-1)*tbin+1):(j*tbin))-LTP_LFPanalysis_min(k).test.min(((j-1)*tbin+1):(j*tbin))))};
            if strcmp(LTP_LFPanalysis_min(k).group, 'Y')
                DATA(i*(n+1)+j+1, 4) = {num2str(1)};
            else
                DATA(i*(n+1)+j+1, 4) = {num2str(0)};
            end
        end
        i = i+1;
    end
end

