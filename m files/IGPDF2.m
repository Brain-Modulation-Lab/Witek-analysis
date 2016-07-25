function y = IGPDF2(param, x)

param1 = param(2:3);
param2 = param(4:5);

y = param(1)*(IGPDF(param1, x) + IGPDF(param2, x));

%y = IGPDF(param1, param(1).*x) + IGPDF(param2, param(1).*x);