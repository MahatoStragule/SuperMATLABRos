function clear = mainLoop(fig,titleIm,stageNum,zanki,screenSize)
clear = 0;
retire = 0;

imblack = image('XData',[1 screenSize(1)],'YData',[screenSize(2) 1],'CData',zeros(1,1,3));
imblackText = text(screenSize(1)/2,screenSize(2)/2,['Transfer Function : $G_' num2str(stageNum) '(s)$'],'InterPreter','LaTex',...
  'VerticalAlignment','bottom','HorizontalAlignment','Center','Color','w','FontUnits','normalized','FontSize',0.09);%,'FontSize',32
imzankiText = text(screenSize(1)/2,screenSize(2)/2,['   $\times$ ' num2str(zanki) ' '],'InterPreter','LaTex',...
  'VerticalAlignment','Top','HorizontalAlignment','Center','Color','w','FontUnits','normalized','FontSize',0.08);%,'FontSize',28
zankiData = imread('mainChara2.bmp');
zankiAlpha = ((zankiData(:,:,1) ~= 255) + (zankiData(:,:,2) ~= 255) + (zankiData(:,:,3) ~= 255));
imzanki= image('XData',[140 158],'YData',[140 122],'CData',zankiData,'AlphaData',zankiAlpha);
delete(titleIm);
drawnow;
load('bgm/BGMdata.mat','BGMdata');
BGMstage = BGMdata.stage;
BGMclear = BGMdata.clear;
BGMdeath = BGMdata.death;
BGMpause = BGMdata.pause;
%pause(0.5);

vxKey = 0;
drawnow;
currentKey = '';

f = fopen('stage/stageName.txt');
ftext = textscan(f,'%s');
fclose(f);
stageName = ['stage/' ftext{1}{stageNum} '.mat'];
load(stageName,'data');
if ~isfield(data,'timeLimit')
  data.timeLimit = 360;
end

map = Map(data,screenSize,stageNum);

play(BGMstage);
delete([imblack imblackText imzankiText imzanki]);
drawnow;
fig.WindowKeyPressFcn = @wkpf;
fig.WindowKeyReleaseFcn = @wkrf;

while(1)
  tic;
  if ~isvalid(fig)
    break;
  end
  if ~isplaying(BGMstage)
    play(BGMstage)
  end

  if map.checkFall
    map.death2;
    stop(BGMstage);
    play(BGMdeath);
    while(isplaying(BGMdeath))
      pause(0.1);
    end
    pause(0.5);
    return
  end
  if map.mainCharaMove(vxKey)
    stop(BGMstage);
    play(BGMclear);
    map.clear;
    clear = 1;
    pause(0.5);
    %close(fig);
    return
  end
  map.enemyMove
  
  if map.checkDeath
    stop(BGMstage);
    play(BGMdeath);
    map.death;
    while(isplaying(BGMdeath))
      pause(0.1);
    end
    pause(0.5);
    return
  end
  if retire
    stop(BGMstage);
    return
  end
  if map.scroll
    stop(BGMstage);
    play(BGMdeath);
    map.death;
    while(isplaying(BGMdeath))
      pause(0.1);
    end
    pause(0.5);
    %close(fig);
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
      sound(BGMpause.music,BGMpause.fs);
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