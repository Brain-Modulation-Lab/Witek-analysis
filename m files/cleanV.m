function cleanV()

% This does not work:  I can't figure out how to manipulate the base workspace
% and not the function workspace



d = dir('.'); %get contents of current directory
%f = struct2cell(d(:)); %convert directory struct into a cell array

totsize = 0;

for j = 1:length(d)
    if d(j).isdir & ~isempty(findstr(d(j).name, 'MAT'))
        cd(d(j).name);  disp(['cd ', d(j).name]);
        tempd = dir('.');
        for k = 1:length(tempd)
            if ~tempd(k).isdir & ~isempty(findstr(tempd(k).name, '.mat'))
                load(tempd(k).name);
                if exist('V') & exist('VV')
                    whosV = whos('-file', tempd(k).name, 'V');
                    disp(['in ', tempd(k).name, ': ', num2str(whosV.bytes)]);
                    totsize = totsize + whosV.bytes;
                    
                    %remove V, save 
                    clear('V');
                    save(tempd(k).name);
                    disp('CLEANED!')
                    
                end
                clear variables;
            end
        end
        cd('..'); disp('cd ..');
    end
end


disp(['**** TOTSIZE = ', num2str(totsize)]);