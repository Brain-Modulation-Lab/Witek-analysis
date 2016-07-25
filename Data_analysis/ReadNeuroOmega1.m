
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
    i=1;
    for f = Rec(d).FileIndices
        temp(i).Vars = load(File(f).Filename, ...
            'CRAW_01', 'CRAW_02', 'CRAW_03', ... % raw microelectrode channels
            'CSPK_01', 'CSPK_02', 'CSPK_03', ...  % spike-filtered microelectrode channels
            'CLFP_01', 'CLFP_02', 'CLFP_03', ...  % LFP-filtered microelectrode channels
            'CMacro_LFP_01', 'CMacro_LFP_02', 'CMacro_LFP_03', ...  % macro contact LFP channels
            'CANALOG_IN_1', 'CANALOG_IN_2', ... % analog inputs (Force)
            'CANALOG_IN_1_TimeBegin', 'CANALOG_IN_1_TimeEnd', ... % digital timestamps
            'CDIG_IN_1_Up', 'CDIG_IN_1_Down', ... % digital timestamps
            'CDIG_IN_1_TimeBegin', 'CDIG_IN_1_TimeEnd', ... % digital timestamps
            'CEEG_1___01', 'CEEG_1___02', 'CEEG_1___03', 'CEEG_1___04', 'CEEG_1___05', 'CEEG_1___06', 'CEEG_1___07', 'CEEG_1___08' ... % ECoG channels
            );
        if isfield(temp(i).Vars, 'CSPK_01')
            temp(i).Position_44k = (length_44k+1):(length_44k+length(temp(i).Vars.CSPK_01));
            length_44k = length_44k + length(temp(i).Vars.CSPK_01);
        end
        if isfield(temp(i).Vars, 'CANALOG_IN_1')
            temp(i).Position_2750 = (length_2750+1):(length_2750+length(temp(i).Vars.CANALOG_IN_1));
            length_2750 = length_2750 + length(temp(i).Vars.CANALOG_IN_1);
        end
        if isfield(temp(i).Vars, 'CLFP_01')
            temp(i).Position_1375 = (length_1375+1):(length_1375+length(temp(i).Vars.CLFP_01));
            length_1375 = length_1375 + length(temp(i).Vars.CLFP_01);
        elseif isfield(temp(i).Vars, 'CMacro_LFP_01')
            temp(i).Position_1375 = (length_1375+1):(length_1375+length(temp(i).Vars.CMacro_LFP_01));
            length_1375 = length_1375 + length(temp(i).Vars.CMacro_LFP_01);
        elseif isfield(temp(i).Vars, 'CEEG_1___01')
            temp(i).Position_1375 = (length_1375+1):(length_1375+length(temp(i).Vars.CEEG_1___01));
            length_1375 = length_1375 + length(temp(i).Vars.CEEG_1___01);
        end
        i=i+1;
    end
    Rec(d).Vraw = zeros(3,length_44k);
    Rec(d).Vspk = zeros(3,length_44k);
    Rec(d).Vlfp = zeros(3,length_1375);
    Rec(d).Force = zeros(2,length_2750);
    Rec(d).LFP = zeros(3,length_1375);
    Rec(d).ECoG = zeros(8,length_1375);
    Rec(d).DigUp = [];
    Rec(d).DigDown = [];
    i=1;
    for f = Rec(d).FileIndices
        % raw microelectrode channels
        if isfield(temp(i).Vars, 'CRAW_01')
            Rec(d).Vraw(1,temp(i).Position_44k) = temp(i).Vars.CRAW_01;
        end
        if isfield(temp(i).Vars, 'CRAW_02')
            Rec(d).Vraw(2,temp(i).Position_44k) = temp(i).Vars.CRAW_02;
        end
        if isfield(temp(i).Vars, 'CRAW_03')
            Rec(d).Vraw(3,temp(i).Position_44k) = temp(i).Vars.CRAW_03;
        end
        % spike-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CSPK_01')
            Rec(d).Vspk(1,temp(i).Position_44k) = temp(i).Vars.CSPK_01;
        end
        if isfield(temp(i).Vars, 'CSPK_02')
            Rec(d).Vspk(2,temp(i).Position_44k) = temp(i).Vars.CSPK_02;
        end
        if isfield(temp(i).Vars, 'CSPK_03')
            Rec(d).Vspk(3,temp(i).Position_44k) = temp(i).Vars.CSPK_03;
        end
        % lfp-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CLFP_01')
            Rec(d).Vlfp(1,temp(i).Position_1375) = temp(i).Vars.CLFP_01;
        end
        if isfield(temp(i).Vars, 'CLFP_02')
            Rec(d).Vlfp(2,temp(i).Position_1375) = temp(i).Vars.CLFP_02;
        end
        if isfield(temp(i).Vars, 'CLFP_03')
            Rec(d).Vlfp(3,temp(i).Position_1375) = temp(i).Vars.CLFP_03;
        end
        % lfp-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CMacro_LFP_01')
            Rec(d).LFP(1,temp(i).Position_1375) = temp(i).Vars.CMacro_LFP_01;
        end
        if isfield(temp(i).Vars, 'CMacro_LFP_02')
            Rec(d).LFP(2,temp(i).Position_1375) = temp(i).Vars.CMacro_LFP_02;
        end
        if isfield(temp(i).Vars, 'CMacro_LFP_03')
            Rec(d).LFP(3,temp(i).Position_1375) = temp(i).Vars.CMacro_LFP_03;
        end
        % analog inputs (Force)
        if isfield(temp(i).Vars, 'CANALOG_IN_1')
            Rec(d).Force(1,temp(i).Position_2750) = temp(i).Vars.CANALOG_IN_1;
        end
        if isfield(temp(i).Vars, 'CANALOG_IN_2')
            Rec(d).Force(2,temp(i).Position_2750) = temp(i).Vars.CANALOG_IN_2;
        end
        % lfp-filtered microelectrode channels
        if isfield(temp(i).Vars, 'CEEG_1___01')
            Rec(d).ECoG(1,temp(i).Position_1375) = temp(i).Vars.CEEG_1___01;
        end
        if isfield(temp(i).Vars, 'CEEG_1___02')
            Rec(d).ECoG(2,temp(i).Position_1375) = temp(i).Vars.CEEG_1___02;
        end
        if isfield(temp(i).Vars, 'CEEG_1___03')
            Rec(d).ECoG(3,temp(i).Position_1375) = temp(i).Vars.CEEG_1___03;
        end
        if isfield(temp(i).Vars, 'CEEG_1___04')
            Rec(d).ECoG(4,temp(i).Position_1375) = temp(i).Vars.CEEG_1___04;
        end
        if isfield(temp(i).Vars, 'CEEG_1___05')
            Rec(d).ECoG(5,temp(i).Position_1375) = temp(i).Vars.CEEG_1___05;
        end
        if isfield(temp(i).Vars, 'CEEG_1___06')
            Rec(d).ECoG(6,temp(i).Position_1375) = temp(i).Vars.CEEG_1___06;
        end
        if isfield(temp(i).Vars, 'CEEG_1___07')
            Rec(d).ECoG(7,temp(i).Position_1375) = temp(i).Vars.CEEG_1___07;
        end
        if isfield(temp(i).Vars, 'CEEG_1___08')
            Rec(d).ECoG(8,temp(i).Position_1375) = temp(i).Vars.CEEG_1___08;
        end
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