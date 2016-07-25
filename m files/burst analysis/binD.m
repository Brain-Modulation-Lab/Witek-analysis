function B = binD(D, binsize);

B = zeros(floor(length(D)/binsize), 1);

for i = 1:length(B)
    B(i) = sum(D(binsize*(i-1)+1:binsize*i));    
end