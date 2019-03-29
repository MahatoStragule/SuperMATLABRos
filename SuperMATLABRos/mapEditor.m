function varargout = mapEditor(varargin)
% MAPEDITOR MATLAB code for mapEditor.fig
%      MAPEDITOR, by itself, creates a new MAPEDITOR or raises the existing
%      singleton*.
%
%      H = MAPEDITOR returns the handle to a new MAPEDITOR or the handle to
%      the existing singleton*.
%
%      MAPEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAPEDITOR.M with the given input arguments.
%
%      MAPEDITOR('Property','Value',...) creates a new MAPEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mapEditor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mapEditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mapEditor

% Last Modified by GUIDE v2.5 14-Mar-2019 14:29:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mapEditor_OpeningFcn, ...
                   'gui_OutputFcn',  @mapEditor_OutputFcn, ...
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


% --- Executes just before mapEditor is made visible.
function mapEditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mapEditor (see VARARGIN)

% Choose default command line output for mapEditor
addpath('image');
handles.output = hObject;


sc = [24 18];
handles.screenSize = sc;
axPos = handles.ax.Position;
axPos(4) = axPos(4)*sc(2)/sc(1)*2;
handles.ax.Position = axPos;
handles.ax.XLim = [0 sc(1)];
handles.ax.XTick = 0:1:sc(1);
handles.ax.YLim = [0 sc(2)];
handles.ax.YTick = 0:1:sc(2);
handles.ax.XGrid = 'on';
handles.ax.YGrid = 'on';
%handles.axMax = [sc(1) sc(2)];

hObject.WindowButtonDownFcn = @wbdf;

handles.mapSize = [1 1];
handles.mapSet = ones(sc(1),sc(2));
handles.mapImData = uint8(zeros(sc(2)*16,sc(1)*16,3));
handles.mapImAlpha = zeros(sc(2)*16,sc(1)*16);
handles.mapIm = image('XData',[0 sc(1)],'YData',[0 sc(2)],'CData',handles.mapImData,'AlphaData',handles.mapImAlpha);

handles.objSet = ones(sc(1),sc(2));
handles.objSetIm = zeros(sc(1),sc(2));

load('imdata.mat','imdata');
handles.imdata = imdata;

handles.mainChara = image('XData',[0 1],'YData',[2 1],'CData',imdata.mainChara);
handles.initPos = [1 2];

handles.goal = image('XData',[22 24],'YData',[18 17],'CData',imdata.goal);

handles.objectSet = ones(sc(1),sc(2));
handles.objectSetIm = zeros(sc(1),sc(2));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mapEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mapEditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupChip.
function popupChip_Callback(hObject, eventdata, handles)
% hObject    handle to popupChip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupChip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupChip


% --- Executes during object creation, after setting all properties.
function popupChip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupChip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ax



function editMapWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editMapWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMapWidth as text
%        str2double(get(hObject,'String')) returns contents of editMapWidth as a double
value = str2double(hObject.String);
sc = handles.screenSize;
if isnan(value)
  hObject.String = num2str(handles.mapSize);
  return
end

value = round(value);
if value < 1
  value = 1;
end
hObject.String = num2str(value);

if value*sc(1) < str2double(handles.editXGoal.String)
  handles.editXGoal.String = num2str(value*sc(1));
  set(handles.goal,'XData',[value*sc(1)-2 value*sc(1)]);
end

if value*sc(1) < str2double(handles.editXInit.String)
  handles.editXInit.String = num2str(value*sc(1));
  set(handles.mainChara,'XData',[value*sc(1)-1 value*sc(1)]);
end


tempMat = handles.mapSet;
[n,m] = size(tempMat);
handles.mapSet = ones(value*sc(1),m);
if n < value*sc(1)
  handles.mapSet(1:n,1:m) = tempMat;
else
  handles.mapSet = tempMat(1:value*sc(1),1:m);  
end
  
tempMat = handles.objSet;
[n,m] = size(tempMat);
handles.objSet = ones(value*sc(1),m);
if n < value*sc(1)
  handles.objSet(1:n,1:m) = tempMat;
else
  handles.objSet = tempMat(1:value*sc(1),1:m);  
end

tempMat = handles.objSetIm;
[n,m] = size(tempMat);
handles.objSetIm = zeros(value*sc(1),m);
if n < value*sc(1)
  handles.objSetIm(1:n,1:m) = tempMat;
else
  deletedMat = tempMat(value*sc(1)+1:n,1:m);
  delete(deletedMat(deletedMat~=0));
  handles.objSetIm = tempMat(1:value*sc(1),1:m);  
end

tempImData = handles.mapImData;
tempImAlpha = handles.mapImAlpha;
[r,c,~] = size(tempImData);
handles.mapImData = uint8(zeros(r,value*sc(1)*16,3));
handles.mapImAlpha = zeros(r,value*sc(1)*16);
if c < value*sc(1)*16
  handles.mapImData(1:r,1:c,:) = tempImData;
  handles.mapImAlpha(1:r,1:c) = tempImAlpha;
else
  handles.mapImData = tempImData(1:r,1:value*sc(1)*16,:);
  handles.mapImAlpha = tempImAlpha(1:r,1:value*sc(1)*16,:);
  if handles.ax.XLim(2) > value*sc(1)
    handles.ax.XLim = [(value-1)*sc(1) value*sc(1)];
    xlim = handles.ax.XLim;
    ylim = handles.ax.YLim;
    xInd = xlim(1)*16+1:xlim(2)*16;
    yInd = ylim(1)*16+1:ylim(2)*16;
    set(handles.mapIm,'XData',xlim,'YData',ylim,'CData',handles.mapImData(yInd,xInd,:),'AlphaData',handles.mapImAlpha(yInd,xInd,:));
    handles.sliderMapScrollX.Value = (value-1)*sc(1);
  end
end

handles.mapSize = value;
%handles.axMax(1) = value*sc(1);
%handles.ax.XTick = 0:1:handles.axMax(1);
handles.ax.XTick = 0:1:value*sc(1);
if value > 1
  handles.sliderMapScrollX.Max = (value-1)*sc(1);
  handles.sliderMapScrollX.SliderStep = [1/(value-1) 1/(value-1)];
  handles.sliderMapScrollX.Enable = 'on';
else
  handles.sliderMapScrollX.Enable = 'off';
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editMapWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMapWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function ax_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function wbdf(fig,~)
if strcmp(fig.SelectionType,'alt')
  addObject(fig);
  return
end

handles = guidata(fig);
cp = handles.ax.CurrentPoint;
cpx = cp(1,1);
cpy = cp(1,2);
%if cpx <  aria(1) || cpx > aria(2) || cpy < aria(3) || cpy > aria(4)
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
if cpx <  xlim(1) || cpx > xlim(2) || cpy < ylim(1) || cpy > ylim(2)
  return
end
x = ceil(cpx);
y = ceil(cpy);
chip = handles.popupChip.Value;
switch handles.popupChip.String{chip}
  case 'Space'
    drawIm = [];
  case 'Block'
    drawIm = handles.imdata.block;
  case 'NeedleUp'
    drawIm = handles.imdata.needleUp;
  case 'NeedleRight'
    drawIm = handles.imdata.needleRight;
  case 'NeedleDown'
    drawIm = handles.imdata.needleDown;
  case 'NeedleLeft'
    drawIm = handles.imdata.needleLeft;
end
fig.WindowButtonMotionFcn = {@wbmf,drawIm};
fig.WindowButtonUpFcn = @wbuf;

startPos = [str2double(handles.editXInit.String) str2double(handles.editYInit.String)];
goalPos = [str2double(handles.editXGoal.String) str2double(handles.editYInit.String)];

if handles.mapSet(x,y) == chip || handles.objSet(x,y) ~= 1 || all(startPos==[x y]) || all(goalPos==[x y]) || all(goalPos-[1 0]==[x y])
  return
end

if isempty(drawIm)
  handles.mapImData((y-1)*16+1:y*16,(x-1)*16+1:x*16,:) = uint8(zeros(16,16,3));
  handles.mapImAlpha((y-1)*16+1:y*16,(x-1)*16+1:x*16) = 0;
else
  handles.mapImData((y-1)*16+1:y*16,(x-1)*16+1:x*16,:) = flip(drawIm,1);
  handles.mapImAlpha((y-1)*16+1:y*16,(x-1)*16+1:x*16) = 1;
end
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
xInd = xlim(1)*16+1:xlim(2)*16;
yInd = ylim(1)*16+1:ylim(2)*16;
handles.mapIm.CData = handles.mapImData(yInd,xInd,:);
handles.mapIm.AlphaData = handles.mapImAlpha(yInd,xInd,:);
handles.mapSet(x,y) = handles.popupChip.Value;
guidata(fig,handles);
drawnow;


function wbmf(fig,~,im)
handles = guidata(fig);
cp = handles.ax.CurrentPoint;
cpx = cp(1,1);
cpy = cp(1,2);
%if cpx <  aria(1) || cpx > aria(2) || cpy < aria(3) || cpy > aria(4)
%  return
%end
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
if cpx <  xlim(1) || cpx > xlim(2) || cpy < ylim(1) || cpy > ylim(2)
  return
end
x = ceil(cpx);
y = ceil(cpy);
chip = handles.popupChip.Value;

startPos = [str2double(handles.editXInit.String) str2double(handles.editYInit.String)];
goalPos = [str2double(handles.editXGoal.String) str2double(handles.editYInit.String)];

if handles.mapSet(x,y) == chip || handles.objSet(x,y) ~= 1 || all(startPos==[x y]) || all(goalPos==[x y]) || all(goalPos-[1 0]==[x y])
  return
end
if isempty(im)
  handles.mapImData((y-1)*16+1:y*16,(x-1)*16+1:x*16,:) = zeros(16,16,3);
  handles.mapImAlpha((y-1)*16+1:y*16,(x-1)*16+1:x*16) = 0;
else
  handles.mapImData((y-1)*16+1:y*16,(x-1)*16+1:x*16,:) = flip(im,1);
  handles.mapImAlpha((y-1)*16+1:y*16,(x-1)*16+1:x*16) = 1;
end
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
xInd = xlim(1)*16+1:xlim(2)*16;
yInd = ylim(1)*16+1:ylim(2)*16;
handles.mapIm.CData = handles.mapImData(yInd,xInd,:);
handles.mapIm.AlphaData = handles.mapImAlpha(yInd,xInd,:);
handles.mapSet(x,y) = chip;
guidata(fig,handles);
drawnow;


function wbuf(fig,~)
fig.WindowButtonMotionFcn = '';
fig.WindowButtonUpFcn = '';

function addObject(fig)
handles = guidata(fig);
cp = handles.ax.CurrentPoint;
cpx = cp(1,1);
cpy = cp(1,2);
%if cpx <  aria(1) || cpx > aria(2) || cpy < aria(3) || cpy > aria(4)
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
if cpx <  xlim(1) || cpx > xlim(2) || cpy < ylim(1) || cpy > ylim(2)
  return
end
x = ceil(cpx);
y = ceil(cpy);

startPos = [str2double(handles.editXInit.String) str2double(handles.editYInit.String)];
goalPos = [str2double(handles.editXGoal.String) str2double(handles.editYInit.String)];
if all(startPos==[x y]) || all(goalPos==[x y]) || all(goalPos-[1 0]==[x y])
%if all(handles.initPos == [x y])
  return
end

object = handles.popupObject.Value;
switch handles.popupObject.String{object}
  case 'NoEnemy'
    drawIm = [];
  case 'EnemyConstantLeft'
    drawIm = handles.imdata.enemyConstant;
  case 'EnemyConstantRight'
    drawIm = flip(handles.imdata.enemyConstant,2);
  case 'EnemySinLeft'
    drawIm = handles.imdata.enemySin;
  case 'EnemySinRight'
    drawIm = flip(handles.imdata.enemySin,2);
  case 'EnemyPulseLeft'
    drawIm = handles.imdata.enemyPulse;
  case 'EnemyPulseRight'
    drawIm = flip(handles.imdata.enemyPulse,2);
  case 'EnemySwitch'
    drawIm = handles.imdata.enemySwitch;
end

if handles.mapSet(x,y) ~= 1 || handles.objSet(x,y) == object
  return
end
if handles.objSetIm(x,y) ~= 0
  delete(handles.objSetIm(x,y));
end
if isempty(drawIm)
  handles.objSetIm(x,y) = 0;
else
  handles.objSetIm(x,y) = image('XData',[x-1 x],'YData',[y y-1],'CData',drawIm);
end
handles.objSet(x,y) = object;

guidata(fig,handles);
drawnow;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = mapFormat(handles);
cd ./stage;
[filename,pathname] = uiputfile('mapData.mat','Save Map Data');
%save('../mapData.mat','data');
save([pathname filename],'data');
cd ../;
disp('save finish');

% --- Executes on selection change in popupObject.
function popupObject_Callback(hObject, eventdata, handles)
% hObject    handle to popupObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupObject contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupObject


% --- Executes during object creation, after setting all properties.
function popupObject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderMapScrollX_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMapScrollX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sc = handles.screenSize;
hObject.Value = round(hObject.Value/sc(1))*sc(1);
handles.ax.XLim = [hObject.Value hObject.Value+sc(1)];
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
handles.mapIm.XData = xlim;
handles.mapIm.YData = ylim;

xInd = xlim(1)*16+1:xlim(2)*16;
yInd = ylim(1)*16+1:ylim(2)*16;
handles.mapIm.CData = handles.mapImData(yInd,xInd,:);
handles.mapIm.AlphaData = handles.mapImAlpha(yInd,xInd,:);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sliderMapScrollX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMapScrollX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editMapHight_Callback(hObject, eventdata, handles)
% hObject    handle to editMapHight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMapHight as text
%        str2double(get(hObject,'String')) returns contents of editMapHight as a double
value = str2double(hObject.String);
sc = handles.screenSize;
if isnan(value)
  hObject.String = num2str(handles.mapSize);
  return
end

value = round(value);
if value < 1
  value = 1;
end
hObject.String = num2str(value);

if value*sc(2) < str2double(handles.editYGoal.String)
  handles.editYGoal.String = num2str(value*sc(2));
  set(handles.goal,'YData',[value*sc(2) value*sc(2)-1]);
end

if value*sc(2) < str2double(handles.editYInit.String)
  handles.editYInit.String = num2str(value*sc(2));
  set(handles.mainChara,'YData',[value*sc(2) value*sc(2)-1]);
end

tempMat = handles.mapSet;
[n,m] = size(tempMat);
handles.mapSet = ones(n,value*sc(2));
if m < value*sc(2)
  handles.mapSet(1:n,1:m) = tempMat;
else
  handles.mapSet = tempMat(1:n,1:value*sc(2));  
end

tempMat = handles.objSet;
[n,m] = size(tempMat);
handles.objSet = ones(n,value*sc(2));
if m < value*sc(2)
  handles.objSet(1:n,1:m) = tempMat;
else
  handles.objSet = tempMat(1:n,1:value*sc(2));  
end

tempMat = handles.objSetIm;
[n,m] = size(tempMat);
handles.objSetIm = zeros(n,value*sc(2));
if m < value*sc(2)
  handles.objSetIm(1:n,1:m) = tempMat;
else
  deletedMat = tempMat(1:n,value*sc(2)+1:m);
  delete(deletedMat(deletedMat~=0));
  handles.objSetIm = tempMat(1:n,1:value*sc(2));  
end

%tempImData = handles.mapImData;
%tempImAlpha = handles.mapImAlpha;
%[r,c,~] = size(tempImData);
tempImData = handles.mapImData;
tempImAlpha = handles.mapImAlpha;
[r,c,~] = size(tempImData);
handles.mapImData = uint8(zeros(value*sc(2)*16,c,3));
handles.mapImAlpha = zeros(value*sc(2)*16,c);
if r < value*sc(2)*16
  handles.mapImData(1:r,1:c,:) = tempImData;
  handles.mapImAlpha(1:r,1:c) = tempImAlpha;
else
  %handles.mapImData = uint8(zeros(value*sc(2)*16,c,3));
  %handles.mapImData(1:r,1:c,:) = tempImData;
  %handles.mapImAlpha=zeros(value*sc(2)*16,c);
  %handles.mapImAlpha(1:r,1:c) = tempImAlpha;
  
  handles.mapImData = tempImData(1:value*sc(2)*16,1:c,:);
  handles.mapImAlpha = tempImAlpha(1:value*sc(2)*16,1:c,:);
  
  if handles.ax.YLim(2) > value*sc(2)
    handles.ax.YLim = [(value-1)*sc(2) value*sc(2)];
    xlim = handles.ax.XLim;
    ylim = handles.ax.YLim;
    xInd = xlim(1)*16+1:xlim(2)*16;
    yInd = ylim(1)*16+1:ylim(2)*16;
    set(handles.mapIm,'XData',xlim,'YData',ylim,'CData',handles.mapImData(yInd,xInd,:),'AlphaData',handles.mapImAlpha(yInd,xInd,:));
    handles.sliderMapScrollY.Value = (value-1)*sc(2);
  end
end
%[n,m] = size(handles.mapSet);
%set(handles.mapIm,'XData',[0 n],'YData',[0 m],'CData',handles.mapImData,'AlphaData',handles.mapImAlpha);

handles.mapSize = value;
%handles.axMax(2) = value*sc(2);
%handles.ax.YTick = 0:1:handles.axMax(2);
handles.ax.YTick = 0:1:value*sc(2);
if value > 1
  handles.sliderMapScrollY.Max = (value-1)*sc(2);
  %handles.sliderMapScrollY.SliderStep = [1/(sc(2)*(value-1)) 1/(value-1)];
  handles.sliderMapScrollY.SliderStep = [1/(value-1) 1/(value-1)];
  handles.sliderMapScrollY.Enable = 'on';
else
  handles.sliderMapScrollY.Enable = 'off';
end

guidata(hObject,handles);


%{
value = str2double(hObject.String);
sc = handles.screenSize;
if isnan(value)
  hObject.String = num2str(handles.mapSize);
  return
end

value = round(value);
if value < 1
  value = 1;
end
hObject.String = num2str(value);

tempMat = handles.mapSet;
[n,m] = size(tempMat);
handles.mapSet = ones(value*sc(1),m);
if n < value*sc(1)
  handles.mapSet(1:n,1:m) = tempMat;
else
  handles.mapSet = tempMat(1:value*sc(1),1:m);  
end
  
tempMat = handles.objSet;
[n,m] = size(tempMat);
handles.objSet = ones(value*sc(1),m);
if n < value*sc(1)
  handles.objSet(1:n,1:m) = tempMat;
else
  handles.objSet = tempMat(1:value*sc(1),1:m);  
end

tempMat = handles.objSetIm;
[n,m] = size(tempMat);
handles.objSetIm = zeros(value*sc(1),m);
if n < value*sc(1)
  handles.objSetIm(1:n,1:m) = tempMat;
else
  handles.objSetIm = tempMat(1:value*sc(1),1:m);  
end

tempImData = handles.mapImData;
tempImAlpha = handles.mapImAlpha;
[r,c,~] = size(tempImData);
handles.mapImData = uint8(zeros(r,value*sc(1)*16,3));
handles.mapImAlpha = zeros(r,value*sc(1)*16);

if c < value*sc(1)*16
  handles.mapImData(1:r,1:c,:) = tempImData;
  handles.mapImAlpha(1:r,1:c) = tempImAlpha;
else
  handles.mapImData = tempImData(1:r,1:value*sc(1)*16,:);
  handles.mapImAlpha = tempImAlpha(1:r,1:value*sc(1)*16,:);
  if handles.ax.XLim(2) > value*sc(1)
    handles.ax.XLim = [(value-1)*sc(1) value*sc(1)];
    handles.axAria(1:2) = handles.ax.XLim;
    xlim = handles.ax.XLim;
    ylim = handles.ax.YLim;
    xInd = xlim(1)*16+1:xlim(2)*16;
    yInd = ylim(1)*16+1:ylim(2)*16;
    set(handles.mapIm,'XData',xlim,'YData',ylim,'CData',handles.mapImData(yInd,xInd,:),'AlphaData',handles.mapImAlpha(yInd,xInd,:));
    handles.sliderMapScrollX.Value = (value-1)*sc(1);
  end
end

handles.mapSize = value;
handles.axMax(1) = value*sc(1);
handles.ax.XTick = 0:1:handles.axMax(1);
if value > 1
  handles.sliderMapScrollX.Max = (value-1)*sc(1);
  handles.sliderMapScrollX.SliderStep = [1/(value-1) 1/(value-1)];
  handles.sliderMapScrollX.Enable = 'on';
else
  handles.sliderMapScrollX.Enable = 'off';
end

guidata(hObject,handles);
%}


% --- Executes during object creation, after setting all properties.
function editMapHight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMapHight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderMapScrollY_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMapScrollY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sc = handles.screenSize;
hObject.Value = round(hObject.Value/sc(2))*sc(2);
handles.ax.YLim = [hObject.Value hObject.Value+sc(2)];
xlim = handles.ax.XLim;
ylim = handles.ax.YLim;
handles.mapIm.XData = xlim;
handles.mapIm.YData = ylim;

xInd = xlim(1)*16+1:xlim(2)*16;
yInd = ylim(1)*16+1:ylim(2)*16;
handles.mapIm.CData = handles.mapImData(yInd,xInd,:);
handles.mapIm.AlphaData = handles.mapImAlpha(yInd,xInd,:);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sliderMapScrollY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMapScrollY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editXInit_Callback(hObject, eventdata, handles)
% hObject    handle to editXInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXInit as text
%        str2double(get(hObject,'String')) returns contents of editXInit as a double
value = str2double(hObject.String);
if isnan(value)
  hObject.String = num2str(handles.initPos(1));
  return
end

value = round(value);
if value < 1
  value = 1;
end
[n,m] = size(handles.mapSet);
if value > n
  value = n;
end
pos = [value str2double(handles.editYInit.String)];
if handles.mapSet(pos(1),pos(2)) ~= 1 || handles.objSet(pos(1),pos(2)) ~= 1
  xpos = handles.mainChara.XData;
  hObject.String = num2str(xpos(2));
  disp('an object has been placed in the same position');
  return
end  
hObject.String = num2str(value);
handles.initPos(1) = value;
set(handles.mainChara,'XData',[value-1 value]);
drawnow;
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function editXInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYInit_Callback(hObject, eventdata, handles)
% hObject    handle to editYInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYInit as text
%        str2double(get(hObject,'String')) returns contents of editYInit as a double
value = str2double(hObject.String);
if isnan(value)
  hObject.String = num2str(handles.initPos(2));
  return
end

value = round(value);
if value < 1
  value = 1;
end
[n,m] = size(handles.mapSet);
if value > m
  value = m;
end
pos = [str2double(handles.editXInit.String) value];
if handles.mapSet(pos(1),pos(2)) ~= 1 || handles.objSet(pos(1),pos(2)) ~= 1
  ypos = handles.mainChara.YData;
  hObject.String = num2str(ypos(1));
  disp('an object has been placed in the same position');
  return
end  
hObject.String = num2str(value);
handles.initPos(2) = value;
set(handles.mainChara,'YData',[value value-1]);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editYInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('.mat','Select the *.mat file');
if ~filename
  return
end

load([pathname filename]);

handles.mapSet = data.mapSet;
delete(handles.objSetIm(handles.objSetIm~=0));
handles.objSet = data.objSet;

sz = size(handles.mapSet);
handles.mapImData =  uint8(zeros(sz(2)*16,sz(1)*16,3));
handles.mapImAlpha =  zeros(sz(2)*16,sz(1)*16);
handles.objSetIm = zeros(sz);

for j = 1:sz(2)
  for i = 1:sz(1)
    switch handles.mapSet(i,j)
      case 1
        drawIm = [];
      case 2
        drawIm = handles.imdata.block;
      case 3
        drawIm = handles.imdata.needleUp;
      case 4
        drawIm = handles.imdata.needleRight;
      case 5
        drawIm = handles.imdata.needleDown;
      case 6
        drawIm = handles.imdata.needleLeft;
      case -2
        drawIm = handles.imdata.enemyConstant;
      case -3
        drawIm = flip(handles.imdata.enemyConstant,2);
      case -4
        drawIm = handles.imdata.enemySin;
      case -5
        drawIm = flip(handles.imdata.enemySin,2);
      case -6
        drawIm = handles.imdata.enemyPulse;
      case -7
        drawIm = flip(handles.imdata.enemyPulse,2);
      case -8
        drawIm = handles.imdata.enemySwitch;
    end
    if isempty(drawIm)
      handles.mapImData((j-1)*16+1:j*16,(i-1)*16+1:i*16,:) = uint8(zeros(16,16,3));
      handles.mapImAlpha((j-1)*16+1:j*16,(i-1)*16+1:i*16) = 0;
    else
      handles.mapImData((j-1)*16+1:j*16,(i-1)*16+1:i*16,:) = flip(drawIm,1);
      handles.mapImAlpha((j-1)*16+1:j*16,(i-1)*16+1:i*16) = 1;
    end
    xlim = [0 24];
    ylim = [0 18];
    xInd = xlim(1)*16+1:xlim(2)*16;
    yInd = ylim(1)*16+1:ylim(2)*16;
    handles.mapIm.CData = handles.mapImData(yInd,xInd,:);
    handles.mapIm.AlphaData = handles.mapImAlpha(yInd,xInd,:);
    
    switch handles.objSet(i,j)
      case 1
        drawIm = [];
      case 2
        drawIm = handles.imdata.enemyConstant;
      case 3
        drawIm = flip(handles.imdata.enemyConstant,2);
      case 4
        drawIm = handles.imdata.enemySin;
      case 5
        drawIm = flip(handles.imdata.enemySin,2);
      case 6
        drawIm = handles.imdata.enemyPulse;
      case 7
        drawIm = flip(handles.imdata.enemyPulse,2);
      case 8
        drawIm = handles.imdata.enemySwitch;
    end
    
    if isempty(drawIm)
      handles.objSetIm(i,j) = 0;
    else
      handles.objSetIm(i,j) = image('XData',[i-1 i],'YData',[j j-1],'CData',drawIm);
    end    
  end
end

%data.enemySet = cell(pagexMax,pageyMax);

sc = handles.screenSize;
pagexMax = ceil((sz(1)-1)/sc(1));
pageyMax = ceil((sz(2)-1)/sc(2));

%handles.axMax = sz;
%handles.ax.XTick = 0:1:handles.axMax(1);
%handles.ax.YTick = 0:1:handles.axMax(2);
handles.ax.XTick = 0:1:sz(1);
handles.ax.YTick = 0:1:sz(2);

editMapWidth = findobj('Tag','editMapWidth');
editMapWidth.String = num2str(pagexMax);
if pagexMax > 1
  handles.sliderMapScrollX.Max = sz(1)-sc(1);
  handles.sliderMapScrollX.Value = 1;
  %handles.sliderMapScrollX.SliderStep = [1/(sz(1)-sc(1)) 1/(pagexMax-1)];
  handles.sliderMapScrollX.SliderStep = [1/(pagexMax-1) 1/(pagexMax-1)];
  handles.sliderMapScrollX.Enable = 'on';
else
  handles.sliderMapScrollX.Enable = 'off';
end

editMapHight = findobj('Tag','editMapHight');
editMapHight.String = num2str(pageyMax);
if pageyMax > 1
  handles.sliderMapScrollY.Max = sz(2)-sc(2);
  handles.sliderMapScrollY.Value = 1;
  handles.sliderMapScrollY.SliderStep = [1/(pageyMax-1) 1/(pageyMax-1)];
  handles.sliderMapScrollY.Enable = 'on';
else
  handles.sliderMapScrollY.Enable = 'off';
end

%editXInit = findobj('Tag','editXInit');
%editYInit = findobj('Tag','editYInit');

handles.editXInit.String = num2str(data.initPos(1));
handles.editYInit.String = num2str(data.initPos(2));
handles.initPos = data.initPos;
set(handles.mainChara,'XData',[data.initPos(1)-1 data.initPos(1)],'YData',[data.initPos(2) data.initPos(2)-1]);
if isfield(data,'goalPos')
  %editXGoal = findobj('Tag','editXGoal');
  %editYGoal = findobj('Tag','editYGoal');
  handles.editXGoal.String = num2str(data.goalPos(1));
  handles.editYGoal.String = num2str(data.goalPos(2));
else
  data.goalPos = [str2double(handles.editXGroal.String) str2double(handles.editYGroal.String)];
end
set(handles.goal,'XData',[data.goalPos(1)-2 data.goalPos(1)],'YData',[data.goalPos(2) data.goalPos(2)-1]);

if isfield(data,'timeLimit')
  handles.editTimeLimit.String = num2str(data.timeLimit);
end

guidata(hObject,handles);



function editXGoal_Callback(hObject, eventdata, handles)
% hObject    handle to editXGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXGoal as text
%        str2double(get(hObject,'String')) returns contents of editXGoal as a double
value = str2double(hObject.String);
if isnan(value)
  xpos = handles.goal.XData;
  hObject.String = num2str(xpos(2));
  return
end

value = round(value);
if value < 2
  value = 2;
end
[n,m] = size(handles.mapSet);
if value > n
  value = n;
end
pos = [value str2double(handles.editYGoal.String)];
if any(handles.mapSet(pos(1)-1:pos(1),pos(2)) ~= 1) || any(handles.objSet(pos(1)-1:pos(1),pos(2)) ~= 1)
  xpos = handles.goal.XData;
  hObject.String = num2str(xpos(2));
  disp('an object has been placed in the same position');
  return
end  

hObject.String = num2str(value);
set(handles.goal,'XData',[value-2 value]);
drawnow;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editXGoal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYGoal_Callback(hObject, eventdata, handles)
% hObject    handle to editYGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYGoal as text
%        str2double(get(hObject,'String')) returns contents of editYGoal as a double
value = str2double(hObject.String);
if isnan(value)
  ypos = handles.goal.YData;
  hObject.String = num2str(ypos(1));
  return
end

value = round(value);
if value < 1
  value = 1;
end
[n,m] = size(handles.mapSet);
if value > m
  value = m;
end

pos = [str2double(handles.editXGoal.String) value];
if any(handles.mapSet(pos(1)-1:pos(1),pos(2)) ~= 1) || any(handles.objSet(pos(1)-1:pos(1),pos(2)) ~= 1)
  ypos = handles.goal.YData;
  hObject.String = num2str(ypos(1));
  disp('an object has been placed in the same position');
  return
end  

hObject.String = num2str(value);
set(handles.goal,'YData',[value value-1]);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editYGoal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = mapFormat(handles);
testPlay(data);


function data = mapFormat(handles)
data.initPos = handles.initPos;
goalx = str2double(handles.editXGoal.String);
goaly = str2double(handles.editYGoal.String);
data.goalPos = [goalx goaly];
data.mapSet = handles.mapSet;
data.objSet = handles.objSet;
[n,m] = size(handles.mapSet);
data.mapSetChip = cell(n,m);
pagexMax = floor((n-1)/handles.screenSize(1))+1;
pageyMax = floor((m-1)/handles.screenSize(2))+1;
data.enemySet = cell(pagexMax,pageyMax);
data.timeLimit = str2double(handles.editTimeLimit.String);

for j = 1:pageyMax
  for i = 1:pagexMax
    data.enemySet{i,j} = {};
  end
end

for j = 1:m
  for i = 1:n
    pagex = floor((i-1)/handles.screenSize(1))+1;
    pagey = floor((j-1)/handles.screenSize(2))+1;
    switch handles.mapSet(i,j)
      case 1
        data.mapSetChip{i,j} = Space(i,j);
      case 2
        data.mapSetChip{i,j} = Block(i,j);
      case 3
        data.mapSetChip{i,j} = Needle(i,j,1);
      case 4
        data.mapSetChip{i,j} = Needle(i,j,2);
      case 5
        data.mapSetChip{i,j} = Needle(i,j,3);
      case 6
        data.mapSetChip{i,j} = Needle(i,j,4);
        %{
      case -2
        data.mapSetChip{i,j} = Space(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyConstant(i,j,-1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case -3
        data.mapSetChip{i,j} = Space(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyConstant(i,j,1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case -4
        data.mapSetChip{i,j} = Space(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemySin(i,j,-1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case -5
        data.mapSetChip{i,j} = Space(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemySin(i,j,1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case -6
        data.mapSetChip{i,j} = Block(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyPulse(i,j,-1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case -7
        data.mapSetChip{i,j} = Block(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyPulse(i,j,1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case -8
        data.mapSetChip{i,j} = Space(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemySwitch(i,j,num);
        data.enemySet{pagex,pagey} = enemyArray;
        %}
    end
    switch handles.objSet(i,j)
      case 2
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyConstant(i,j,-1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case 3
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyConstant(i,j,1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case 4
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemySin(i,j,-1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case 5
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemySin(i,j,1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case 6
        data.mapSetChip{i,j} = Block(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyPulse(i,j,-1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case 7
        data.mapSetChip{i,j} = Block(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemyPulse(i,j,1,num);
        data.enemySet{pagex,pagey} = enemyArray;
      case 8
        data.mapSetChip{i,j} = Space(i,j);
        enemyArray = data.enemySet{pagex,pagey};
        num = length(enemyArray)+1;
        enemyArray{num} = EnemySwitch(i,j,num);
        data.enemySet{pagex,pagey} = enemyArray;
    end
  end
end



function editTimeLimit_Callback(hObject, eventdata, handles)
% hObject    handle to editTimeLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTimeLimit as text
%        str2double(get(hObject,'String')) returns contents of editTimeLimit as a double
value = str2double(hObject.String);
if isnan(value)
  hObject.String = num2str(180);
  return
end

value = round(value);
if value < 1
  value = 180;
end
hObject.String = num2str(value);


% --- Executes during object creation, after setting all properties.
function editTimeLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTimeLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
