function HH = max_hist(VV, sf, epoch_num, filename)

HH = find_max2D(VV, sf, epoch_num);
peakhist(reshape(HH, [], 1), filename);