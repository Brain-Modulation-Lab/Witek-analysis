function HH = find_max2D(VV, sf, epoch_num)

for(j=1:epoch_num) 
    HH(:,j) = find_max(VV(:,j));
end