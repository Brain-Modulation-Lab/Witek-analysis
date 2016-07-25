function i = find_stim(T, threshold)

i = [];
i_up = [0; find(T>threshold)];
i_upp = (i_up(2:length(i_up))-1) - i_up(1:length(i_up)-1);
i = i_up(find(i_upp~=0)+1);