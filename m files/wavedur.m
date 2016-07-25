function [D1, D2] = wavedur(Wm, sf, prespike, postspike)

% 
% D1 - initial rising phase
% D2 - falling phase
% D3 - second rising phase to baseline
% D4 - after hump
% 

unit = 1000; %display millisecs
D1max = 1.0*sf/unit; % samples
prespike = prespike*sf/unit; %convert to samples
postspike = postspike*sf/unit; %convert to samples

baseline = mean(Wm(1:(prespike-D1max)));
basestd = std(Wm(1:(prespike-D1max)));

%find D1
i=1;
while abs(Wm(i) - baseline) < 5 * basestd % define onset as 5 x std(baseline)
    %disp([num2str(i), ' : ']);
    %disp(num2str(abs(Wm(i) - 5*baseline)));
    %disp(num2str(basestd));
    i = i+1;
end
D1 = unit*(prespike - i + 2)/sf

%find D2
i=prespike+1;
while Wm(i+1) < Wm(i)
    disp([num2str(i), ' : ']);
    disp(Wm(i));
    disp(Wm(i+1));
    i = i+1;
end
D2 = unit*(i - prespike - 1)/sf