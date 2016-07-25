function varargout = LFP_Analyser(varargin)
% LFP_Analyser_GLOBAL M-file for dave_global.fig
%      LFP_Analyser_GLOBAL, by itself, creates a new LFP_Analyser_GLOBAL or raises the existing
%      singleton*.
%
%      H = LFP_Analyser_GLOBAL returns the handle to a new LFP_Analyser_GLOBAL or the handle to
%      the existing singleton*.
%
%      LFP_Analyser_GLOBAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LFP_Analyser_GLOBAL.M with the given input arguments.
%
%      LFP_Analyser_GLOBAL('Property','Value',...) creates a new LFP_Analyser_GLOBAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dave_global_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dave_global_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dave_global

% Last Modified by GUIDE v2.5 06-May-2005 18:12:50

% Begin initialization code - DO NOT START
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LFP_Analyser_OpeningFcn, ...
                   'gui_OutputFcn',  @LFP_Analyser_OutputFcn, ...
                   'gui_LayoutFcn',  @LFP_Analyser_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT START


% --- Executes just before dave_global is made visible.
function LFP_Analyser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dave_global (see VARARGIN)

% Choose default command line output for dave_global
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dave_global wait for user response (see UIRESUME)
% uiwait(handles.figure2);

scale = [0:255]/255;;
axes(handles.scale)
imagesc(scale')
colormap(jet)
axis xy
axis off

global y0
y0 =[];
global y02
y02 =[];
global tseg1
tseg1 = [];
global tseg2
tseg2 = [];
global yseg
yseg = [];
global yseg2
yseg2 = [];
global power
power = [];
global power2
power2 = [];
global freq
freq = [];
global freq2
freq2 = [];
global amz
amz = [];
global amz2
amz2 = [];
global filtered1
filtered1 = 0;
global filtered2
filtered2 = 0;
global rescaled
rescaled = 0;
global L11
L11 = [];
global L12
L12 = [];
global L21
L21 = [];
global L22
L22 = [];
% --- Outputs from this function are returned to the command line.
function varargout = LFP_Analyser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in open LFP 1.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file
file = [uigetfile('*.txt')];
global y0
    y0 = load(file);
S = size(y0);
S1 = S(1,1);
%set the value up in seconds (divide by the sample frequency)
S2 = (S1/1000)-0.001;
set(handles.text2, 'String', S2);

set(handles.edit16, 'string', file);

% --- Executes on button press in open LFP 2.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file2
file2 = [uigetfile('*.txt')];
global y02
    y02 = load(file2);
    
S = size(y02);
S1 = S(1,1);
%set the value up in seconds (divide by the sample frequency)
S2 = (S1/1000)-0.001;
set(handles.text3, 'String', S2);
    
set(handles.edit17, 'string', file2);
    
    
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

    
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

global yseg yseg2 tseg1 tseg2

%number of time windows
numtw = str2double(get(handles.edit15,'String'));
samplefrequency = 1000;


%Make the time segment divisable by the number of time windows
x = length(yseg)-(length(yseg)-floor(length(yseg)/numtw)*numtw);
ysega = yseg(1:x);
y = zeros((length(ysega)/numtw),numtw);

x1 = length(yseg2)-(length(yseg2)-floor(length(yseg2)/numtw)*numtw);
yseg2a = yseg2(1:x1);
y2 = zeros((length(yseg2a)/numtw),numtw);

%Split the time segment into time windows
    for k = 1:numtw
    win = tseg1((((k-1)*(length(tseg1)/numtw))+1):(k*(length(tseg1)/numtw)),1);
    t(:,k) = win;
   
    win2 = tseg2((((k-1)*(length(tseg2)/numtw))+1):(k*(length(tseg2)/numtw)),1);
    t2(:,k) = win2;
end
global tw
tw = get(handles.popupmenu1, 'Value');

sigmax1 = max(yseg);
sigmin1 = min(yseg);
sigmax2 = max(yseg2);
sigmin2 = min(yseg2);

winmin = t(1,tw);
winmaximum = size(t(:,tw));
winmax = t(winmaximum(1,1),tw);

winmin2 = t2(1,tw);
winmaximum2 = size(t2(:,tw));
winmax2 = t2(winmaximum2(1,1),tw);
%plot the time segments
%axes(handles.signalgraph)
%plot(tseg1,yseg);
%ylabel('Amplitude')
%title('Recorded Signal')
%plot the time segments
axes(handles.signalgraph)
plot(tseg1,yseg);
ylabel('Amplitude')
title('Recorded Signal')

hold on
global L11
L11 = [winmin winmin];
global L12
L12 = [sigmin1 sigmax1];
axes(handles.signalgraph)
plot(L11,L12,'r')

global L21
L21 = [winmax winmax];
global L22
L22 = [sigmin1 sigmax1];
axes(handles.signalgraph)
plot(L21,L22,'r')

hold off

axes(handles.signalgraph2)
plot(tseg2,yseg2);
ylabel('Amplitude')
xlabel('Time')

hold on
global L31
L31 = [winmin2 winmin2];
global L32
L32 = [sigmin2 sigmax2];
axes(handles.signalgraph2)
plot(L31,L32,'r')
global L41
L41 = [winmax2 winmax2];
global L42
L42 = [sigmin2 sigmax2];
axes(handles.signalgraph2)
plot(L41,L42,'r')

hold off

%Split the time segment into time windows
    for k = 1:numtw
    w = ysega((((k-1)*(length(ysega)/numtw))+1):(k*(length(ysega)/numtw)),1);
    y(:,k) = w;
   
    w2 = yseg2a((((k-1)*(length(yseg2a)/numtw))+1):(k*(length(yseg2a)/numtw)),1);
    y2(:,k) = w2;
    end
    
    %Calculate the power spectra    
    for k = 1:numtw
    Y = fft(y(:,k));
    Y(1) = [];
    N = length(Y);
    
    
    power1(:,k) = abs(Y(1:N/2)).^2;
    Y2 = fft(y2(:,k));
    Y(1) = [];
    N2 = length(Y2);
    
   
    power2a(:,k) = abs(Y2(1:N2/2)).^2;
    end
    
    nyquist = 1/2;
    global freq
    freq1 = samplefrequency*(1:N/2)/(N/2)*nyquist;
    maxfreq = find(freq1>150); 
    freq = freq1(1:maxfreq(1,1));
    
    global freq2
    freq2a = samplefrequency*(1:N2/2)/(N2/2)*nyquist;
    maxfreq2 = find(freq2a>150); 
    freq2 = freq2a(1:maxfreq2(1,1));

    global power
    power = power1(1:maxfreq(1,1),:);
    global power2
    power2 = power2a(1:maxfreq2(1,1),:);

%Plot the power spectra
v1 = get(handles.popupmenu1, 'Value');

for k=1:numtw
switch v1
    case k;
        axes(handles.power)
        plot(freq,log(power(:,k)))
        ylabel('spectral density')
        title('Power Spectrum')
        ymax  = max(power(:,k));
        %axis ([-5 80 0 ymax]) 

        axes(handles.powergraph2)
        plot(freq2,log(power2(:,k)))
        xlabel('Frequency')
        ylabel('spectral density')
        ymax2  = max(power2(:,k));
        %axis ([-5 80 0 ymax2]) 

end
end

% --- Executes on button press in loadcorr.
function loadcorr_Callback(hObject, eventdata, handles)
% hObject    handle to loadcorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global r r2 freq freq2 rescaled

if rescaled == 0
%correlation coefficients
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,r)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([0 150 0 150])

axes(handles.corr2)
colormap(jet)
imagesc(freq2,freq2,r2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([0 150 0 150])
else
    
axismin = str2double(get(handles.edit13,'String'));
axismax = str2double(get(handles.edit14,'String'));
    %correlation coefficients
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,r)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])

axes(handles.corr2)
colormap(jet)
imagesc(freq2,freq2,r2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])
end    

global filtered1 filtered2
filtered1 = 0;
filtered2 = 0;
% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: start controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start as text
%        str2double(get(hObject,'String')) returns contents of start as a double

tstart = str2double(get(handles.start,'String'))

% --- Executes during object creation, after setting all properties.
function end1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: start controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function end1_Callback(hObject, eventdata, handles)
% hObject    handle to end1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end1 as text
%        str2double(get(hObject,'String')) returns contents of end1 as a double

tend = str2double(get(handles.end1,'String'))

% --- Executes during object creation, after setting all properties.
function tstart2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tstart2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function tstart2_Callback(hObject, eventdata, handles)
% hObject    handle to tstart2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tstart2 as text
%        str2double(get(hObject,'String')) returns contents of tstart2 as a double

tstart2 = str2double(get(handles.tstart2,'String'))
% --- Executes during object creation, after setting all properties.
function tend2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tend2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tend2_Callback(hObject, eventdata, handles)
% hObject    handle to tend2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tend2 as text
%        str2double(get(hObject,'String')) returns contents of tend2 as a double

tend2 = str2double(get(handles.tend2,'String'))


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y0 y02 tseg1 tseg2 yseg yseg2 power power2 freq freq2

global y0
y0 =[];
global y02
y02 =[];
global tseg1
tseg1 = [];
global tseg2
tseg2 = [];
global yseg
yseg = [];
global yseg2
yseg2 = [];
global power
power = [];
global power2
power2 = [];
global freq
freq = [];
global freq2
freq2 = [];
global amz
amz = [];
global amz2
amz2 = [];
global filtered1
filtered1 = 0;
global filtered2
filtered2 = 0;
global rescaled
rescaled = 0;
set(handles.edit13, 'String', 0);
set(handles.edit14, 'String', 150);
set(handles.popupmenu1, 'Value', 1);
set(handles.text2, 'String', 0);
set(handles.text3, 'String', 0);
set(handles.start, 'String', 0);
set(handles.tstart2, 'String', 0);
set(handles.end1, 'String', 20);
set(handles.tend2, 'String', 20);
set(handles.edit11, 'String', 0.1);
set(handles.edit12, 'String', 0.1);
set(handles.edit16, 'String', 'file name');
set(handles.edit17, 'String', 'file name');
axes(handles.signalgraph)
plot(0,0)
axes(handles.signalgraph2)
plot(0,0)
axes(handles.power)
plot(0,0)
axes(handles.powergraph2)
plot(0,0)
axes(handles.spect)
plot(0,0)
axes(handles.spectgraph2)
plot(0,0)
axes(handles.corr)
plot(0,0)
axes(handles.corr2)
plot(0,0)
% --- Executes on button press in all.
function all_Callback(hObject, eventdata, handles)
% hObject    handle to all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%------------------------------------------------------------------------------
%make the number of time windows selectable in the popupmenu correct
entries = {'graph 1'};
value   = get(handles.popupmenu1,'Value');
rows = length(entries);

numtw = str2double(get(handles.edit15,'String'));

for i = 2:numtw
newEntryName1 = {'graph '};
newEntryName2 = {int2str(i)};
newEntryName = strcat(newEntryName1,newEntryName2);

entries = [entries; newEntryName];
end

% Update the popupmenu
set(handles.popupmenu1,'Value',1,'String',entries)
%------------------------------------------------------------------------------


%Import the signal
global y0
ytotal = y0(:,2);
ttotal = y0(:,1);

global y02
ytotal2 = y02(:,2);
ttotal2 = y02(:,1);

%Read the Start and End times of the time segment  
global tstart
tstart = 1000*str2double(get(handles.start,'String'))+1;
global tend
tend = 1000*str2double(get(handles.end1,'String'))+1;
global tstart2
tstart2 = 1000*str2double(get(handles.tstart2,'String'))+1;
global tend2
tend2 = 1000*str2double(get(handles.tend2,'String'))+1;

%Export the time segments
global tseg1
tseg1 = ttotal(tstart:tend,:);

global tseg2
tseg2 = ttotal2(tstart2:tend2,:);

global yseg
yseg = ytotal(tstart:tend,:);

global yseg2
yseg2 = ytotal2(tstart2:tend2,:);


%number of time windows
samplefrequency = 1000;


%plot the time segments
axes(handles.signalgraph)
plot(tseg1,yseg);
ylabel('Amplitude')
title('Recorded Signal')


axes(handles.signalgraph2)
plot(tseg2,yseg2);
xlabel('Time')
ylabel('Amplitude')


%Make the time segment divisable by the number of time windows
x = length(yseg)-(length(yseg)-floor(length(yseg)/numtw)*numtw);
ysega = yseg(1:x);
y = zeros((length(ysega)/numtw),numtw);

x1 = length(yseg2)-(length(yseg2)-floor(length(yseg2)/numtw)*numtw);
yseg2a = yseg2(1:x1);
y2 = zeros((length(yseg2a)/numtw),numtw);


%Split the time segment into time windows
    for k = 1:numtw
    w = ysega((((k-1)*(length(ysega)/numtw))+1):(k*(length(ysega)/numtw)),1);
    y(:,k) = w;
   
    w2 = yseg2a((((k-1)*(length(yseg2a)/numtw))+1):(k*(length(yseg2a)/numtw)),1);
    y2(:,k) = w2;
    end
    
    %Calculate the power spectra    
    for k = 1:numtw
    Y = fft(y(:,k));
    Y(1) = [];
    N = length(Y);
    
    
    power1(:,k) = abs(Y(1:N/2)).^2;
     
    Y2 = fft(y2(:,k));
    Y2(1) = [];
    N2 = length(Y2);
    
   
    power2a(:,k) = abs(Y2(1:N2/2)).^2;
    end
    
    nyquist = 1/2;
    global freq
    freq1 = samplefrequency*(1:N/2)/(N/2)*nyquist;
    maxfreq = find(freq1>150); 
    freq = freq1(1:maxfreq(1,1));
    
    global freq2
    freq2a = samplefrequency*(1:N2/2)/(N2/2)*nyquist;
    maxfreq2 = find(freq2a>150); 
    freq2 = freq2a(1:maxfreq2(1,1));

    global power
    power = power1(1:maxfreq(1,1),:);
    global power2
    power2 = power2a(1:maxfreq2(1,1),:);
  
  axes(handles.power)
  freq
  powera = mean(power,2);
  plot(freq,log(powera))
        ylabel('spectral density')
        title('Power Spectrum')
        
        
        axes(handles.powergraph2)
        power2a = mean(power2,2);
        plot(freq2,log(power2a))
        xlabel('Frequency')
        ylabel('spectral density')
        
    
axes(handles.spect)
[B,F,T] = specgram(yseg,256,1000);
imagesc(T,F,20*log10(abs(B)))
axis xy
colormap(jet)
title('Spectrogram')
ylabel('Frequency')



%global X2
axes(handles.spectgraph2);
[B2,F2,T2] = specgram(yseg2,256,1000);
imagesc(T2,F2,20*log10(abs(B2)))
axis xy 
ylabel('Frequency')
xlabel('Time')



%Calculate the correlation Coefficients
global r
r = corrcoef(power');  % Compute sample correlation and p-values.

global r2
r2 = corrcoef(power2');  % Compute sample correlation and p-values.

 
%Plotting the correlation coefficients
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,r)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([0 150 0 150])

axes(handles.corr2)
colormap(jet)
imagesc(freq2,freq2,r2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([0 150 0 150])


function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function bmp_Callback(hObject, eventdata, handles)
% hObject    handle to jpeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname1 = [uiputfile('*.bmp','Save GUI As')];
saveas(handles.signalgraph, fname1)


% --------------------------------------------------------------------
function fig_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname2 = [uiputfile('*.fig','Save GUI As')];
saveas(hObject, fname2)

% --------------------------------------------------------------------
function figures_Callback(hObject, eventdata, handles)
% hObject    handle to figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function seg1_Callback(hObject, eventdata, handles)
% hObject    handle to seg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tseg1 yseg file tstart tend L11 L12 L21 L22

figure(1)
plot(tseg1,yseg);
xlabel('Time')
ylabel('Amplitude')
title(['Time Segment from: "' ,file, '" between ' ,int2str((tstart-1)/1000), ' and ',int2str((tend-1)/1000), ' seconds' ])

hold on
plot(L11,L12,'r')
plot(L21,L22,'r')
hold off

global L11
L11 = [];
global L12
L12 = [];
global L21
L21 = [];
global L22
L22 = [];

% --------------------------------------------------------------------
function seg2_Callback(hObject, eventdata, handles)
% hObject    handle to seg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tseg2 yseg2 file2 tstart2 tend2 L31 L32 L41 L42
figure(2)
plot(tseg2,yseg2);
xlabel('Time')
ylabel('Amplitude')
title(['Time Segment from: "' ,file2, '" between ' ,int2str((tstart2-1)/1000), ' and ',int2str((tend2-1)/1000), ' seconds' ])

hold on
plot(L31,L32,'r')
plot(L41,L42,'r')
hold off

global L31
L31 = [];
global L32
L32 = [];
global L41
L41 = [];
global L42
L42 = [];

% --------------------------------------------------------------------
function power1_Callback(hObject, eventdata, handles)
% hObject    handle to power1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global power freq file
v1 = get(handles.popupmenu1, 'Value')

        figure(3)
        plot(freq,power(:,v1))
        xlabel('Frequency')
        ylabel('spectral density')
        title(['Power Spectrum of: "' ,file, '" from time window ' ,int2str(v1)])
        ymax  = max(power(:,v1));
        axis ([-5 80 0 ymax]) 

% --------------------------------------------------------------------
function power2_Callback(hObject, eventdata, handles)
% hObject    handle to power2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global power2 freq2 file2
v1 = get(handles.popupmenu1, 'Value')

        figure(4)
        plot(freq2,power2(:,v1))
        xlabel('Frequency')
        ylabel('spectral density')
        title(['Power Spectrum of: "' ,file2, '" from time window ' ,int2str(v1)])
        ymax  = max(power2(:,v1));
        axis ([-5 80 0 ymax]) 

% --------------------------------------------------------------------
function spectrogram1_Callback(hObject, eventdata, handles)
% hObject    handle to spectrogram1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X file tstart tend
figure(5)
colormap(jet)
imagesc(abs(X))
xlabel('Time')
ylabel('Frequency')
title(['Spectrogram of: "' ,file, '" between ' ,int2str((tstart-1)/1000), ' and ',int2str((tend-1)/1000), ' seconds' ]) 
axis xy
axis([0 150 0 40])

% --------------------------------------------------------------------
function spectrogram2_Callback(hObject, eventdata, handles)
% hObject    handle to spectrogram2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X2 file2 tstart2 tend2
figure(6)
colormap(jet)
imagesc(abs(X2))
xlabel('Time')
ylabel('Frequency')
title(['Spectrogram of: "' ,file2, '" between ' ,int2str((tstart2-1)/1000), ' and ',int2str((tend2-1)/1000), ' seconds' ]) 
axis xy
axis([0 150 0 40])
% --------------------------------------------------------------------
function coefficient1_Callback(hObject, eventdata, handles)
% hObject    handle to coefficient1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global freq r file tstart tend filtered1 amz thresh
axismin = str2double(get(handles.edit13,'String'));
axismax = str2double(get(handles.edit14,'String'));
figure(7)
colormap(jet)
if filtered1 == 0
imagesc(freq,freq,r)
title(['Correlation Coefficients from: "' ,file, '" calculated between ' ,int2str((tstart-1)/1000), ' and ',int2str((tend-1)/1000), ' seconds' ])
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax]) 
else
    imagesc(freq,freq,amz)
title(['Correlation Coefficients from: "' ,file, '" calculated between ' ,int2str((tstart-1)/1000), ' and ',int2str((tend-1)/1000), ' seconds with filter threshold of ' ,num2str(thresh)])
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax]) 
    
end
% --------------------------------------------------------------------
function coefficient2_Callback(hObject, eventdata, handles)
% hObject    handle to coefficient2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global freq2 r2 file2 tstart2 tend2 filtered2 amz2 thresh2
axismin = str2double(get(handles.edit13,'String'));
axismax = str2double(get(handles.edit14,'String'));
figure(8)
colormap(jet)
if filtered2 == 0
imagesc(freq2,freq2,r2)
title(['Correlation Coefficients from: "' ,file2, '" calculated between ' ,int2str((tstart2-1)/1000), ' and ',int2str((tend2-1)/1000), ' seconds' ])
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax]) 
else
imagesc(freq2,freq2,amz2)
title(['Correlation Coefficients from: "' ,file2, '" calculated between ' ,int2str((tstart2-1)/1000), ' and ',int2str((tend2-1)/1000), ' seconds with filter threshold of ' ,num2str(thresh2)])
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax]) 
end

% --- Executes on button press in filter 1.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global r freq amz filtered1 rescaled
global thresh
thresh = str2double(get(handles.edit11,'String'))
mask = (r > thresh); 
global amz 
amz = mask.*r;
if rescaled == 0
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,amz)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([0 150 0 150])
else
global axismin 
axismin = str2double(get(handles.edit13,'String'));
global axismax
axismax = str2double(get(handles.edit14,'String'));   
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,amz)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax]) 
end

filtered1 = 1;
% --- Executes on button press in filter 2.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global r2 freq2 filtered2 rescaled
global thresh2 
thresh2 = str2double(get(handles.edit12,'String'))
 mask2 = (r2 > thresh2); 
global amz2
amz2 = mask2.*r2;
if rescaled == 0
axes(handles.corr2)
colormap(jet)
imagesc(freq2,freq2,amz2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([0 150 0 150])
else
axismin = str2double(get(handles.edit13,'String'));
axismax = str2double(get(handles.edit14,'String'))  ; 
axes(handles.corr2)
colormap(jet)
imagesc(freq2,freq2,amz2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])   
end

filtered2 = 1;

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)%txt box threshold 1
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%txt box threshold 1
function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
global threshold1
 threshold1 = str2double(get(handles.edit11,'String'))


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)%txt box threshold 2
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%txt box threshold 2
function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
global threshold2
 threshold2 = str2double(get(handles.edit12,'String'))


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)%txt box axismin
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%txt box axismin
function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
axismin = str2double(get(handles.edit13,'String'))

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)%txt box axismax
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%txt box axismax
function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
axismax = str2double(get(handles.edit14,'String'))

% --- Executes on button press in zoom (in or out).
function pushbutton18_Callback(hObject, eventdata, handles)%zoom in or out
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global amz amz2 freq freq2 r r2 filtered1 filtered2 rescaled
axismin = str2double(get(handles.edit13,'String'));
axismax = str2double(get(handles.edit14,'String'));
rescaled = 1;
if filtered1 == 0 
%Plotting the correlation coefficients
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,r)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])
else
axes(handles.corr)
colormap(jet)
imagesc(freq,freq,amz)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])    
end

if filtered2 == 0
axes(handles.corr2)
colormap(jet)
imagesc(freq2,freq2,r2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])
else
axes(handles.corr2)
colormap(jet)
imagesc(freq,freq,amz2)
title('Correlation Coefficients')
xlabel('fi')
ylabel('fj')
axis xy
axis([axismin axismax axismin axismax])  
end


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)%txt box number of time windows
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%txt box number of time windows
function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double






% --- Creates and returns a handle to the GUI figure. 
function h1 = LFP_Analyser_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

h1 = figure(...
'Units','characters',...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','final2',...
'NumberTitle','off',...
'PaperOrientation','landscape',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',[29.67743169791 20.98404194812],...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.4 5.61538461538462 206 56],...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'HandleVisibility','callback',...
'Tag','figure2',...
'UserData',zeros(1,0));

setappdata(h1, 'GUIDEOptions', struct(...
'active_h', 2.010002e+002, ...
'taginfo', struct(...
'figure', 2, ...
'popupmenu', 2, ...
'axes', 13, ...
'pushbutton', 19, ...
'edit', 18, ...
'text', 18, ...
'frame', 10, ...
'listbox', 2, ...
'togglebutton', 2), ...
'override', 1, ...
'release', 13, ...
'resize', 'simple', ...
'accessibility', 'callback', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'lastSavedFile', 'C:\Documents and Settings\Jon\Desktop\final2.m'));

set(h1,'CreateFcn','movegui')
hgsave(h1,'onscreenfig')
close(h1)
h1 = hgload('onscreenfig');

h2 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.387378640776699 0.755494505494506 0.24368932038835 0.207417582417582],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','power');


h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.03233830845771 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863787 -0.116915422885572 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820598 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-1.49335548172757 1.17164179104478 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h7 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.704854368932039 0.756868131868133 0.24368932038835 0.207417582417582],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','spect');


h8 = get(h7,'title');

set(h8,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.03233830845771 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h9 = get(h7,'xlabel');

set(h9,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863788 -0.116915422885572 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h10 = get(h7,'ylabel');

set(h10,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820596 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h11 = get(h7,'zlabel');

set(h11,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-2.82225913621262 1.17164179104478 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h12 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.0690661478599221 0.0661157024793389 0.243190661478599 0.315426997245179],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','corr');


h13 = get(h12,'title');

set(h13,...
'Parent',h12,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.02159468438538 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h14 = get(h12,'xlabel');

set(h14,...
'Parent',h12,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863787 -0.0780730897009967 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h15 = get(h12,'ylabel');

set(h15,...
'Parent',h12,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820598 0.496677740863788 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h16 = get(h12,'zlabel');

set(h16,...
'Parent',h12,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-0.164451827242525 2.7890365448505 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h17 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.387378640776699 0.502747252747253 0.24368932038835 0.207417582417582],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','powergraph2');


h18 = get(h17,'title');

set(h18,...
'Parent',h17,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.03233830845771 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h19 = get(h17,'xlabel');

set(h19,...
'Parent',h17,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863787 -0.116915422885572 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h20 = get(h17,'ylabel');

set(h20,...
'Parent',h17,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820598 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h21 = get(h17,'zlabel');

set(h21,...
'Parent',h17,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-1.49335548172757 2.31592039800995 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h22 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 0],...
'ListboxTop',0,...
'Position',[0.695525291828794 0.00826446280991736 0.277237354085603 0.440771349862259],...
'String',{ '' },...
'Style','frame',...
'Tag','frame2');


h23 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.701361867704281 0.170798898071625 0.26556420233463 0.0909090909090909],...
'String',{ '' },...
'Style','frame',...
'Tag','frame6');


h24 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.72568093385214 0.198347107438017 0.230544747081712 0.0619834710743802],...
'String',{ 'Choose a graph below which representing ' 'the power spectra for an individual time window ' '(i.e. Graph 1 = first time window) ' },...
'Style','text',...
'Tag','text12');


h25 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.700389105058366 0.265840220385675 0.0972762645914397 0.0495867768595041],...
'String',{ 'Number of time ' '            windows' },...
'Style','text',...
'Tag','text16');


h26 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.701361867704281 0.0716253443526171 0.266536964980544 0.0922865013774105],...
'String',{ '' },...
'Style','frame',...
'Tag','frame8');


h27 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.836575875486381 0.319559228650138 0.130350194552529 0.12396694214876],...
'String',{ '' },...
'Style','frame',...
'Tag','frame7');


h28 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.700389105058366 0.319559228650138 0.130350194552529 0.12396694214876],...
'String',{ '' },...
'Style','frame',...
'Tag','frame5');


h29 = uimenu(...
'Parent',h1,...
'Callback','LFP_Analyser(''file_Callback'',gcbo,[],guidata(gcbo))',...
'Label','File',...
'Tag','file');

h30 = uimenu(...
'Parent',h29,...
'Callback','LFP_Analyser(''save_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Save',...
'Tag','save');

h31 = uimenu(...
'Parent',h30,...
'Callback','LFP_Analyser(''bmp_Callback'',gcbo,[],guidata(gcbo))',...
'Label','.bmp',...
'Tag','bmp');

h32 = uimenu(...
'Parent',h30,...
'Callback','LFP_Analyser(''fig_Callback'',gcbo,[],guidata(gcbo))',...
'Label','.fig',...
'Tag','fig');

h33 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.704854368932039 0.502747252747253 0.24368932038835 0.207417582417582],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','spectgraph2');


h34 = get(h33,'title');

set(h34,...
'Parent',h33,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.03233830845771 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h35 = get(h33,'xlabel');

set(h35,...
'Parent',h33,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863788 -0.116915422885572 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h36 = get(h33,'ylabel');

set(h36,...
'Parent',h33,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820596 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h37 = get(h33,'zlabel');

set(h37,...
'Parent',h33,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-2.82225913621262 2.32587064676617 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h38 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.0689320388349515 0.504120879120879 0.24368932038835 0.207417582417582],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','signalgraph2');


h39 = get(h38,'title');

set(h39,...
'Parent',h38,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.03233830845771 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h40 = get(h38,'xlabel');

set(h40,...
'Parent',h38,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863787 -0.116915422885572 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h41 = get(h38,'ylabel');

set(h41,...
'Parent',h38,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820598 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h42 = get(h38,'zlabel');

set(h42,...
'Parent',h38,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-0.164451827242525 2.32089552238806 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h43 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.388132295719844 0.0633608815426997 0.243190661478599 0.318181818181818],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','corr2');


h44 = get(h43,'title');

set(h44,...
'Parent',h43,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.02159468438538 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h45 = get(h43,'xlabel');

set(h45,...
'Parent',h43,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863787 -0.0780730897009967 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h46 = get(h43,'ylabel');

set(h46,...
'Parent',h43,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820598 0.496677740863787 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h47 = get(h43,'zlabel');

set(h47,...
'Parent',h43,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-1.49335548172757 2.78239202657807 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h48 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.0689320388349515 0.754120879120879 0.24368932038835 0.207417582417582],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','signalgraph');


h49 = get(h48,'title');

set(h49,...
'Parent',h48,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.03233830845771 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h50 = get(h48,'xlabel');

set(h50,...
'Parent',h48,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496677740863787 -0.116915422885572 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h51 = get(h48,'ylabel');

set(h51,...
'Parent',h48,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0946843853820598 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h52 = get(h48,'zlabel');

set(h52,...
'Parent',h48,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-0.164451827242525 1.17164179104478 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h53 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','LFP_Analyser(''loadcorr_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.847276264591439 0.0798898071625344 0.115758754863813 0.0619834710743802],...
'String','Remove filters',...
'Tag','loadcorr');


h54 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''start_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.707198443579767 0.353994490358127 0.0466926070038911 0.0247933884297521],...
'String','0',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''start_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','start');


h55 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''end1_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.773346303501946 0.352617079889807 0.0466926070038911 0.0261707988980716],...
'String','20',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''end1_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','end1');


h56 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 0 0],...
'Callback','LFP_Analyser(''all_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'FontWeight','bold',...
'ForegroundColor',[1 1 0],...
'ListboxTop',0,...
'Position',[0.800583657587549 0.267217630853995 0.0992217898832685 0.046831955922865],...
'String','Calculate All',...
'Tag','all');


h57 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0 0],...
'Callback','LFP_Analyser(''clear_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'ForegroundColor',[1 1 0],...
'ListboxTop',0,...
'Position',[0.901750972762646 0.267217630853995 0.0651750972762646 0.046831955922865],...
'String','Clear All',...
'Tag','clear');


h58 = uimenu(...
'Parent',h1,...
'Callback','LFP_Analyser(''figures_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Figures',...
'Tag','figures');

h59 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''seg1_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Time Segment 1',...
'Tag','seg1');

h60 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''seg2_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Time Segment 2',...
'Tag','seg2');

h61 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''power1_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Power Spectra 1',...
'Tag','power1');

h62 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''power2_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Power Spectra 2',...
'Tag','power2');

h63 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''spectrogram1_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Spectrogram 1',...
'Tag','spectrogram1');

h64 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''spectrogram2_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Spectrogram 2',...
'Tag','spectrogram2');

h65 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''coefficient1_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Correlation Coefficient 1',...
'Tag','coefficient1');

h66 = uimenu(...
'Parent',h58,...
'Callback','LFP_Analyser(''coefficient2_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Correlation Coefficient 2',...
'Tag','coefficient2');


h67 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'ListboxTop',0,...
'Position',[0.772373540856031 0.399449035812672 0.0486381322957198 0.0220385674931129],...
'String','Length',...
'Style','text',...
'Tag','text2');


h68 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''tstart2_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.844357976653696 0.352617079889807 0.0428015564202335 0.0261707988980716],...
'String','0',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''tstart2_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','tstart2');


h69 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''tend2_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.91147859922179 0.352617079889807 0.0466926070038911 0.0261707988980716],...
'String','20',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''tend2_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','tend2');


h70 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'ListboxTop',0,...
'Position',[0.908560311284046 0.398071625344353 0.051556420233463 0.0220385674931129],...
'String','Length',...
'Style','text',...
'Tag','text3');


h71 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','LFP_Analyser(''pushbutton12_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.757782101167315 0.0785123966942149 0.0885214007782101 0.0316804407713499],...
'String','Filter corr 2',...
'Tag','pushbutton12');


h72 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','LFP_Analyser(''pushbutton13_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.756809338521401 0.112947658402204 0.0894941634241245 0.0316804407713499],...
'String','Filter corr 1',...
'Tag','pushbutton13');


h73 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','LFP_Analyser(''pushbutton14_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.705252918287938 0.399449035812672 0.0622568093385214 0.0413223140495868],...
'String','Open LFP 1',...
'Tag','pushbutton14');


h74 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','LFP_Analyser(''pushbutton15_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.841439688715953 0.399449035812672 0.061284046692607 0.0413223140495868],...
'String','Open LFP 2',...
'Tag','pushbutton15');


h75 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.704280155642023 0.378787878787879 0.0496108949416342 0.0206611570247934],...
'String','Start time',...
'Style','text',...
'Tag','text4');


h76 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.767509727626459 0.377410468319559 0.0505836575875486 0.0206611570247934],...
'String','End time',...
'Style','text',...
'Tag','text5');


h77 = axes(...
'Parent',h1,...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[0.639105058365759 0.0633608815426997 0.0486381322957198 0.318181818181818],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','scale');


h78 = get(h77,'title');

set(h78,...
'Parent',h77,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.49 1.02813852813853 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h79 = get(h77,'xlabel');

set(h79,...
'Parent',h77,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.49 -0.101731601731602 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h80 = get(h77,'ylabel');

set(h80,...
'Parent',h77,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.57 0.495670995670995 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h81 = get(h77,'zlabel');

set(h81,...
'Parent',h77,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-13.15 2.93722943722944 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h82 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.842412451361868 0.37603305785124 0.0496108949416342 0.0206611570247934],...
'String','Start time',...
'Style','text',...
'Tag','text6');


h83 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.905642023346304 0.37603305785124 0.0505836575875486 0.0206611570247934],...
'String','End time',...
'Style','text',...
'Tag','text7');


h84 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.767509727626459 0.421487603305785 0.061284046692607 0.0206611570247934],...
'String','LFP Length',...
'Style','text',...
'Tag','text8');


h85 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.906614785992217 0.421487603305785 0.0593385214007782 0.0206611570247934],...
'String','LFP Length',...
'Style','text',...
'Tag','text9');


h86 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'ListboxTop',0,...
'Position',[0.640077821011673 0.382920110192837 0.0486381322957198 0.0206611570247934],...
'String','High',...
'Style','text',...
'Tag','text10');


h87 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'ListboxTop',0,...
'Position',[0.648832684824903 0.0413223140495868 0.0291828793774319 0.0206611570247934],...
'String','Low',...
'Style','text',...
'Tag','text11');


h88 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit11_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.706225680933852 0.114325068870523 0.0486381322957198 0.0303030303030303],...
'String','0.1',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit11_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit11');


h89 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit12_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.706225680933852 0.081267217630854 0.0486381322957198 0.0289256198347107],...
'String','0.1',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit12_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit12');


h90 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.702334630350195 0.144628099173554 0.26556420233463 0.0206611570247934],...
'String','Threshold values for correlation plots(between 0 and 1)',...
'Style','text',...
'Tag','text13');


h91 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''popupmenu1_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.796692607003892 0.174931129476584 0.0787937743190661 0.0275482093663912],...
'String',{ 'Graph 1' 'Graph 2' 'Graph 3' 'Graph 4' 'Graph 5' 'Graph 6' 'Graph 7' 'Graph 8' 'Graph 9' 'Graph 10'},...
'Style','popupmenu',...
'Value',1,...
'CreateFcn','LFP_Analyser(''popupmenu1_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','popupmenu1');


h92 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.701361867704281 0.0151515151515152 0.26556420233463 0.0523415977961433],...
'String',{ '' },...
'Style','frame',...
'Tag','frame9');


h93 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit13_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.707198443579767 0.0192837465564738 0.0428015564202335 0.0261707988980716],...
'String','0',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit13_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit13');


h94 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit14_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.756809338521401 0.0192837465564738 0.0428015564202335 0.0275482093663912],...
'String','150',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit14_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit14');


h95 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','LFP_Analyser(''pushbutton18_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.80544747081712 0.0261707988980716 0.157587548638132 0.0316804407713499],...
'String','zoom (in/out) of corr plots',...
'Tag','pushbutton18');


h96 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.704280155642023 0.0426997245179063 0.0496108949416342 0.0206611570247934],...
'String','min',...
'Style','text',...
'Tag','min');


h97 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[0 0.501960784313725 1],...
'ListboxTop',0,...
'Position',[0.754863813229572 0.0426997245179063 0.0496108949416342 0.0206611570247934],...
'String','max',...
'Style','text',...
'Tag','text15');


h98 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit15_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.704280155642023 0.272727272727273 0.0379377431906615 0.0234159779614325],...
'String','32',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit15_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit15');


h99 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit16_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.707198443579767 0.323691460055097 0.11284046692607 0.0247933884297521],...
'String','file name',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit16_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit16');


h100 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','LFP_Analyser(''edit17_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[0.844357976653696 0.323691460055097 0.113813229571984 0.0247933884297521],...
'String','file name',...
'Style','edit',...
'CreateFcn','LFP_Analyser(''edit17_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edit17');



hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      LFP_ANALYSER, by itself, creates a new LFP_ANALYSER or raises the existing
%      singleton*.
%
%      H = LFP_ANALYSER returns the handle to a new LFP_ANALYSER or the handle to
%      the existing singleton*.
%
%      LFP_ANALYSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LFP_ANALYSER.M with the given input arguments.
%
%      LFP_ANALYSER('Property','Value',...) creates a new LFP_ANALYSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.4 $ $Date: 2002/05/31 21:44:31 $

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % LFP_ANALYSER
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % LFP_ANALYSER('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % LFP_ANALYSER(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end

