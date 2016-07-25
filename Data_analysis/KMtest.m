function [A] = KMtest (x,y)
%Inputs:
%   x - PSD of test epoch, frequency by trial
%   y - PSD of baseline epoch, frequency by trial
%   *Note* You must cut x and y to the frquencies you are testing, i.e.
%   12-35Hz
%Outputs:
%   A - activation weight, 1 by number of trials

mxtr = max(size(x,2),size(y,2));

mnx = nanmean(x,1);
mny = nanmean(y,1);
xystd = nanstd([x;y],[],1);

Nx = size(x,1);
Ny = size(y,1);

A = ( ( (mnx - mny).^3 ) ./ ( abs(mnx - mny) .* xystd.^2  ) ) * ( Nx*Ny/(Nx+Ny)^2  );

end