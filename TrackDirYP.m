function varargout = TrackDirYP(varargin)

global x


% TRACKDIRYP M-file for TrackDirYP.fig
%      TRACKDIRYP, by itself, creates a new TRACKDIRYP or raises the existing
%      singleton*.
%
%      H = TRACKDIRYP returns the handle to a new TRACKDIRYP or the handle to
%      the existing singleton*.
%
%      TRACKDIRYP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKDIRYP.M with the given input arguments.
%
%      TRACKDIRYP('Property','Value',...) creates a new TRACKDIRYP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrackDirYP_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrackDirYP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% Edit the above text to modify the response to help TrackDirYP

% Last Modified by GUIDE v2.5 02-May-2008 14:12:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrackDirYP_OpeningFcn, ...
                   'gui_OutputFcn',  @TrackDirYP_OutputFcn, ...
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


% --- Executes just before TrackDirYP is made visible.
function TrackDirYP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrackDirYP (see VARARGIN)

% Choose default command line output for TrackDirYP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrackDirYP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrackDirYP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function WinSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: WinSlider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on WinSlider movement.
function WinSlider_Callback(hObject, eventdata, handles)
% hObject    handle to WinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of WinSlider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of WinSlider



function TableEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TableEntry_Callback(hObject, eventdata, handles)
% hObject    handle to TableEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TableEntry as text
%        str2double(get(hObject,'String')) returns contents of TableEntry as a double
global x
indx = get( x.handles.TableEntry,'Value');
spikes = get_sp_list( x.table, indx);
set(x.handles.SpikeEntry, 'String', spikes);
set(x.handles.SpikeEntry, 'Value', 1);

tableindx = get(x.handles.TableEntry,'Value');
spikeindx = get(x.handles.SpikeEntry,'Value');
includestring = get_include_field( x.table, tableindx, spikeindx);
set( x.handles.IncludeTag,'String', includestring);


% --- Executes during object creation, after setting all properties.
function SpikeEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global x

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
tableindx = get(x.handles.TableEntry,'Value');
spikeindx = get(x.handles.SpikeEntry,'Value');
includestring = get_include_field( x.table, tableindx, spikeindx);
set( x.handles.IncludeTag,'String', includestring);



function SpikeEntry_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SpikeEntry as text
%        str2double(get(hObject,'String')) returns contents of SpikeEntry as a double


% --- Executes on button press in LoadSpikes.
function LoadSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function PreGo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PreGo_Callback(hObject, eventdata, handles)
% hObject    handle to PreGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreGo as text
%        str2double(get(hObject,'String')) returns contents of PreGo as a double


% --- Executes during object creation, after setting all properties.
function PostGo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PostGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PostGo_Callback(hObject, eventdata, handles)
% hObject    handle to PostGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PostGo as text
%        str2double(get(hObject,'String')) returns contents of PostGo as a double


% --- Executes during object creation, after setting all properties.
function step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function step_Callback(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step as text
%        str2double(get(hObject,'String')) returns contents of step as a double


% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function window_Callback(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window as text
%        str2double(get(hObject,'String')) returns contents of window as a double


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function PreCue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreCue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PreCue_Callback(hObject, eventdata, handles)
% hObject    handle to PreCue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreCue as text
%        str2double(get(hObject,'String')) returns contents of PreCue as a double


% --- Executes during object creation, after setting all properties.
function PostCue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PostCue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PostCue_Callback(hObject, eventdata, handles)
% hObject    handle to PostCue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PostCue as text
%        str2double(get(hObject,'String')) returns contents of PostCue as a double


% --- Executes on selection change in TableEntry.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to TableEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TableEntry contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TableEntry


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TableEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in SpikeEntry.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SpikeEntry contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SpikeEntry


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in MonkeySel.
function MonkeySel_Callback(hObject, eventdata, handles)
% hObject    handle to MonkeySel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns MonkeySel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MonkeySel
global x
monkeyindx = get(x.handles.MonkeySel,'Value');
[x.table, names] = get_table( monkeyindx );
set( x.handles.TableEntry,'String', names);
set( x.handles.TableEntry,'Value', 1);
spikes = get_sp_list( x.table, 1);
set(x.handles.SpikeEntry, 'String', spikes);
set(x.handles.SpikeEntry, 'Value', 1);

tableindx = get(x.handles.TableEntry,'Value');
spikeindx = get(x.handles.SpikeEntry,'Value');
includestring = get_include_field( x.table, tableindx, spikeindx);
set( x.handles.IncludeTag,'String', includestring);


% --- Executes during object creation, after setting all properties.
function MonkeySel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonkeySel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


