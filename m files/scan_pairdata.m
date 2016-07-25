function pairing_data = scan_pairdata(pairing_data)

% pairing_data format
%   cell code	directory   filename	baseline	fs	test	effect
%   tfss    baselen tfsf    tts testlen

for j = 1:length(pairing_data)
        cd(pairing_data{j,2});
        workspace = load(pairing_data{j,3});
        baselen = 2*length(workspace.(['LL', pairing_data{j,4}])); % length of baseline (ms)
        testlen = 2*length(workspace.(['LL', pairing_data{j,6}])); % length of test (ms)
        tfss = workspace.(['t', pairing_data{j,5}, 's']); % start time of FS
        tfsf = workspace.(['t', pairing_data{j,5}, 'f']); % finish time of FS
        tts = workspace.(['t', pairing_data{j,6}, 's']); % start fime of test
        
        pairing_data(j,8) = {tfss};
        pairing_data(j,9) = {baselen};
        pairing_data(j,10) = {tfsf};
        pairing_data(j,11) = {tts};
        pairing_data(j,12) = {testlen};
        
        cd('..');
end