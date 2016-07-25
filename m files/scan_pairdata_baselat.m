function pairing_data = scan_pairdata_baselat(pairing_data)

% pairing_data format
%   cell code	directory   filename	baseline	fs	test	effect

for j = 1:length(pairing_data)
    cd(pairing_data{j,2});
    filename = [pairing_data{j,2}(1:6), pairing_data{j,4}];
    workspace = load(filename);
    
    sr_base = workspace.success_rate; % baseline firing probability
    lat = workspace.mean_latency; % mean latency (ms)
    num = workspace.epoch_num; % number of trials
    
    filename = [pairing_data{j,2}(1:6), pairing_data{j,6}];
    workspace = load(filename);
    
    sr_test = workspace.success_rate; % test firing probability
    
    pairing_data(j,8) = {sr_base};
    pairing_data(j,9) = {sr_test};
    pairing_data(j,10) = {lat};
    pairing_data(j,11) = {num};
    
    disp(['completed ', filename]);
        
    cd('..');
end