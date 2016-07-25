function varargout = preogressbar(varargin)
% PREOGRESSBAR Application M-file for preogressbar.fig
%    FIG = PREOGRESSBAR launch preogressbar GUI.
%    PREOGRESSBAR('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 23-Jul-2003 14:01:23

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    while(1)
        set(handles.dots, 'String', '');
        pause(0.5);
        set(handles.dots, 'String', '.');
        pause(0.5);
        set(handles.dots, 'String', '..');
        pause(0.5);
        set(handles.dots, 'String', '...');
        pause(0.5);
    end
    
    
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

