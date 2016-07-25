function [bdel, tdel, base, test] = group_pairdata(pairing_data, criterion)

% pairing_data format
%   cell code	directory   filename	baseline	fs	test	effect
%   tfss    baselen tfsf    tts testlen

gr = [];
k = 1;
for j = 1:length(pairing_data)
    if(strcmp(pairing_data{j,7}, criterion))
        gr(k) = j;
        x1(k) = pairing_data{j,8}  - pairing_data{j,9}; % tfss - baselen
        x2(k) = pairing_data{j,8}; % tfss
        y1(k) = pairing_data{j,11} - pairing_data{j,10}; % tts - tfsf
        y2(k) = pairing_data{j,11} + pairing_data{j,12} - pairing_data{j,10}; % tts + testlen - tfsf
        k = k+1;
    end
end

bdel = max(x1);
tdel = max(y1);
baselenmin = floor((min(x2)-max(x1))/2);
testlenmin = floor((min(y2)-max(y1))/2);

k = 1;
if length(gr) > 0
    for j = 1:length(gr)
        
        % ------- DEBUG -------
        %disp(pairing_data{gr(j),2});
        %disp(pairing_data{gr(j),3});
        
        isb = 1 + ceil((pairing_data{gr(j),8}-min(x2))/2); % index of starting baseline cell
        ist = 1 + ceil((max(y1) - pairing_data{gr(j),11} + pairing_data{gr(j),10})/2); % index of starting test cell
        
        % acquire baseline and test firing probability data
        cd(pairing_data{gr(j),2});
        workspace = load(pairing_data{gr(j),3});
        LLbase = workspace.(['LL', pairing_data{gr(j),4}]); % baseline data
        LLtest = workspace.(['LL', pairing_data{gr(j),6}]); % test data
        
        base(k,:) = LLbase(isb:(isb+baselenmin-1));
        test(k,:) = LLtest(ist:(ist+testlenmin-1));
        
        k = k+1;
        cd('..');
    end
end