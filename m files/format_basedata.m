function DATA = format_basedata(LTP_LFPanalysis, freezing)

i=1;
for k = 1:length(LTP_LFPanalysis)
    if ~strcmp(LTP_LFPanalysis(k).group, 'X')
        DATA(i, 1) = mean(LTP_LFPanalysis(k).base.min);
        DATA(i, 2) = mean(LTP_LFPanalysis(k).base.max);       
        if strcmp(LTP_LFPanalysis(k).group, 'Y')
            DATA(i, 3) = 1;
        else
            DATA(i, 3) = 0;
        end
        DATA(i, 4) = freezing(k);
        i = i+1;
    end
end