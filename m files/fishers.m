function p = fishers(A, R1, C, R2)

p = 0;
C1 = A+C;
C2 = R1+R2-(A+C);
z = factorial(R1)*factorial(R2)*factorial(C1)*factorial(C2);



if (A/R1 < C/R2)
    for x = max([0,C1-R2]):A
        p = p + z/(factorial(x)*factorial(R1-x)*factorial(C1-x)*factorial(C2-(R1-x))*factorial(R1+R2));
    end
else
    for x = A:min([R1,C1])
        p = p + z/(factorial(x)*factorial(R1-x)*factorial(C1-x)*factorial(C2-(R1-x))*factorial(R1+R2));
    end
end