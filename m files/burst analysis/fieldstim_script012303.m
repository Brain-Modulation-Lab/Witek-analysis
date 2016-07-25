function DataTable = fieldstim_script012303(directory)

threshold = -0.5;
baselength = 30;
duration = 150;

cd(directory);

d = dir('.'); %get contents of current directory

DataTable = zeros(length(d), nargout('meanstimwindow')-1);
WmeanTable = zeros(length(d), 1);

for i=1:length(d)
    if(~d(i).isdir)
        filename = d(i).name;
        %get file extension
        [name, ext] = strtok(filename, '.');
        if(ext == '.abf')
            disp(['Analyzing ' filename '...']);
            
            fid = fopen(filename);
            M = fread(fid, 'float32');
            fclose(fid);
            V = M(1600:length(M)-10);
            S = stim_start(V, threshold);
            W = getstimwindows(V, S, baselength, duration);
            [Wmean, base, berr, min, merr, latency] = meanstimwindow(W, baselength, duration);
            DataTable(i,:) = [base berr min merr latency];
            plot(Wmean);
            hold on;
        end
    end
end

hold off;
