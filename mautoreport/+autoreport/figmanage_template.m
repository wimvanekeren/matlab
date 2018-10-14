function varargout = figmanage_template(varargin)
%FIGMANAGE_TEMPLATE M-file for figmanage_template.fig
%      FIGMANAGE_TEMPLATE, by itself, creates a new FIGMANAGE_TEMPLATE or raises the existing
%      singleton*.
%
%      H = FIGMANAGE_TEMPLATE returns the handle to a new FIGMANAGE_TEMPLATE or the handle to
%      the existing singleton*.
%
%      FIGMANAGE_TEMPLATE('Property','Value',...) creates a new FIGMANAGE_TEMPLATE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to figmanage_template_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FIGMANAGE_TEMPLATE('CALLBACK') and FIGMANAGE_TEMPLATE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FIGMANAGE_TEMPLATE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help figmanage_template

% Last Modified by GUIDE v2.5 29-Dec-2015 17:59:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @figmanage_template_OpeningFcn, ...
                   'gui_OutputFcn',  @figmanage_template_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before figmanage_template is made visible.
function figmanage_template_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for figmanage_template
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes figmanage_template wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = figmanage_template_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_savepath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_savepath as text
%        str2double(get(hObject,'String')) returns contents of edit_savepath as a double


% --- Executes during object creation, after setting all properties.
function edit_savepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_description_Callback(hObject, eventdata, handles)
% hObject    handle to edit_description (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_description as text
%        str2double(get(hObject,'String')) returns contents of edit_description as a double


% --- Executes during object creation, after setting all properties.
function edit_description_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_description (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_reporttag_Callback(hObject, eventdata, handles)
% hObject    handle to edit_reporttag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_reporttag as text
%        str2double(get(hObject,'String')) returns contents of edit_reporttag as a double


% --- Executes during object creation, after setting all properties.
function edit_reporttag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_reporttag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
% hObject    handle to button_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_reporttitle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_reporttitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_reporttitle as text
%        str2double(get(hObject,'String')) returns contents of edit_reporttitle as a double


% --- Executes during object creation, after setting all properties.
function edit_reporttitle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_reporttitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_author_Callback(hObject, eventdata, handles)
% hObject    handle to edit_author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_author as text
%        str2double(get(hObject,'String')) returns contents of edit_author as a double


% --- Executes during object creation, after setting all properties.
function edit_author_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_default.
function button_default_Callback(hObject, eventdata, handles)
% hObject    handle to button_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in check_open.
function check_open_Callback(hObject, eventdata, handles)
% hObject    handle to check_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_open


% --- Executes on button press in check_keeppaperpos.
function check_keeppaperpos_Callback(hObject, eventdata, handles)
% hObject    handle to check_keeppaperpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_keeppaperpos


% --- Executes on button press in check_savews.
function check_savews_Callback(hObject, eventdata, handles)
% hObject    handle to check_savews (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_savews


% --- Executes on button press in check_linewidth.
function check_linewidth_Callback(hObject, eventdata, handles)
% hObject    handle to check_linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_linewidth



function edit_linewidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_linewidth as text
%        str2double(get(hObject,'String')) returns contents of edit_linewidth as a double


% --- Executes during object creation, after setting all properties.
function edit_linewidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_linewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
