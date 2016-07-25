% discriminate voltage values in H
function B = find_bursts(D, mbisi)

%disp(['MBISI: ', num2str(mbisi)]);

B = [];
dur = [];
spikes = find(D);
last_spike = spikes(1);
burst = 0;
j = 0;
nspikes = [];

if length(spikes) > 1
    for i = 2:size(spikes)
        if (spikes(i) - last_spike) <= mbisi
            if burst == 0
                %disp('Found burst...');
                burst = 1;
                j = j+1;
                nspikes(j) = 1;
                B(j) = last_spike;
            end
            nspikes(j) = nspikes(j)+1;
            dur(j) = spikes(i) - B(j);
        else
            burst = 0;
        end
        last_spike = spikes(i);   
    end
end

B = [B' dur' nspikes']