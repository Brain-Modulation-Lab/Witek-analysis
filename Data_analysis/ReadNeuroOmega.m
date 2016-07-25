
mat_files = dir('*.mat');

k=0;
for i=1:length(mat_files)
    if isempty(strfind(mat_files(i).name, 'MF'))
        k=k+1;
        File(k).Filename=mat_files(i).name;
        depth_code = regexp(File(k).Filename,'-?\d+\.\d+','match');
        File(k).Depth=sscanf(depth_code{1}, '%f');
        filenumber_code = regexp(File(k).Filename,'F\d+\.mat','match');
        File(k).FileNumber=sscanf(filenumber_code{1}, 'F%d.mat');
    end
end

Depths = unique([File(:).Depth]);

for d = 1:length(Depths)
    fprintf('Processing Depth %f...\n', Depths(d));
    Rec(d).Depth = Depths(d);
    Rec(d).FileIndices = find([File(:).Depth]==Depths(d));
    Rec(d).FileNum = length(Rec(d).FileIndices);
    length_44k=0;
    length_2750=0;
    length_1375=0;
    length_1100=0;
    i=1;
    for f = Rec(d).FileIndices
        temp(i).Vars = load(File(f).Filename, ...
            'CRAW_01___Central', 'CRAW_02___Posterior', 'CRAW_03___Lateral', ... % raw microelectrode channels
            'CSPK_01___Central', 'CSPK_02___Posterior', 'CSPK_03___Lateral', ...  % spike-filtered microelectrode channels
            'CLFP_01___Central', 'CLFP_02___Posterior', 'CLFP_03___Lateral', ...  % LFP-filtered microelectrode channels
            'CMacro_LFP_01___Central', 'CMacro_LFP_02___Posterior', 'CMacro_LFP_03___Lateral', ...  % macro contact LFP channels
            'CANALOG_IN_1', 'CANALOG_IN_2', ... % analog inputs (Force)
            'CANALOG_IN_1_TimeBegin', 'CANALOG_IN_1_TimeEnd', ... % digital timestamps
            'CDIG_IN_1_Up', 'CDIG_IN_1_Down', ... % digital timestamps
            'CDIG_IN_1_TimeBegin', 'CDIG_IN_1_TimeEnd', ... % digital timestamps %'CEEG_1___01', 'CEEG_1___02', 'CEEG_1___03', 'CEEG_1___04', 'CEEG_1___05', 'CEEG_1___06', 'CEEG_1___07', 'CEEG_1___08' ... % ECoG channels
            'CECOG_HF_1___01___Array_1___01', ...
            'CECOG_HF_1___03___Array_1___03', ...
            'CECOG_HF_1___05___Array_1___05', ...
            'CECOG_HF_1___07___Array_1___07', ...
            'CECOG_HF_1___09___Array_1___09', ...
            'CECOG_HF_1___11___Array_1___11' ...
            );
        if isfield(temp(i).Vars, 'CSPK_01___Central')
            temp(i).Position_44k = (length_44k+1):(length_44k+length(temp(i).Vars.CSPK_01___Central));
            length_44k = length_44k + length(temp(i).Vars.CSPK_01___Central);
        end
        if isfield(temp(i).Vars, 'CANALOG_IN_1')
            temp(i).Position_2750 = (length_2750+1):(length_2750+length(temp(i).Vars.CANALOG_IN_1));
            length_2750 = length_2750 + length(temp(i).Vars.CANALOG_IN_1);
        end
        if isfield(temp(i).Vars, 'CLFP_01___Central')
            temp(i).Position_1375 = (length_1375+1):(length_1375+length(temp(i).Vars.CLFP_01___Central));
            length_1375 = length_1375 + length(temp(i).Vars.CLFP_01___Central);
        elseif isfield(temp(i).Vars, 'CMacro_LFP_01')
            temp(i).Position_1375 = (length_1375+1):(length_1375+length(temp(i).Vars.CMacro_LFP_01));
            length_1375 = length_1375 + length(temp(i).Vars.CMacro_LFP_01);
        elseif isfield(temp(i).Vars, 'CEEG_1___01')
            temp(i).Position_1375 = (length_1375+1):(length_1375+length(temp(i).Vars.CEEG_1___01));
            length_1375 = length_1375 + length(temp(i).Vars.CEEG_1___01);
        end
        if isfield(temp(i).Vars, 'CECOG_HF_1___01___Array_1___01')
            temp(i).Position_1100 = (length_1100+1):(length_1100+length(temp(i).Vars.CECOG_HF_1___01___Array_1___01));
            length_1100 = length_1100 + length(temp(i).Vars.CECOG_HF_1___01___Array_1___01);
        end
        i=i+1;
    end
    Rec(d).Vraw = zeros(3,length_44k);
    Rec(d).Vspk = zeros(3,length_44k);
    Rec(d).Vlfp = zeros(3,length_1375);
    Rec(d).Force = zeros(2,length_2750);
    Rec(d).LFP = zeros(3,length_1375);
    Rec(d).EMG = zeros(8,length_1100);
    Rec(d).DigUp = [];
    Rec(d).DigDown = [];
    i=1;
    for f = Rec(d).FileIndices
        % raw microelectrode channels
        if isfield(temp(i).Vars, 'CRAW_01___Central')
            Rec(d).Vraw(1,temp(i).Position_44k) = temp(i).Vars.CRAW_01___Central;
        end
        if isfield(temp(i).Vars, 'CRAW_02___Posterior')
            Rec(d).Vraw(2,temp(i).Position_44k) = temp(i).Vars.CRAW_02___Posterior;
        end
        if isfield(temp(i).Vars, 'CRAW_03___Lateral')
            Rec(d).Vraw(3,temp(i).Position_44k) = temp(i).Vars.CRAW_03___Lateral;
        end
        % spike-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CSPK_01___Central')
            Rec(d).Vspk(1,temp(i).Position_44k) = temp(i).Vars.CSPK_01___Central;
        end
        if isfield(temp(i).Vars, 'CSPK_02___Posterior')
            Rec(d).Vspk(2,temp(i).Position_44k) = temp(i).Vars.CSPK_02___Posterior;
        end
        if isfield(temp(i).Vars, 'CSPK_03___Lateral')
            Rec(d).Vspk(3,temp(i).Position_44k) = temp(i).Vars.CSPK_03___Lateral;
        end
        % lfp-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CLFP_01___Central')
            Rec(d).Vlfp(1,temp(i).Position_1375) = temp(i).Vars.CLFP_01___Central;
        end
        if isfield(temp(i).Vars, 'CLFP_02___Posterior')
            Rec(d).Vlfp(2,temp(i).Position_1375) = temp(i).Vars.CLFP_02___Posterior;
        end
        if isfield(temp(i).Vars, 'CLFP_03___Lateral')
            Rec(d).Vlfp(3,temp(i).Position_1375) = temp(i).Vars.CLFP_03___Lateral;
        end
        % lfp-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CMacro_LFP_01___Central')
            Rec(d).LFP(1,temp(i).Position_1375) = temp(i).Vars.CMacro_LFP_01___Central;
        end
        if isfield(temp(i).Vars, 'CMacro_LFP_02___Posterior')
            Rec(d).LFP(2,temp(i).Position_1375) = temp(i).Vars.CMacro_LFP_02___Posterior;
        end
        if isfield(temp(i).Vars, 'CMacro_LFP_03___Lateral')
            Rec(d).LFP(3,temp(i).Position_1375) = temp(i).Vars.CMacro_LFP_03___Lateral;
        end
        % analog inputs (Force)
        if isfield(temp(i).Vars, 'CANALOG_IN_1')
            Rec(d).Force(1,temp(i).Position_2750) = temp(i).Vars.CANALOG_IN_1;
        end
        if isfield(temp(i).Vars, 'CANALOG_IN_2')
            Rec(d).Force(2,temp(i).Position_2750) = temp(i).Vars.CANALOG_IN_2;
        end
        % lfp-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CECOG_HF_1___01___Array_1___01')
            Rec(d).EMG(1,temp(i).Position_1100) = temp(i).Vars.CECOG_HF_1___01___Array_1___01;
        end
        if isfield(temp(i).Vars, 'CECOG_HF_1___03___Array_1___03')
            Rec(d).EMG(2,temp(i).Position_1100) = temp(i).Vars.CECOG_HF_1___03___Array_1___03;
        end
        if isfield(temp(i).Vars, 'CECOG_HF_1___05___Array_1___05')
            Rec(d).EMG(3,temp(i).Position_1100) = temp(i).Vars.CECOG_HF_1___05___Array_1___05;
        end
        if isfield(temp(i).Vars, 'CECOG_HF_1___07___Array_1___07')
            Rec(d).EMG(4,temp(i).Position_1100) = temp(i).Vars.CECOG_HF_1___07___Array_1___07;
        end
        if isfield(temp(i).Vars, 'CECOG_HF_1___09___Array_1___09')
            Rec(d).EMG(5,temp(i).Position_1100) = temp(i).Vars.CECOG_HF_1___09___Array_1___09;
        end
        if isfield(temp(i).Vars, 'CCECOG_HF_1___11___Array_1___11')
            Rec(d).EMG(6,temp(i).Position_1100) = temp(i).Vars.CECOG_HF_1___11___Array_1___11;
        end
%         if isfield(temp(i).Vars, 'CEEG_1___07')
%             Rec(d).ECoG(7,temp(i).Position_1375) = temp(i).Vars.CEEG_1___07;
%         end
%         if isfield(temp(i).Vars, 'CEEG_1___08')
%             Rec(d).ECoG(8,temp(i).Position_1375) = temp(i).Vars.CEEG_1___08;
%         end
        if isfield(temp(i).Vars, 'CDIG_IN_1_Up')
            t0 = temp(1).Vars.CANALOG_IN_1_TimeBegin;
            t1 = temp(i).Vars.CDIG_IN_1_TimeBegin;
            Rec(d).DigUp = cat(2, Rec(d).DigUp, (t1-t0)+temp(i).Vars.CDIG_IN_1_Up/44000);
        end
        if isfield(temp(i).Vars, 'CDIG_IN_1_Down')
            t0 = temp(1).Vars.CANALOG_IN_1_TimeBegin;
            t1 = temp(i).Vars.CDIG_IN_1_TimeBegin;
            Rec(d).DigDown = cat(2, Rec(d).DigDown, (t1-t0)+temp(i).Vars.CDIG_IN_1_Down/44000);
        end
        i=i+1;
    end
    clear temp;
end