function MATLAB_ROS
addpath('./image');
addpath('./bgm');
addpath('./class');
fig = figure('Name','Super MATLAB Bros.','NumberTitle','off');
gsc = get(groot,'ScreenSize');
fig.InnerPosition = [(gsc(3)-gsc(4))/2 gsc(2)+gsc(4)*0.1 gsc(4) gsc(4)*3/4];
set(gca,'Position',[0.1 0.1 0.8 0.8]);
screenSize = [16*24 16*18];
load('bgm/BGMdata.mat','BGMdata');
BGM = BGMdata.title;
BGMgameover = BGMdata.gameover;
while(1)
  if ~isvalid(fig)
    return;
  end
titleIm = image('XData',[1 screenSize(1)],'YData',[screenSize(2) 1],'CData',imread('title.bmp'));
play(BGM);
axis([1 screenSize(1) 1 screenSize(2)]);
fig.WindowKeyReleaseFcn = @wkrfTitle;
drawnow
flag = 1;
while(flag)
  if ~isvalid(fig)
    return;
  end
  if ~isplaying(BGM)
    play(BGM)
  end
  drawnow;
end
stageSelect(fig,titleIm,screenSize,BGM,BGMgameover);
delete(findobj('Type','Image')); 
delete(findobj('Type','Text'));
end

function wkrfTitle(obj,data)
    if strcmp(data.Key,'space') || strcmp(data.Key,'shift')
      flag = 0;
    end
  end
end