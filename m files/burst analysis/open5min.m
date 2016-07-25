function V = open5min(filename)

fid = fopen(filename);
M = fread(fid, 'int32');
fclose(fid);
V = 100*M(260:3000259)/4.3150e+006; % in microvolts