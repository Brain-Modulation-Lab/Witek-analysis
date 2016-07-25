% dat_files = dir('*.mat');
% 
% fs = 1000;
% 
% ForceL = [];
% ForceR = [];
% ForceLabel = {};
% 
% 
% for i=1:length(dat_files)
% 
%     filename=dat_files(i).name;
%     S = load(filename);
% 
%     fprintf('%s...', filename)
%     
%     QCueStimulusTimes = S.CueStimulusTimes(S.QualityTrials);
% 
%     for trial=1:length(QCueStimulusTimes)
%         t1 = round(fs*QCueStimulusTimes(trial)) - 1.5*fs;
%         t2 = round(fs*QCueStimulusTimes(trial)) + 0.5*fs;
%         
%         if t1>0 && t2<=length(S.Force)
%             ForceL = cat(2, ForceL, S.Force(t1:t2,1));
%             ForceR = cat(2, ForceR, S.Force(t1:t2,2));
%             ForceLabel = cat(1, ForceLabel, {S.RecID S.RecSide trial t1+0.5*fs t2-0.5*fs});
%         end
% 
%     end
% 
%     fprintf('done...\n')
% end


%% ForceL
figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:2001)/fs - 0.5;
hold on;
plot(t, ForceL, 'b')
xlim([-0.5 1.5]);

idxViolationL = find(ForceL(501,:)>=100);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceL(:,setdiff([1:end],idxViolationL))- repmat(ForceL(1500,setdiff([1:end],idxViolationL)),2001,1), 'b')

temp = ForceL(:,setdiff([1:end],idxViolationL))- repmat(ForceL(1500,setdiff([1:end],idxViolationL)),2001,1);

idxViolationL2 = find(max(abs(temp(501:1500,:)),[],1)>=50);

clear idxViolationL2_0
for i=1:length(idxViolationL2)
    idxViolationL2_0(i) = idxViolationL2(i);
    while idxViolationL2_0(i) ~= idxViolationL2(i) + ...
            numel(find(idxViolationL<=idxViolationL2_0(i)))
        idxViolationL2_0(i) = idxViolationL2_0(i)+1;
    end
    fprintf('matching trace %d: %f\n', i, var(ForceL(:,idxViolationL2_0(i))-temp(:,idxViolationL2(i))))
end
idxViolationL = sort([idxViolationL, idxViolationL2_0]);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceL(:,setdiff([1:end],idxViolationL))- repmat(ForceL(1500,setdiff([1:end],idxViolationL)),2001,1), 'b')
xlim([-0.5 1.5]);


%% ForceR
figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:2001)/fs - 0.5;
hold on;
plot(t, ForceR, 'b')
xlim([-0.5 1.5]);

idxViolationR = find(ForceR(501,:)>=100);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceR(:,setdiff([1:end],idxViolationR))- repmat(ForceR(1500,setdiff([1:end],idxViolationR)),2001,1), 'b')

temp = ForceR(:,setdiff([1:end],idxViolationR))- repmat(ForceR(1500,setdiff([1:end],idxViolationR)),2001,1);

idxViolationR2 = find(max(abs(temp(501:1500,:)),[],1)>=50);

clear idxViolationL2_0
for i=1:length(idxViolationR2)
    idxViolationR2_0(i) = idxViolationR2(i);
    while idxViolationR2_0(i) ~= idxViolationR2(i) + ...
            numel(find(idxViolationR<=idxViolationR2_0(i)))
        idxViolationR2_0(i) = idxViolationR2_0(i)+1;
    end
    fprintf('matching trace %d: %f\n', i, var(ForceR(:,idxViolationR2_0(i))-temp(:,idxViolationR2(i))))
end
idxViolationR = sort([idxViolationR, idxViolationR2_0]);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceR(:,setdiff([1:end],idxViolationR))- repmat(ForceR(1500,setdiff([1:end],idxViolationR)),2001,1), 'b')
xlim([-0.5 1.5]);

% combine L and R elimination criteria
ForceLabel_violation = ForceLabel(sort(unique([idxViolationL, idxViolationR])),:);
ForceLabel_good = ForceLabel(setdiff([1:end],sort(unique([idxViolationL, idxViolationR]))),:);