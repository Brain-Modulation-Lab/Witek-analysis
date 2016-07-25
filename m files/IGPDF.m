function y = IGPDF(param, x)

lambda = param(1);
mu = param(2);

y = (sqrt(lambda/(2*pi)).*x.^(-3/2)).*exp(-(lambda.*(x-mu).^2)./(2*mu^2.*x));

%y = (A^2.*x.^(-3/2)).*exp(-(B.*(x-C).^2)./(C^2.*x));