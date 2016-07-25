function S = stim_start(V, threshold)

StimDur = 1000; % stimulation duration in samples

%find sampless below threshold
Sthresh = find(V<threshold);

Sthresh_clean = Sthresh;

%get first sample below threshold for each stimulation
for i = 2:size(Sthresh)
    if( Sthresh(i)-Sthresh(i-1) <= StimDur)
        Sthresh_clean(i) = -1;    
    end
end
S = Sthresh_clean(find(Sthresh_clean~=-1));

%find start of stimulation
for i = 1:size(S)
    j = S(i);
    delta = 0;
    grad = V(j)<V(j-1);
    steepgrad = grad;
    %step back while gradient is over 100% of initial gradient
    while(abs(grad) > abs(1.0*steepgrad))
        delta = delta + 1;
        grad = V(j-delta)<V(j-delta-1);
    end
    S(i) = S(i) - delta;
end