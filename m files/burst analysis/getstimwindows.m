function W = getstimwindows(V, S, baselength, duration)

W = zeros(length(S), baselength+duration+1);

for i=1:length(S)
    if((S(i)-baselength)>0 & (S(i)+duration)<=length(V))
        W(i,:) = V(S(i)-baselength:S(i)+duration)';  
    end
end