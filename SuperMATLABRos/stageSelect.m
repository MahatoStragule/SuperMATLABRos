function stageSelect(fig,titleIm,screenSize,BGM,BGMgameover)
titleIm.CData = imread('stageSelect.bmp');
stage1Text = text(100,180,'$G_1(s)$','InterPreter','LaTex','Color','w','FontUnits','normalized','FontSize',0.07);
stage1Text2 = text(200,182,'easy','FontName','Emulogic','Color','w','FontUnits','normalized','FontSize',0.05);
stage2Text = text(100,150,'$G_2(s)$','InterPreter','LaTex','Color','w','FontUnits','normalized','FontSize',0.07);
stage2Text2 = text(200,152,'normal','FontName','Emulogic','Color','w','FontUnits','normalized','FontSize',0.05);
stage3Text = text(100,120,'$G_3(s)$','InterPreter','LaTex','Color','w','FontUnits','normalized','FontSize',0.07);
stage3Text2 = text(200,120,'hard','FontName','Emulogic','Color','w','FontUnits','normalized','FontSize',0.05);
stage4Text = text(100,90,'$G_4(s)$','InterPreter','LaTex','Color','w','FontUnits','normalized','FontSize',0.07);
stage4Text2 = text(200,90,'very hard','FontName','Emulogic','Color','w','FontUnits','normalized','FontSize',0.05);
cursolData = imread('mainChara2.bmp');
cursolAlpha = ((cursolData(:,:,1) ~= 255) + (cursolData(:,:,2) ~= 255) + (cursolData(:,:,3) ~= 255));
imcursol = image('XData',[64 80],'YData',[188 172],'CData',cursolData,'AlphaData',cursolAlpha);
fig.WindowKeyReleaseFcn = @wkrfStageSelect;
drawnow;
flag = 1;
stageNum = 1;
initflag = 1;
while(flag)
  if ~isvalid(fig)
    return;
  end
  if ~isplaying(BGM)
    play(BGM)
  end
  imcursol.YData = [188 172] - (stageNum-1)*30;
  drawnow;
end
stop(BGM)
zanki = 2;
clear = 0;
initflag = 0;
while(zanki>=0 && clear == 0)
  clear = mainLoop(fig,titleIm,stageNum,zanki,screenSize);
  if ~isvalid(fig)
    return;
  end
  fig.WindowKeyPressFcn = @dummy;
  fig.WindowKeyReleaseFcn = @dummy;
  fig.WindowButtonDownFcn = @dummy;
  axis([1 screenSize(1) 1 screenSize(2)]);
  zanki = zanki-1;
  delete(findobj('Type','Image'));
  delete(findobj('Type','Text'));
end
if clear == 0
  xlim = get(gca,'Xlim');
  ylim = get(gca,'Ylim');
  imblack = image('XData',[xlim(1) xlim(2)],'YData',[ylim(2) ylim(1)],'CData',zeros(1,1,3));
  gameoverText = text((xlim(1)+xlim(2))/2,(ylim(1)+ylim(2))/2,'game over','FontName','Emulogic','FontUnits','normalized','FontSize',0.09,...%32,...
  'HorizontalAlignment','Center','Color','w');
  play(BGMgameover);
  drawnow;
  pause(6);
end

function wkrfStageSelect(obj,data)
  if initflag == 1
    if strcmp(data.Key,'uparrow')
      stageNum = max(stageNum-1,1);
    elseif strcmp(data.Key,'downarrow')
      stageNum = min(stageNum+1,4);
    elseif strcmp(data.Key,'space')
      flag = 0;
    end
  end
end
end

function dummy(obj,data)
end