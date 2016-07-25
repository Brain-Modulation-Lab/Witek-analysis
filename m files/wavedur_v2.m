function [D1rise, D1, D2] = wavedur_v2(Wm, sf, prespike, postspike)

% 
% D1 - positive phase
% D2 - negative phase


unit = 1000; %display millisecs
D1max = 1.0*sf/unit; % samples
prespike = prespike*sf/unit; %convert to samples
postspike = postspike*sf/unit; %convert to samples

baseline = mean(Wm(1:(prespike-D1max)));
basestd = std(Wm(1:(prespike-D1max)));

%find D1
i=1;
while abs(Wm(i) - baseline) < 10 * basestd % define onset as 5 x std(baseline)
    %disp([num2str(i), ' : ']);
    %disp(num2str(abs(Wm(i) - 5*baseline)));
    %disp(num2str(basestd));
    i = i+1;
end
D1rise = unit*(prespike - i)/sf;
i=prespike;
while (Wm(i) > baseline) % define offset as > baseline
    i = i+1;
end
D1 = D1rise + unit*(i - prespike - 1)/sf;

%find D2
[m, im] = min(Wm(i:length(Wm)));
j=i+im-1;
while abs(Wm(j) - baseline) > 20*basestd
%     disp([num2str(j), ' : ']);
%     disp(num2str(baseline));
%     disp(num2str(abs(Wm(j) - baseline)));
%     disp(num2str(20*basestd));
    j = j+1;
end
D2 = unit*(j - i)/sf;