function V_raw = readnds(filename, encoding)

fid = fopen(filename);
frewind(fid);
V_raw = fread(fid, encoding);
fclose(fid);