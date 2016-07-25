function HH = find_min2D(VV, sf, epoch_num)

for(j=1:epoch_num) 
    HH(:,j) = find_min(VV(:,j));
end