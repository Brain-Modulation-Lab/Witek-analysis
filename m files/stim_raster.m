function stim_raster(VV, LL, sf, epoch_num, pre, offset, filename)

if isempty(LL)
    LL = zeros(size(VV));
end

figure; 
hold on;
for(j=1:epoch_num)
    plot(1000*(1:length(VV))/sf-pre, VV(:,j)-offset*(j-1));
    if(LL(j) ~= 0)
        plot(1000*LL(j)/sf*[1 1], [0 0]-offset*(j-1), '+', 'color', 'red');
    end
end

ylimits = get(gca, 'ylim');
set(gca, 'ytick', ylimits(1)-1);
xlabel('ms');
title(filename);