%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GAUSSIAN() function
%
%   Generate gaussian curve G(x) given a vector x
%
%   G(a, x) = a(1)*exp[-(x - a(3))^2/(2*a(2)^2)]
%_______________________________________________________________
%   Arguments:
%       a = vector of gaussian parameters (see above)
%       x = vector of input values
%_______________________________________________________________
%   Returns:
%       G = vector of G output values given by equation above 
%            corresponding to input vector x.
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function G = gaussian(a, x)
G = a(1)*exp(-(x - a(3)).^2/(2*a(2).^2));