function p = chisqtestind(A, R1, C, R2)

B = R1-A;
D = R2-C;
C1 = A+C;
C2 = R1+R2-(A+C);

Aexp = R1*C1/(R1+R2);
Bexp = R1*C2/(R1+R2);
Cexp = R2*C1/(R1+R2);
Dexp = R2*C2/(R1+R2);

if(min([Aexp, Bexp, Cexp, Dexp])<5)
    disp('chisqtestind(): *** Warning: Minimum expected value < 5.  Recommend using Fishers exact test.');    
end

chisq = (A-Aexp)^2/Aexp + (B-Bexp)^2/Bexp + (C-Cexp)^2/Cexp + (D-Dexp)^2/Dexp;

p = 1 - chi2cdf(chisq, 1);

% x1 = 0:0.01:10;
% y1 = chi2pdf(x1,1);
% figure; 
% plot(x1,y1);
% hold on;
% x2 = chisq:0.01:10;
% y2 = chi2pdf(x2,1);
% area(x2,y2);
% xlabel('chi^2');
% ylabel('chi2pdf');
% title([' chi^2 = ', num2str(chisq), ' p = ', num2str(p)]);