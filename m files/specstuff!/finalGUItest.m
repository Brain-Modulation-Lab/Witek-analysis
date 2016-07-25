function varargout = finalGUItest(varargin)
% global x1, x2, y1, y2, min_y, max_y
% FINALGUITEST M-file for finalGUItest.fig
%      FINALGUITEST, by itself, creates a new FINALGUITEST or raises the existing
%      singleton*.
%
%      H = FINALGUITEST returns the handle to a new FINALGUITEST or the handle to
%      the existing singleton*.
%
%      FINALGUITEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALGUITEST.M with the given input arguments.
%
%      FINALGUITEST('Property','Value',...) creates a new FINALGUITEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finalGUItest_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finalGUItest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finalGUItest

% Last Modified by GUIDE v2.5 09-Feb-2006 12:02:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finalGUItest_OpeningFcn, ...
                   'gui_OutputFcn',  @finalGUItest_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before finalGUItest is made visible.
function finalGUItest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finalGUItest (see VARARGIN)

% Choose default command line output for finalGUItest
handles.output = hObject;
%handles.Data = varargin{1};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finalGUItest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = finalGUItest_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in all_data.
function all_data_Callback(hObject, eventdata, handles)
% hObject    handle to all_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_data
speccy(evalin('base','Data'));

% --- Executes on button press in define_range.
function define_range_Callback(hObject, eventdata, handles)

%take input values and place into speccydefine pgm


% hObject    handle to define_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of define_range


% --- Executes during object creation, after setting all properties.
function min_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'string','0');


function min_val_Callback(hObject, eventdata, handles)
% hObject    handle to min_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_val as text
%        str2double(get(hObject,'String')) returns contents of min_val as a double


% --- Executes during object creation, after setting all properties.
function max_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'string','end');



function max_val_Callback(hObject, eventdata, handles)
% hObject    handle to max_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_val as text
%        str2double(get(hObject,'String')) returns contents of max_val as a double


% --- Executes on button press in LFP_range.
function LFP_range_Callback(hObject, eventdata, handles)
% hObject    handle to LFP_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LFP_range


% --- Executes on button press in LFP_match_range.
function LFP_match_range_Callback(hObject, eventdata, handles)
% hObject    handle to LFP_match_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LFP_match_range


% --- Executes during object creation, after setting all properties.
function miny_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miny_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'string','0');



function miny_val_Callback(hObject, eventdata, handles)
% hObject    handle to miny_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miny_val as text
%        str2double(get(hObject,'String')) returns contents of miny_val as a double


% --- Executes during object creation, after setting all properties.
function maxy_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxy_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'string','end');



function maxy_val_Callback(hObject, eventdata, handles)
% hObject    handle to maxy_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxy_val as text
%        str2double(get(hObject,'String')) returns contents of maxy_val as a double


% --- Executes on button press in submit_range.
function lfp_y_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lfp_y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function lfp_y_min_Callback(hObject, eventdata, handles)
% hObject    handle to lfp_y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lfp_y_min as text
%        str2double(get(hObject,'String')) returns contents of lfp_y_min as a double

% --- Executes during object creation, after setting all properties.
function lfp_y_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lfp_y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function lfp_y_max_Callback(hObject, eventdata, handles)
% hObject    handle to lfp_y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lfp_y_max as text



function submit_range_Callback(hObject, eventdata, handles)
%pause all functions till submit_range is pressed(BT)

% hObject    handle to submit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2double(get(handles.min_val,'string'));
x2=str2double(get(handles.max_val,'string'));
y1=str2double(get(handles.miny_val,'string'));
y2=str2double(get(handles.maxy_val,'string'));
%min_y=str2double(get(handles.lfp_y_min,'String'));
%max_y=str2double(get(handles.lfp_y_max,'String'));% returns contents of lfp_y_max as a double

speccy2test(evalin('base','Data'), x1, x2, y1, y2);
hold on
speccy3test(evalin('base','Data'), (x1*1000),(x2*1000),y1,y2);



% --- Executes during object creation, after setting all properties.






% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


