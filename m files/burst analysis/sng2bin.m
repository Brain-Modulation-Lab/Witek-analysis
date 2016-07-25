function sng2bin(directory)

cd(directory);

d = dir('.'); %get contents of current directory

for i=1:length(d)
    if(~d(i).isdir)
        filename = d(i).name;
        %get file extension
        [name, ext] = strtok(filename, '.');
        if(ext == '.sng')
            disp(['Converting ' filename '...']);
            
            fid = fopen(filename);
            M = fread(fid, 'int32');
            fclose(fid);
            if (length(M)>=3000259)
                V = M(260:3000259)/4.3150e+006;
                fid = fopen([name '.bin'], 'w');
                fwrite(fid, V, 'float32');
                fclose(fid);
                disp('  ...done.');
            else
                disp(['  Error: wrong file size.']);
            end
        end
    end
end