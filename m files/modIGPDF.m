function y = modIGPDF(param, x)

param1 = param(1);
param2 = param(2:3);

y = param1*IGPDF(param2, x);
