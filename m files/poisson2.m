function y = poisson2(param, x)

param1 = param(1);
param2 = param(2);
param3 = param(3);
param4 = param(4);

y = param1*modpoisson(param2, x) + param3*modpoisson(param4, x);