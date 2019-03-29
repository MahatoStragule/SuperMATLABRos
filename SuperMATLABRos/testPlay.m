function clear = testPlay(data)
addpath('./image');
addpath('./bgm');
addpath('./class');

clear = 0;
retire = 0;
fig = figure('Name','Test Play','NumberTitle','off');
gsc = get(groot,'ScreenSize');
fig.InnerPosition = [(gsc(3)-gsc(4))/2 gsc(2)+gsc(4)*0.1 gsc(4) gsc(4)*3/4];
set(gca,'Position',[0.1 0.1 0.8 0.8]);
screenSize = [16*24 16*18];

vxKey = 0;
drawnow;
currentKey = '';

stageNum = 1;
map = Map(data,screenSize,stageNum);


drawnow;
fig.WindowKeyPressFcn = @wkpf;
fig.WindowKeyReleaseFcn = @wkrf;

while(1)
  tic;
  if ~isvalid(fig)
    break;
  end
  if map.checkFall
    map.death2;
    pause(2);
    close(fig);
    return
  end

  if map.mainCharaMove(vxKey)
    map.clear;
    clear = 1;
    pause(0.5);
    close(fig);
    return
  end
  map.enemyMove
  
  if map.checkDeath
    map.death;
    pause(2.0);
    close(fig);
    return
  end
  if retire
    close(fig);
    return
  end
  if map.scroll
    map.death;
    pause(2.0);
    close(fig);
    return                        
  end
  drawnow;
  timeval = toc;
  if timeval < 0.04
    pause(0.04-timeval);
  end  
end

  function wkpf(obj,data)
    switch data.Key
      case 'rightarrow'
        currentKey = data.Key;
        vxKey = 0.5;
      case 'leftarrow'
        currentKey = data.Key;
        vxKey = -0.5;
      case 'space'
        map.jumpKeyDown;
    end
  end

  function wkrf(obj,data)
    if strcmp(data.Key,currentKey)
      vxKey = 0;
    elseif strcmp(data.Key,'space')
      map.jumpKeyUp;
    elseif strcmp(data.Key,'shift')
%      sound(BGMpause.music,BGMpause.fs);
      xlim = get(gca,'Xlim');
      ylim = get(gca,'Ylim');
      textPause = text((xlim(2)+xlim(1))/2,(ylim(1)+ylim(2))/2,'pause','FontName','Emulogic','Color','w',...
        'HorizontalAlignment','center','FontUnits','normalized','FontSize',0.1);%,'FontSize',36
      wkpf = obj.WindowKeyPressFcn;
      obj.WindowKeyPressFcn = '';
      obj.WindowKeyReleaseFcn = @pause;
      reset = 0;
      count = 0;
      drawnow;
      while(1)
        if ~isvalid(obj)
          break;
        end
        if reset == 1
          obj.WindowKeyReleaseFcn = @wkrf;
          obj.WindowKeyPressFcn = wkpf;
          delete(textPause);
          break;
        elseif reset == 2
          delete(textPause);
          clear = 1;
          retire = 1;
          return;
        end
        drawnow;
      end
    end
    
    function pause(obj,data)
      if strcmp(data.Key,'shift')
        reset = 1;
      elseif strcmp(data.Key,'space')
        if count < 1
          count = count + 1;
          textPause.String = 'go to title?';
        else
          reset = 2;
        end
      end
    end
  end
end