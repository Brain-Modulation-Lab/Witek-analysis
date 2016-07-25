function stim_interval = stim_interval(VV, sf, pre, post, this_epoch, pre_stim, post_stim, min_slope)

stim_interval = 0;
stim_segment = VV(ceil(sf*(pre+pre_stim)/1000):floor(sf*(pre+post_stim)/1000),this_epoch);
j=1;
baseline = stim_segment(1);
if(baseline<=0)
    disp('STIM_INTERVAL:  Baseline must be > zero.'); 
else
    while(stim_segment(j+1)<min_slope*baseline && j<length(stim_segment)-1)
        j=j+1;
        baseline = mean(stim_segment(1:j));
    end
    if(stim_segment(j+1)>=min_slope*baseline)
        stim_interval = pre_stim+1000*(j-1)/sf;
    else
        disp('STIM_INTERVAL:  Could not find stim artifact within this window.');    
    end
end