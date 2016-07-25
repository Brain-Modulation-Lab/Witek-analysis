function [lp, up] = cfbin(varargin)

if nargin == 2
n = length(varargin{1});
k = nnz(varargin{1});
alpha = varargin{2};
elseif nargin == 3
    n = varargin{1};
    k = varargin{2};
    alpha = varargin{3};
else
    disp('Usage: [lp, up] = cfbin(LL, alpha) or');   
    disp('       [lp, up] = cfbin(n, k, alpha)'); 
    return
end


if k == 0
    lp = 0;
else
    lp = (1 + finv(1-alpha/2,2*(n-k+1),2*k)*(n-k+1)/k)^-1;
end

if n == k
    up = 1;
else
    z = finv(1-alpha/2,2*(k+1),2*(n-k))*(k+1)/(n-k);
    up = z/(1+z);
end

