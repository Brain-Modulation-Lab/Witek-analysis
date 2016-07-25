function data = scan_latency(data)

% data format
%   filename


for j = 1:length(data)
        cd([data{j,1}(1:6), ' MAT']);
        workspace = load(data{j,1});
        sr = workspace.success_rate; % firing probability
        lat = workspace.mean_latency; % mean latency (ms)
        num = workspace.epoch_num; % number of trials
        
        data(j,2) = {sr};
        data(j,3) = {lat};
        data(j,4) = {num};
        
        disp(['completed ', data{j,1}]);
        
        cd('..');
end