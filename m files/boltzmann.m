function y = boltzmann(param, x)

A = param(1);
B = param(2);

y = (x.^2)./(A*exp((x.^2)./B));