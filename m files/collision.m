function VV = collision(V, sf, filename, threshold, pre, post, offset, min_t)

pre = sf*pre/1000;
post = sf*post/1000;

H = find_max(V);
trigs= find(H>threshold);
i = trigs;

if(nargin==8)
    for(j=2:length(trigs))
        if(trigs(j)<(trigs(j-1)+sf*min_t/1000)) 
            i(j)=-1; 
        end
    end
    i(i==-1)=[];
end

for(j=1:length(i))
    VV(:,j) = V((i(j)-(pre-1)):(i(j)+post));
end

figure; 
hold on;
for(j=1:length(i))
    plot(1000*((1:(pre+post))-pre)/sf, VV(:,j) - offset*(j-1));
end
ylimits = get(gca, 'ylim');
set(gca, 'ytick', ylimits(1)-1);
xlabel('ms');
title(filename);
