
% for trial=1:length(SPLtrial.Right)
%     % CUE - 1 sec (ITI+)
%     area([SPLtrial.Right(trial).epoch(3)-1, SPLtrial.Right(trial).epoch(3)], value*[1 1], basevalue, 'facecolor', 'g', 'edgecolor', 'none');
%     % CUE
%     area(SPLtrial.Right(trial).epoch(3:4), value*[1 1], basevalue, 'facecolor', 'y', 'edgecolor', 'none');
%     % MOVE
%     area(SPLtrial.Right(trial).epoch(5:6), value*[1 1], basevalue, 'facecolor', 'r', 'edgecolor', 'none');
%     % POST
%     area(SPLtrial.Right(trial).epoch([6,8]), value*[1 1], basevalue, 'facecolor', 'c', 'edgecolor', 'none');
% end
basevalue = 0;
value = 180;
figure; hold on;
for trial=1:length(SPLtrial4.Left)
    % PRE
    area(SPLtrial4.Left(trial).epoch(1:2), value*[1 1], basevalue, 'facecolor', 'g', 'edgecolor', 'none');
    % MOVE
    area(SPLtrial4.Left(trial).epoch(2:3), value*[1 1], basevalue, 'facecolor', 'y', 'edgecolor', 'none');
    % POST
    area(SPLtrial4.Left(trial).epoch(3:4), value*[1 1], basevalue, 'facecolor', 'c', 'edgecolor', 'none');
end
figure; hold on;
for trial=1:length(SPLtrial4.Right)
    % PRE
    area(SPLtrial4.Right(trial).epoch(1:2), value*[1 1], basevalue, 'facecolor', 'g', 'edgecolor', 'none');
    % MOVE
    area(SPLtrial4.Right(trial).epoch(2:3), value*[1 1], basevalue, 'facecolor', 'y', 'edgecolor', 'none');
    % POST
    area(SPLtrial4.Right(trial).epoch(3:4), value*[1 1], basevalue, 'facecolor', 'c', 'edgecolor', 'none');
end