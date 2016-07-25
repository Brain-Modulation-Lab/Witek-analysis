%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   DBLGAUSSIAN() function
%
%   Generates a gaussian curve DG(x) given a vector x.
%
%   DG(a, x) = a(1)*exp[-(x - a(3))^2/(2*a(2)^2)]
%               + a(4)*exp[-(x - a(6))^2/(2*a(5)^2)]
%_______________________________________________________________
%   Arguments:
%       a = vector of gaussian parameters (see above)
%       x = vector of input values
%_______________________________________________________________
%   Returns:
%       DG = vector of DG output values given by equation above 
%            corresponding to input vector x.
%_______________________________________________________________
%   (c) 2003 Witold J. Lipski.  Please feel free to copy
%   and/or modify this code. Questions/Comments: wjl3@pitt.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DG = dblgaussian(a, x)

DG = gaussian([a(1), a(2), a(3)], x) + gaussian([a(4), a(5), a(6)], x);