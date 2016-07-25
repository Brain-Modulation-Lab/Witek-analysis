function [CH1, CH2, CH3] = read3ch(filename, length)

header = 256;

fid = fopen(filename);

readlen = header+3*(length+1);

M = 0.00000001*fread(fid, readlen, 'int32');

CH1 = zeros(length, 1);
CH2 = zeros(length, 1);
CH3 = zeros(length, 1);

for i = 1:length
    CH1(i) = M(header + 3*i-2);
    CH2(i) = M(header + 3*i-1);
    CH3(i) = M(header + 3*i); 
end

fclose(fid);
