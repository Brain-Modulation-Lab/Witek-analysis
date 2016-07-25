function D = enforce_minISI(D, sf, minISI)

minISI = sf*minISI/1000;
last = -(minISI);
Dnz = find(D~=0);

for j = 1:length(Dnz)
    if (Dnz(j)-last) < minISI
        %D(Dnz(j)) = 0;
        D(last) = 0;
        %disp(['deleted D(', num2str(Dnz(j)), ') -- ISI = ', num2str(1000*(Dnz(j)-last)/sf), ' ms.']);
        disp(['deleted D(', num2str(last), ') -- ISI = ', num2str(1000*(Dnz(j)-last)/sf), ' ms.']);
    end
    last = Dnz(j); 
end