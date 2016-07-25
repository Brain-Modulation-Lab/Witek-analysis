function varargout = Burst(varargin)
% BURST Application M-file for Burst.fig
%    FIG = BURST launch Burst GUI.
%    BURST('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 26-Nov-2002 17:07:29

if nargin == 0  
    
    disp('Usage: burst(Signal)');
    
elseif ~ischar(varargin{1}) % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    handles.V = varargin{1};
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end

% --------------------------------------------------------------------
function varargout = StartButton_Callback(h, eventdata, handles, varargin)

    axes(handles.Axes);
    hold on;
    plot(handles.V);
    
    set(handles.slider1, 'sliderstep', [0.01 0.1], 'max',  length(handles.V) ,'min', 1, 'Value', 1);
    
% --------------------------------------------------------------------
function varargout = slider1_Callback(h, eventdata, handles, varargin)

	axes(handles.Axes);
    z = xlim;
    newpos = get(handles.slider1,'Value');
    
    xlim([newpos newpos+z(2)-z(1)]);

% --------------------------------------------------------------------
function varargout = Threshold_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = MIBISI_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = FindPeaksButton_Callback(h, eventdata, handles, varargin)

    disp('Finding peaks...');
    if(get(handles.PosRadio, 'Value') == 1)
        handles.H = find_max(handles.V);
		guidata(handles.figure, handles);
    else
        handles.H = find_min(handles.V);
        guidata(handles.figure, handles);
    end
    
    Hdim = size(find(handles.H~=0));
    set(handles.Peaks, 'String', num2str(Hdim(1)));
    
    disp('...done.');

% --------------------------------------------------------------------
function varargout = DiscriminateButton_Callback(h, eventdata, handles, varargin)

    %disp(['PosRadio:', num2str(get(handles.PosRadio, 'Value'))]);
    %disp(['NegRadio:', num2str(get(handles.NegRadio, 'Value'))]);
    
    polarity = get(handles.PosRadio, 'Value')-get(handles.NegRadio, 'Value');
    
    disp('Discriminating...');
    handles.D = discriminate(handles.H, str2num(get(handles.Threshold, 'String')), polarity);
	guidata(handles.figure, handles);
    
    axes(handles.Axes);
    hold on;
    i = find(handles.D~=0);
    plot(i, handles.D(i), '*', 'Color', 'red');
    
    Ddim = size(find(handles.D~=0));
    set(handles.Spikes, 'String', num2str(Ddim(1)));
    
    disp('...done.');
    
% --------------------------------------------------------------------
function varargout = FindBurstsButton_Callback(h, eventdata, handles, varargin)

    disp('Finding bursts...')
    handles.B = find_bursts(handles.D, str2num(get(handles.MIBISI, 'String')));
    guidata(handles.figure, handles);

    
    s = size(handles.B);
    handles.num_bursts = s(1);
    set(handles.Bursts, 'String', num2str(handles.num_bursts));
    
    if s(1) > 0
        
        handles.CurrentBurst = 1;
        guidata(handles.figure, handles);
        
        axes(handles.Axes);
        xlim([handles.B(handles.CurrentBurst, 1)-1000 handles.B(handles.CurrentBurst, 1)+handles.B(handles.CurrentBurst, 2)+1000]);
        
        z = xlim;
        disp(['max = ', num2str(get(handles.slider1, 'max')), 'z = ', num2str(z(1)), ', ', num2str(z(2))]);
        set(handles.slider1, 'sliderstep', [0.1*(z(2)-z(1))/length(handles.V) (z(2)-z(1))/length(handles.V)], 'Value', z(1));
        
        set(handles.BurstNum, 'String', num2str(handles.CurrentBurst));
        set(handles.Start, 'String', num2str(handles.B(handles.CurrentBurst, 1)));
        set(handles.Duration, 'String', num2str(handles.B(handles.CurrentBurst, 2)));
        
    else
        disp('Did not find any bursts.');
    end
   
    disp('...done.');

    
% --------------------------------------------------------------------
function varargout = PosRadio_Callback(h, eventdata, handles, varargin)
    
	set(handles.NegRadio,'Value',0);

% --------------------------------------------------------------------
function varargout = NegRadio_Callback(h, eventdata, handles, varargin)

    set(handles.PosRadio,'Value',0);

% --------------------------------------------------------------------
function varargout = PrevButton_Callback(h, eventdata, handles, varargin)

	if (handles.CurrentBurst > 1)
        
        handles.CurrentBurst = handles.CurrentBurst - 1;
        guidata(handles.figure, handles);
        
        axes(handles.Axes);
        xlim([handles.B(handles.CurrentBurst, 1)-1000 handles.B(handles.CurrentBurst, 1)+handles.B(handles.CurrentBurst, 2)+1000]);
        
        z = xlim;
        disp(['max = ', num2str(get(handles.slider1, 'max')), 'z = ', num2str(z(1)), ', ', num2str(z(2))]);
        set(handles.slider1, 'sliderstep', [0.1*(z(2)-z(1))/length(handles.V) (z(2)-z(1))/length(handles.V)], 'Value', z(1));
        
        set(handles.BurstNum, 'String', num2str(handles.CurrentBurst));
        set(handles.Start, 'String', num2str(handles.B(handles.CurrentBurst, 1)));
        set(handles.Duration, 'String', num2str(handles.B(handles.CurrentBurst, 2)));
        
	else
        disp('Already at first burst.');
	end

% --------------------------------------------------------------------
function varargout = NextButton_Callback(h, eventdata, handles, varargin)

	if (handles.CurrentBurst < handles.num_bursts)
        
        handles.CurrentBurst = handles.CurrentBurst + 1;
        guidata(handles.figure, handles);
        
        axes(handles.Axes);
        xlim([handles.B(handles.CurrentBurst, 1)-1000 handles.B(handles.CurrentBurst, 1)+handles.B(handles.CurrentBurst, 2)+1000]);
        
        z = xlim;
        disp(['max = ', num2str(get(handles.slider1, 'max')), 'z = ', num2str(z(1)), ', ', num2str(z(2))]);
        set(handles.slider1, 'sliderstep', [0.1*(z(2)-z(1))/length(handles.V) (z(2)-z(1))/length(handles.V)], 'Value', z(1));
        
        set(handles.BurstNum, 'String', num2str(handles.CurrentBurst));
        set(handles.Start, 'String', num2str(handles.B(handles.CurrentBurst, 1)));
        set(handles.Duration, 'String', num2str(handles.B(handles.CurrentBurst, 2)));
        
	else
        disp('Already at last burst.');
	end





% --------------------------------------------------------------------
function varargout = Peaks_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = Spikes_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = Bursts_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = Start_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = Duration_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = BISI_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = BurstNum_Callback(h, eventdata, handles, varargin)

