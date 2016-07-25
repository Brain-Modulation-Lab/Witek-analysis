function nds2bin_2(directory)

cd(directory);

d = dir('.'); %get contents of current directory

for i=1:length(d)
    if(~d(i).isdir)
        filename = d(i).name;
        %get file extension
        [name, ext] = strtok(filename, '.');
        if(ext == '.nds')
            disp(['Converting ' filename '...']);
            
            fid = fopen(filename);
            M = fread(fid, 'int32');
            fclose(fid);
            V = M(300:length(M))/4.3150e+006;
            fid = fopen([name '.bin'], 'w');
            fwrite(fid, V, 'float32');
            fclose(fid);
            disp('  ...done.');
        end
    end
end