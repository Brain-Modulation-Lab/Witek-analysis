% dat_files = dir('*.mat');
% 
% fs = 1000;
% 
% ForceIPSI = [];
% ForceIPSIcontra = [];
% ForceCONTRA = [];
% ForceCONTRAcontra = [];
% ForceIPSIlabel = {};
% ForceCONTRAlabel = {};
% 
% for i=1:length(dat_files)
% 
%     filename=dat_files(i).name;
%     S = load(filename);
% 
%     fprintf('%s...', filename)
%     
%     %left side
%     for trial=1:length(S.SPLtrial.Left)
%         t1 = fs*round(S.SPLtrial.Left(trial).epoch(3)) - 1.5*fs;
%         t2 = fs*round(S.SPLtrial.Left(trial).epoch(3)) + 0.5*fs;
%         if S.RecSide == 1
%             ForceIPSI = cat(2, ForceIPSI, S.Force(t1:t2,1));
%             ForceIPSIcontra = cat(2, ForceIPSIcontra, S.Force(t1:t2,2));
%             ForceIPSIlabel = cat(1, ForceIPSIlabel, {S.RecID 1 trial});
%         else
%             ForceCONTRA = cat(2, ForceCONTRA, S.Force(t1:t2,1));
%             ForceCONTRAcontra = cat(2, ForceCONTRAcontra, S.Force(t1:t2,2));
%             ForceCONTRAlabel = cat(1, ForceCONTRAlabel, {S.RecID 1 trial});
%         end
%     end
%     
%     %right side
%     for trial=1:length(S.SPLtrial.Right)
%         t1 = fs*round(S.SPLtrial.Right(trial).epoch(3)) - 1.5*fs;
%         t2 = fs*round(S.SPLtrial.Right(trial).epoch(3)) + 0.5*fs;
%         if S.RecSide == 1
%             ForceCONTRA = cat(2, ForceCONTRA, S.Force(t1:t2,2));
%             ForceCONTRAcontra = cat(2, ForceCONTRAcontra, S.Force(t1:t2,1));
%             ForceCONTRAlabel = cat(1, ForceCONTRAlabel, {S.RecID 2 trial});           
%         else
%             ForceIPSI = cat(2, ForceIPSI, S.Force(t1:t2,2));
%             ForceIPSIcontra = cat(2, ForceIPSIcontra, S.Force(t1:t2,1));
%             ForceIPSIlabel = cat(1, ForceIPSIlabel, {S.RecID 2 trial});          
%         end
%     end
% 
%     
%     fprintf('done...\n')
% end


%% ForceIPSI
figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:2001)/fs - 0.5;
hold on;
plot(t, ForceIPSI, 'b')

idxViolationIPSI = find(ForceIPSI(501,:)>=100);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceIPSI(:,setdiff([1:end],idxViolationIPSI))- repmat(ForceIPSI(1500,setdiff([1:end],idxViolationIPSI)),2001,1), 'b')

temp = ForceIPSI(:,setdiff([1:end],idxViolationIPSI))- repmat(ForceIPSI(1500,setdiff([1:end],idxViolationIPSI)),2001,1);

idxViolationIPSI2 = find(temp(501,:)>=50 | temp(1000,:)>=50);

for i=1:length(idxViolationIPSI2)
    idxViolationIPSI2_0(i) = idxViolationIPSI2(i);
    while idxViolationIPSI2_0(i) ~= idxViolationIPSI2(i) + ...
            numel(find(idxViolationIPSI<=idxViolationIPSI2_0(i)))
        idxViolationIPSI2_0(i) = idxViolationIPSI2_0(i)+1;
    end
    fprintf('matching trace %d: %f\n', i, var(ForceIPSI(:,idxViolationIPSI2_0(i))-temp(:,idxViolationIPSI2(i))))
end
idxViolationIPSI = sort([idxViolationIPSI, idxViolationIPSI2_0]);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceIPSI(:,setdiff([1:end],idxViolationIPSI))- repmat(ForceIPSI(1500,setdiff([1:end],idxViolationIPSI)),2001,1), 'b')
xlim([-0.5 1.5]);

%% ForceIPSIcontra
figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:2001)/fs - 0.5;
hold on;
plot(t, ForceIPSIcontra, 'b')

idxViolationIPSIcontra = find(ForceIPSIcontra(501,:)>=100);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceIPSIcontra(:,setdiff([1:end],idxViolationIPSIcontra))- repmat(ForceIPSIcontra(1500,setdiff([1:end],idxViolationIPSIcontra)),2001,1), 'b')

temp = ForceIPSIcontra(:,setdiff([1:end],idxViolationIPSIcontra))- repmat(ForceIPSIcontra(1500,setdiff([1:end],idxViolationIPSIcontra)),2001,1);

idxViolationIPSIcontra2 = find(temp(501,:)>=50 | temp(1000,:)>=50);

for i=1:length(idxViolationIPSIcontra2)
    idxViolationIPSIcontra2_0(i) = idxViolationIPSIcontra2(i);
    while idxViolationIPSIcontra2_0(i) ~= idxViolationIPSIcontra2(i) + ...
            numel(find(idxViolationIPSIcontra<=idxViolationIPSIcontra2_0(i)))
        idxViolationIPSIcontra2_0(i) = idxViolationIPSIcontra2_0(i)+1;
    end
    fprintf('matching trace %d: %f\n', i, var(ForceIPSIcontra(:,idxViolationIPSIcontra2_0(i))-temp(:,idxViolationIPSIcontra2(i))))
end
idxViolationIPSIcontra = sort([idxViolationIPSIcontra, idxViolationIPSIcontra2_0]);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceIPSIcontra(:,setdiff([1:end],idxViolationIPSIcontra))- repmat(ForceIPSIcontra(1500,setdiff([1:end],idxViolationIPSIcontra)),2001,1), 'b')
xlim([-0.5 1.5]);

ForceIPSIlabel_violation = ForceIPSIlabel(sort(unique([idxViolationIPSI, idxViolationIPSIcontra])),:);
ForceIPSIlabel_good = ForceIPSIlabel(setdiff([1:end],sort(unique([idxViolationIPSI, idxViolationIPSIcontra]))),:);

%% ForceCONTRA
figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:2001)/fs - 0.5;
hold on;
plot(t, ForceCONTRA, 'b')
xlim([-0.5 1.5]);

idxViolationCONTRA = find(ForceCONTRA(501,:)>=100);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceCONTRA(:,setdiff([1:end],idxViolationCONTRA))- repmat(ForceCONTRA(1500,setdiff([1:end],idxViolationCONTRA)),2001,1), 'b')

temp = ForceCONTRA(:,setdiff([1:end],idxViolationCONTRA))- repmat(ForceCONTRA(1500,setdiff([1:end],idxViolationCONTRA)),2001,1);

idxViolationCONTRA2 = find(temp(501,:)>=50 | temp(1000,:)>=50);

for i=1:length(idxViolationCONTRA2)
    idxViolationCONTRA2_0(i) = idxViolationCONTRA2(i);
    while idxViolationCONTRA2_0(i) ~= idxViolationCONTRA2(i) + ...
            numel(find(idxViolationCONTRA<=idxViolationCONTRA2_0(i)))
        idxViolationCONTRA2_0(i) = idxViolationCONTRA2_0(i)+1;
    end
    fprintf('matching trace %d: %f\n', i, var(ForceCONTRA(:,idxViolationCONTRA2_0(i))-temp(:,idxViolationCONTRA2(i))))
end
idxViolationCONTRA = sort([idxViolationCONTRA, idxViolationCONTRA2_0]);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceCONTRA(:,setdiff([1:end],idxViolationCONTRA))- repmat(ForceCONTRA(1500,setdiff([1:end],idxViolationCONTRA)),2001,1), 'b')
xlim([-0.5 1.5]);

%% ForceCONTRAcontra
figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
t = (1:2001)/fs - 0.5;
hold on;
plot(t, ForceCONTRAcontra, 'b')
xlim([-0.5 1.5]);

idxViolationCONTRAcontra = find(ForceCONTRAcontra(501,:)>=100);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceCONTRAcontra(:,setdiff([1:end],idxViolationCONTRAcontra))- repmat(ForceCONTRAcontra(1500,setdiff([1:end],idxViolationCONTRAcontra)),2001,1), 'b')

temp = ForceCONTRAcontra(:,setdiff([1:end],idxViolationCONTRAcontra))- repmat(ForceCONTRAcontra(1500,setdiff([1:end],idxViolationCONTRAcontra)),2001,1);

idxViolationCONTRAcontra2 = find(temp(501,:)>=50 | temp(1000,:)>=50 | temp(1200,:)>=50);

for i=1:length(idxViolationCONTRAcontra2)
    idxViolationCONTRAcontra2_0(i) = idxViolationCONTRAcontra2(i);
    while idxViolationCONTRAcontra2_0(i) ~= idxViolationCONTRAcontra2(i) + ...
            numel(find(idxViolationCONTRAcontra<=idxViolationCONTRAcontra2_0(i)))
        idxViolationCONTRAcontra2_0(i) = idxViolationCONTRAcontra2_0(i)+1;
    end
    fprintf('matching trace %d: %f\n', i, var(ForceCONTRAcontra(:,idxViolationCONTRAcontra2_0(i))-temp(:,idxViolationCONTRAcontra2(i))))
end
idxViolationCONTRAcontra = sort([idxViolationCONTRAcontra, idxViolationCONTRAcontra2_0]);

figure;
area([0 1], 500*[1 1], -100, 'facecolor', 'y', 'edgecolor', 'none');
hold on;
plot(t, ForceCONTRAcontra(:,setdiff([1:end],idxViolationCONTRAcontra))- repmat(ForceCONTRAcontra(1500,setdiff([1:end],idxViolationCONTRAcontra)),2001,1), 'b')
xlim([-0.5 1.5]);

ForceCONTRAlabel_violation = ForceCONTRAlabel(sort(unique([idxViolationCONTRA, idxViolationCONTRAcontra])),:);
ForceCONTRAlabel_good = ForceCONTRAlabel(setdiff([1:end],sort(unique([idxViolationCONTRA, idxViolationCONTRAcontra]))),:);