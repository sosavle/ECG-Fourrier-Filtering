function varargout = ECG_Filter(varargin)
% ECG_FILTER MATLAB code for ECG_Filter.fig
%      ECG_FILTER, by itself, creates a new ECG_FILTER or raises the existing
%      singleton*.
%
%      H = ECG_FILTER returns the handle to a new ECG_FILTER or the handle to
%      the existing singleton*.
%
%      ECG_FILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECG_FILTER.M with the given input arguments.
%
%      ECG_FILTER('Property','Value',...) creates a new ECG_FILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECG_Filter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECG_Filter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ECG_Filter

% Last Modified by GUIDE v2.5 09-Nov-2019 17:02:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECG_Filter_OpeningFcn, ...
                   'gui_OutputFcn',  @ECG_Filter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ECG_Filter is made visible.
function ECG_Filter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECG_Filter (see VARARGIN)

% Choose default command line output for ECG_Filter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
warning('off','all');

% UIWAIT makes ECG_Filter wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ECG_Filter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%
function RedrawFilter(mode)
global signal;
global fs;
global t;
global threshold;
global lower;
global upper;

trans = fft(signal);
N = length(trans);


if mode == 1        
    trans(threshold+1:(end-threshold))=0;
elseif mode == 2
    trans(1:threshold+1) = 0;
    trans((end-threshold+1):end) = 0;
elseif mode == 3
    trans(1:lower+1) = 0;
    trans(upper+1:end) = 0;
end


filto = ifft(trans);
hold off;
plot(t,signal);
hold on;

% Asjust vertical transform position
if mode == 2 || mode == 3
    adjust = -63.9844;
elseif mode == 1 && threshold == 0
    adjust = -63.9844;
else
    adjust = 0;
end


plot(t,real(filto) + adjust);
xlabel('Time in milliseconds');
ylabel('Voltage in millivolts');
return

%%


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% File Browsing
[file, path] = uigetfile('*.mat');
directory = fullfile(path,file);
set(handles.directory, 'string', directory);

% Obtaining and plotting signal
load(directory);
global signal;
signal = val(1,:);
global fs;
fs = length(signal)/10;
global t;
t=linspace(0,10000,length(signal));
plot(t,signal);
xlabel('Time in milliseconds');
ylabel('Voltage in millivolts');
set(handles.browse,'UserData',1); 
if get(handles.filterFlag,'UserData')
RedrawFilter(get(handles.filterFlag,'UserData'));
end



% --- Executes on button press in lowPass.
function lowPass_Callback(hObject, eventdata, handles)
% hObject    handle to lowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lowPass

% Radio Button Functionality
set(handles.lowPass,'Value',1);
set(handles.highPass,'Value',0);
set(handles.bandPass,'Value',0);

% Communicates to the GUI a filtering option has been selected
set(handles.filterFlag,'UserData',1);

% Disables functions relevant only to band filtering
set(handles.lowerBound, 'Enable', 'off')
set(handles.upperBound, 'Enable', 'off')
set(handles.thresholdDisp, 'Enable', 'on')
set(handles.thresholdSlider, 'Enable', 'on')

% Only attempts a transform if a file has been browsed for
if get(handles.browse,'UserData')
RedrawFilter(1);
end


% --- Executes on button press in highPass.
function highPass_Callback(hObject, eventdata, handles)
% hObject    handle to highPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of highPass
set(handles.lowPass,'Value',0);
set(handles.highPass,'Value',1);
set(handles.bandPass,'Value',0);

set(handles.filterFlag,'UserData',2);
set(handles.lowerBound, 'Enable', 'off')
set(handles.upperBound, 'Enable', 'off')
set(handles.thresholdDisp, 'Enable', 'on')
set(handles.thresholdSlider, 'Enable', 'on')

if get(handles.browse,'UserData')
RedrawFilter(2);
end

% --- Executes on button press in bandPass.
function bandPass_Callback(hObject, eventdata, handles)
% hObject    handle to bandPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandPass
set(handles.lowPass,'Value',0);
set(handles.highPass,'Value',0);
set(handles.bandPass,'Value',1);

set(handles.filterFlag,'UserData',3);
set(handles.lowerBound, 'Enable', 'on')
set(handles.upperBound, 'Enable', 'on')
set(handles.thresholdDisp, 'Enable', 'off')
set(handles.thresholdSlider, 'Enable', 'off')

if get(handles.browse,'UserData')
RedrawFilter(3);
end


function thresholdDisp_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdDisp as text
%        str2double(get(hObject,'String')) returns contents of thresholdDisp as a double
global threshold;

thresholdStr = get(handles.thresholdDisp, 'String');
threshold = str2double(thresholdStr);

% Maximum Frequency has been arbitrarily set to 500
sliderPos = threshold./500;

% Avoids slider overflow and weird behavior with non numerical values
if sliderPos > 1
    sliderPos =1;
elseif isnan(sliderPos)
return
end

% Links display to slider
set(handles.thresholdSlider,'Value', sliderPos);

% Redraws only given the user has browsed for a file and selected a filter
if get(handles.filterFlag,'UserData') && get(handles.browse,'UserData')
RedrawFilter(get(handles.filterFlag,'UserData'));
end

% --- Executes during object creation, after setting all properties.
function thresholdDisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global threshold;
threshold = get(handles.thresholdSlider,'Value')*500;
set(handles.thresholdDisp,'String', num2str(threshold));
if get(handles.filterFlag,'UserData') && get(handles.browse,'UserData')
RedrawFilter(get(handles.filterFlag,'UserData'));

end

% --- Executes during object creation, after setting all properties.
function thresholdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function lowerBound_Callback(hObject, eventdata, handles)
% hObject    handle to lowerBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowerBound as text
%        str2double(get(hObject,'String')) returns contents of lowerBound as a double
global lower;
lower = str2double(get(handles.lowerBound,'String'));
if get(handles.filterFlag,'UserData') && get(handles.browse,'UserData')
RedrawFilter(get(handles.filterFlag,'UserData'))
end

% --- Executes during object creation, after setting all properties.
function lowerBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upperBound_Callback(hObject, eventdata, handles)
% hObject    handle to upperBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upperBound as text
%        str2double(get(hObject,'String')) returns contents of upperBound as a double
global upper;
upper = str2double(get(handles.upperBound,'String'));
if get(handles.filterFlag,'UserData') && get(handles.browse,'UserData')
RedrawFilter(get(handles.filterFlag,'UserData'))
end


% --- Executes during object creation, after setting all properties.
function upperBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
