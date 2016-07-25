% dat_files = dir('*.mat');
% 
% fs = 1000;
% 
% ForceL = [];
% ForceLcontra = [];
% ForceR = [];
% ForceRcontra = [];
% ForceLLabel = {};
% ForceRLabel = {};
% 
% 
% for i=1:length(dat_files)
% 
%     filename=dat_files(i).name;
%     S = load(filename);
% 
%     fprintf('%s...', filename)
%     
%     QRightResponseTimes = S.QRightResponseTimes;
%     QLeftResponseTimes = S.QLeftResponseTimes;
%     
%     for trial=1:length(QLeftResponseTimes)
%         t1 = QLeftResponseTimes(trial) - 3.0*fs;
%         t2 = QLeftResponseTimes(trial) + 3.0*fs;
%         
%         if t1>0 && t2<=length(S.Force)
%             ForceL = cat(2, ForceL, S.Force(t1:t2,1));
%             ForceLcontra = cat(2, ForceLcontra, S.Force(t1:t2,2));
%             ForceLLabel = cat(1, ForceLLabel, {S.RecID S.RecSide trial QLeftResponseTimes(trial)});
%         end
%     end
%     
%     for trial=1:length(QRightResponseTimes)
%         t1 = QRightResponseTimes(trial) - 3.0*fs;
%         t2 = QRightResponseTimes(trial) + 3.0*fs;
%         
%         if t1>0 && t2<=length(S.Force)
%             ForceR = cat(2, ForceR, S.Force(t1:t2,2));
%             ForceRcontra = cat(2, ForceRcontra, S.Force(t1:t2,1));
%             ForceRLabel = cat(1, ForceRLabel, {S.RecID S.RecSide trial QRightResponseTimes(trial)});
%         end
%     end
% 
%     fprintf('done...\n')
% end
% 
% 
%% ForceLipsi
figure;
area([-2.5 0], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:6001)/fs - 3.0;
hold on;
plot(t, ForceL - repmat(ForceL(3000,:),6001,1), 'b')
xlim([-3.0 3.0]);

temp = ForceL - repmat(ForceL(3000,:),6001,1);

idxViolationLipsi = find(max(abs(temp(501:3000,:)),[],1)>=75);

figure;
area([-2.5 0], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceL(:,setdiff([1:end],idxViolationLipsi))- repmat(ForceL(3000,setdiff([1:end],idxViolationLipsi)),6001,1), 'b')
xlim([-3.0 3.0]);

%% ForceLcontra
figure;
area([-2.5 2.5], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:6001)/fs - 3.0;
hold on;
plot(t, ForceLcontra - repmat(ForceLcontra(2501,:),6001,1), 'b')
xlim([-3.0 3.0]);

temp = ForceLcontra - repmat(ForceLcontra(2501,:),6001,1);

idxViolationLcontra = find(max(abs(temp(501:5500,:)),[],1)>=75);

figure;
area([-2.5 2.5], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceLcontra(:,setdiff([1:end],idxViolationLcontra))- repmat(ForceLcontra(2501,setdiff([1:end],idxViolationLcontra)),6001,1), 'b')
xlim([-3.0 3.0]);

% combine L elimination criteria
idxViolationL = sort(unique([idxViolationLipsi, idxViolationLcontra]));
ForceLLabel_violation = ForceLLabel(idxViolationL,:);
ForceLLabel_good = ForceLLabel(setdiff([1:end],idxViolationL),:);


%% ForceRipsi
figure;
area([-2.5 0], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:6001)/fs - 3.0;
hold on;
plot(t, ForceR - repmat(ForceR(3000,:),6001,1), 'b')
xlim([-3.0 3.0]);

temp = ForceR - repmat(ForceR(3000,:),6001,1);

idxViolationRipsi = find(max(abs(temp(501:3000,:)),[],1)>=75);

figure;
area([-2.5 0], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceR(:,setdiff([1:end],idxViolationRipsi))- repmat(ForceR(3000,setdiff([1:end],idxViolationRipsi)),6001,1), 'b')
xlim([-3.0 3.0]);

%% ForceRcontra
figure;
area([-2.5 2.5], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:6001)/fs - 3.0;
hold on;
plot(t, ForceRcontra - repmat(ForceRcontra(2501,:),6001,1), 'b')
xlim([-3.0 3.0]);

temp = ForceRcontra - repmat(ForceRcontra(2501,:),6001,1);

idxViolationRcontra = find(max(abs(temp(501:5500,:)),[],1)>=75);

figure;
area([-2.5 2.5], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceRcontra(:,setdiff([1:end],idxViolationRcontra))- repmat(ForceRcontra(2501,setdiff([1:end],idxViolationRcontra)),6001,1), 'b')
xlim([-3.0 3.0]);

% combine R elimination criteria
idxViolationR = sort(unique([idxViolationRipsi, idxViolationRcontra]));
ForceRLabel_violation = ForceRLabel(idxViolationR,:);
ForceRLabel_good = ForceRLabel(setdiff([1:end],idxViolationR),:);