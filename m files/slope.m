function slope = slope(VV, epoch_num, pre, artifact, base)

for j = 1:epoch_num
    t = pre + artifact;
    while (VV(t,j) > VV(base,j)) && (t < pre + artifact + 100)
        t = t+1;    
    end
    slope(j,1) = VV(t-1,j) - VV(t,j);
    slope(j,2) = VV(t,j) - VV(t+1,j);
    slope(j,3) = VV(t+1,j) - VV(t+2,j);
    slope(j,4) = VV(t+2,j) - VV(t+3,j);
    slope(j,5) = VV(t+3,j) - VV(t+4,j);
end
