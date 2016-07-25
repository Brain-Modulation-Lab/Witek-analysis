function B = bin(M, nbins, binsize)

if nargin == 2
    if(length(M)<nbins)
        disp('M must be shorter then nbins');
    else
        binsize = floor(length(M)/nbins);
        for(i = 1:nbins)
            B(i) = sum(M((1+(i-1)*binsize):(i*binsize)));
        end
    end
elseif nargin == 3
    if nbins ~= []
        disp('nbins ignored when binsize provided');
    end
    nbins = floor(length(M)/binsize);
    for(i = 1:nbins)
        B(i) = sum(M((1+(i-1)*binsize):(i*binsize)));
    end
end
end