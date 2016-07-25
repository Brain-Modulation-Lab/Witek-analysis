fs=100;
k=1;
for i =1:length(Rec)
    Rec(i).Nunits = max(table2array(Rec(i).Data(:,2)))+1;
    for unit=1:Rec(i).Nunits;
        thisunit = find(table2array(Rec(i).Data(:,2))==unit-1);
        Rec(i).unit(unit).tstamps = table2array(Rec(i).Data(thisunit,3));
        Rec(i).unit(unit).tbin = 0:(1/fs):(ceil(10*max(Rec(i).unit(unit).tstamps))/10);
        Rec(i).unit(unit).nbin = length(Rec(i).unit(unit).tbin);
        Rec(i).unit(unit).bincounts = histc(Rec(i).unit(unit).tstamps,Rec(i).unit(unit).tbin);
        Rec(i).unit(unit).c = xcorr(Rec(i).unit(unit).bincounts, fs, 'coeff');
        temp=abs(fft(Rec(i).unit(unit).c)); temp=temp(1:floor(end/2));
        Rec(i).unit(unit).f = fs*(1:length(temp))/(length(Rec(i).unit(unit).c)+1);
        Rec(i).unit(unit).fft = temp;
        Rec(i).unit(unit).fr = mean(Rec(i).unit(unit).bincounts);
        Rec(i).unit(unit).rand_poiss = random('Poisson',Rec(i).unit(unit).fr,[Rec(i).unit(unit).nbin,1]);
        Rec(i).unit(unit).c_poiss = xcorr(Rec(i).unit(unit).rand_poiss, fs, 'coeff');
        temp=abs(fft(Rec(i).unit(unit).c_poiss)); temp=temp(1:floor(end/2));
        Rec(i).unit(unit).poiss_fft = temp;
        %figure; plot(Rec(i).unit(unit).f, Rec(i).unit(unit).fft./median(Rec(i).unit(unit).poiss_fft)); title([Rec(i).Filename, ': Unit ', num2str(unit-1), ' FR = ', fs*num2str(Rec(i).unit(unit).fr)])
        if length(Rec(i).unit(unit).fft)==fs
            mean_fft(:,k) = Rec(i).unit(unit).fft./median(Rec(i).unit(unit).poiss_fft); k=k+1;
        end
    end
end