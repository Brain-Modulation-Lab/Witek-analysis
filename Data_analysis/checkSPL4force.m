% dat_files = dir('*.mat');
% 
% fs = 1000;
% 
% for epoch=1:5
%     Epoch(epoch).ForceL = {};
%     Epoch(epoch).ForceLcontra = {};
%     Epoch(epoch).ForceR = {};
%     Epoch(epoch).ForceRcontra = {};
%     Epoch(epoch).ForceLLabel = {};
%     Epoch(epoch).ForceRLabel = {};
% end
% 
% 
% for i=1:length(dat_files)
% 
%     filename=dat_files(i).name;
%     S = load(filename);
% 
%     fprintf('%s...', filename)
%     
%     for trial=1:length(S.SPLtrial4.Left)
%         for epoch=1:(length(S.SPLtrial4.Left(trial).epoch)-1)
%             t1 = round(1000*S.SPLtrial4.Left(trial).epoch(epoch));
%             t2 = round(1000*S.SPLtrial4.Left(trial).epoch(epoch));
%             
%             if t1>0 && t2<=length(S.Force)
%                 Epoch(epoch).ForceL = cat(2, Epoch(epoch).ForceL, S.Force(t1:t2,1));
%                 Epoch(epoch).ForceLcontra = cat(2, Epoch(epoch).ForceLcontra, S.Force(t1:t2,2));
%                 Epoch(epoch).ForceLLabel = cat(1, Epoch(epoch).ForceLLabel, {S.RecID S.RecSide trial t1 t2});
%             end
%         end
%     end
%     
%     for trial=1:length(S.SPLtrial4.Right)
%         for epoch=1:(length(S.SPLtrial4.Right(trial).epoch)-1)
%             t1 = round(1000*S.SPLtrial4.Right(trial).epoch(epoch));
%             t2 = round(1000*S.SPLtrial4.Right(trial).epoch(epoch));
%             
%             if t1>0 && t2<=length(S.Force)
%                 Epoch(epoch).ForceR = cat(2, Epoch(epoch).ForceR, S.Force(t1:t2,2));
%                 Epoch(epoch).ForceRcontra = cat(2, Epoch(epoch).ForceRcontra, S.Force(t1:t2,1));
%                 Epoch(epoch).ForceRLabel = cat(1, Epoch(epoch).ForceRLabel, {S.RecID S.RecSide trial t1 t2});
%             end
%         end
%     end
% 
%     fprintf('done...\n')
% end


% ForceLipsi
epoch=5;

if var(cellfun(@(x) length(x), Epoch(epoch).ForceL)')
    T = max(cellfun(@(x) length(x), Epoch(epoch).ForceL));
    Force = cell2mat(cellfun(@(x) padarray(x,T-length(x),'post'), Epoch(epoch).ForceL, ...
        'uniformoutput', false));

else
    Force = cell2mat(Epoch(epoch).ForceL);
    T = size(Force,1);
end

idxViolationFipsi = [];

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:T)/fs;
T0 = T;
hold on;
plot(t, Force - repmat(Force(T0,:),T,1), 'b')

temp = Force - repmat(Force(T0,:),T,1);

idxViolationFipsi = find(max(abs(temp),[],1)>=75);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, Force(:,setdiff([1:end],idxViolationFipsi))- repmat(Force(T0,setdiff([1:end],idxViolationFipsi)),T,1), 'b')

%% ForceLcontra

if var(cellfun(@(x) length(x), Epoch(epoch).ForceLcontra)')
    T = max(cellfun(@(x) length(x), Epoch(epoch).ForceLcontra));
    Force = cell2mat(cellfun(@(x) padarray(x,T-length(x),'post'), Epoch(epoch).ForceLcontra, ...
        'uniformoutput', false));

else
    Force = cell2mat(Epoch(epoch).ForceLcontra);
    T = size(Force,1);
end

figure;
area([0 T/fs], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:T)/fs;
T0 = T;
hold on;
plot(t, Force - repmat(Force(T0,:),T,1), 'b')

temp = Force - repmat(Force(T0,:),T,1);

idxViolationFcontra = find(max(abs(temp),[],1)>=75);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, Force(:,setdiff([1:end],idxViolationFcontra))- repmat(Force(T0,setdiff([1:end],idxViolationFcontra)),T,1), 'b')

% combine L elimination criteria
idxViolationL{epoch} = sort(unique([idxViolationFipsi, idxViolationFcontra]));
Epoch(epoch).ForceLLabel_violation = Epoch(epoch).ForceLLabel(idxViolationL{epoch},:);
Epoch(epoch).ForceLLabel_good = Epoch(epoch).ForceLLabel(setdiff([1:end],idxViolationL{epoch}),:);

%% ForceRipsi

if var(cellfun(@(x) length(x), Epoch(epoch).ForceR)')
    T = max(cellfun(@(x) length(x), Epoch(epoch).ForceR));
    Force = cell2mat(cellfun(@(x) padarray(x,T-length(x),'post'), Epoch(epoch).ForceR, ...
        'uniformoutput', false));

else
    Force = cell2mat(Epoch(epoch).ForceR);
    T = size(Force,1);
end

idxViolationFipsi = [];

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:T)/fs;
T0 = T;
hold on;
plot(t, Force - repmat(Force(T0,:),T,1), 'b')

temp = Force - repmat(Force(T0,:),T,1);

idxViolationFipsi = find(max(abs(temp),[],1)>=75);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, Force(:,setdiff([1:end],idxViolationFipsi))- repmat(Force(T0,setdiff([1:end],idxViolationFipsi)),T,1), 'b')

%% ForceRcontra

if var(cellfun(@(x) length(x), Epoch(epoch).ForceRcontra)')
    T = max(cellfun(@(x) length(x), Epoch(epoch).ForceRcontra));
    Force = cell2mat(cellfun(@(x) padarray(x,T-length(x),'post'), Epoch(epoch).ForceRcontra, ...
        'uniformoutput', false));

else
    Force = cell2mat(Epoch(epoch).ForceRcontra);
    T = size(Force,1);
end

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:T)/fs;
T0 = T;
hold on;
plot(t, Force - repmat(Force(T0,:),T,1), 'b')

temp = Force - repmat(Force(T0,:),T,1);

idxViolationFcontra = find(max(abs(temp),[],1)>=75);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, Force(:,setdiff([1:end],idxViolationFcontra))- repmat(Force(T0,setdiff([1:end],idxViolationFcontra)),T,1), 'b')

% combine R elimination criteria
idxViolationR{epoch} = sort(unique([idxViolationFipsi, idxViolationFcontra]));
Epoch(epoch).ForceRLabel_violation = Epoch(epoch).ForceRLabel(idxViolationR{epoch},:);
Epoch(epoch).ForceRLabel_good = Epoch(epoch).ForceRLabel(setdiff([1:end],idxViolationR{epoch}),:);
