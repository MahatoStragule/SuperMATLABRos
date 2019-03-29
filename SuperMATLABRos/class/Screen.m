classdef Screen < handle
  properties
    xlim_;
    ylim_;
    map_;
    sc_;
    page_;
    mapSize_;
    
    initTime_;
    time_;
    textScore_;
    textScoreValue_;
    textTime_;
    textTimeValue_;
    textStage_;
    textStageName_;
    tic_;
    panorama_;
    topScore_ = 0;
  end
  methods
    function obj = Screen(screenSize,initpage,mapSize,map,panorama,stageNum,time)
      obj.sc_ = screenSize;
      obj.mapSize_ = mapSize;
      obj.xlim_ = [1 screenSize(1)]+(initpage(1)-1)*screenSize(1);
      obj.ylim_ = [1 screenSize(2)]+(initpage(2)-1)*screenSize(2);
      axis([obj.xlim_ obj.ylim_]);
      %set(gca,'XTick',0:16:screenSize(1),'YTick',0:16:screenSize(2));
      obj.map_ = map;
      obj.page_ = initpage;
      map.enemyAppear(obj.page_);
      offset = [(initpage(1)-1)*screenSize(1) (initpage(2)-1)*screenSize(2)];
      obj.textScore_ = text(64+offset(1),272+offset(2),'Gain Margin','Color','w','HorizontalAlignment','Center','FontUnits','normalized','FontSize',0.05);%,'FontSize',16
      obj.textScoreValue_ = text(64+offset(1),256+offset(2),'00000','Color','w','HorizontalAlignment','Center','FontUnits','normalized','FontSize',0.05);
      obj.textTime_ = text(320+offset(1), 272+offset(2),'Phase Margin','HorizontalAlignment','Center','Color','w','FontUnits','normalized','FontSize',0.05);
      obj.textTimeValue_ = text(320+offset(1), 256+offset(2),[num2str(time) '\circ'],'HorizontalAlignment','Center','Color','w','FontUnits','normalized','FontSize',0.05);
      obj.textStage_ = text(192+offset(1), 272+offset(2),'Transfer Function','HorizontalAlignment','Center','Color','w','FontUnits','normalized','FontSize',0.05);
      obj.textStageName_ = text(192+offset(1), 256+offset(2),['$G_' num2str(stageNum) '(s)$'],'InterPreter','LaTex','HorizontalAlignment','Center','Color','w','FontUnits','normalized','FontSize',0.05);
      obj.tic_ = tic;
      obj.panorama_ = panorama;
      obj.initTime_ = time;
      obj.time_ = time;
    end
    function [flag,page,death] = scroll(obj,xpos,ypos)
      flag = 0;
      death = 0;
      direction = [0 0];
      if obj.xlim_(1) > (xpos(1)+xpos(2))/2 && (xpos(1)+xpos(2))/2 > 0
        obj.xlim_ = obj.xlim_ - obj.sc_(1);
        obj.page_ = [obj.xlim_(2)/obj.sc_(1) obj.ylim_(2)/obj.sc_(2)];
        set(gca,'XLim',obj.xlim_);
        flag = 1;
        direction = [-1 0];
      elseif obj.xlim_(2) < (xpos(1)+xpos(2))/2 && (xpos(1)+xpos(2))/2 < obj.mapSize_(1)*16
        obj.xlim_ = obj.xlim_ + obj.sc_(1);
        obj.page_ = [obj.xlim_(2)/obj.sc_(1) obj.ylim_(2)/obj.sc_(2)];
        set(gca,'XLim',obj.xlim_);
        flag = 1;
        direction = [1 0];
      end
      if obj.ylim_(1) > (ypos(1)+ypos(2))/2 && (ypos(1)+ypos(2))/2 > 0
        obj.ylim_ = obj.ylim_ - obj.sc_(2);
        obj.page_ = [obj.xlim_(2)/obj.sc_(1) obj.ylim_(2)/obj.sc_(2)];
        set(gca,'YLim',obj.ylim_);
        flag = 1;
        direction = [0 -1];
      elseif obj.ylim_(2) < (ypos(1)+ypos(2))/2 && (ypos(1)+ypos(2))/2 <= obj.mapSize_(2)*16
        obj.ylim_ = obj.ylim_ + obj.sc_(2);
        obj.page_ = [obj.xlim_(2)/obj.sc_(1) obj.ylim_(2)/obj.sc_(2)];
        set(gca,'YLim',obj.ylim_);
        flag = 1;
        direction = [0 1];
      end
      page = obj.page_;
      if flag
        obj.map_.mapChipUpdata(direction);
        obj.objectScroll(direction);
      end
      
      time = ceil(obj.initTime_-toc(obj.tic_));
      if time < 0
        death = 1;
      end
      if time ~= obj.time_
        obj.time_ = time;
        timeString = num2str(time,'%03g');
        obj.textTimeValue_.String = [timeString '\circ'];
      end
    end
    
    function objectScroll(obj,scDirection)
      obj.textTime_.Position = obj.textTime_.Position + [scDirection.*obj.sc_ 0];
      uistack(obj.textTime_,'top');
      obj.textTimeValue_.Position = obj.textTimeValue_.Position + [scDirection.*obj.sc_ 0];
      uistack(obj.textTimeValue_,'top');
      obj.textScore_.Position = obj.textScore_.Position + [scDirection.*obj.sc_ 0];
      uistack(obj.textScore_,'top');
      obj.textScoreValue_.Position = obj.textScoreValue_.Position + [scDirection.*obj.sc_ 0];
      uistack(obj.textScoreValue_,'top');
      obj.textStage_.Position = obj.textStage_.Position + [scDirection.*obj.sc_ 0];
      uistack(obj.textStage_,'top');
      obj.textStageName_.Position = obj.textStageName_.Position + [scDirection.*obj.sc_ 0];
      uistack(obj.textStageName_,'top');
      obj.panorama_.XData = obj.panorama_.XData + scDirection(1)*obj.sc_(1);
      obj.panorama_.YData = obj.panorama_.YData + scDirection(2)*obj.sc_(2);
    end
    
    function [xlim,ylim] = getScreenSize(obj)
      xlim = obj.xlim_;
      ylim = obj.ylim_;
    end
    
    function [pagex,pagey] = getPage(obj)
      pagex = obj.xlim_(2)/obj.sc_(1);
      pagey = obj.ylim_(2)/obj.sc_(2);
    end
    
    function addScore(obj,score)
      value = str2double(obj.textScoreValue_.String);
      obj.textScoreValue_.String = num2str(value+score,'%05g');
    end
    
    function clear(obj)
      score = str2double(obj.textScoreValue_.String);
      time = ceil(180-toc(obj.tic_));
      value = score + time;
      %{
      rectangle('Position',[obj.xlim_(1)+obj.sc_(1)/4 obj.ylim_(1)+obj.sc_(2)/4 obj.sc_(1)/2 obj.sc_(2)/2],'FaceColor','w');
      clearText1 = text((obj.xlim_(2)-obj.xlim_(1)+1)/2,(obj.ylim_(2)-obj.ylim_(1)+1)/2+obj.sc_(2)/4,'Stage Clear!!',...
        'FontSize',32,'VerticalAlignment','top','HorizontalAlignment','Center');
      pause(1)
      clearText2 = text(obj.xlim_(1)+obj.sc_(1)/4,(obj.ylim_(2)-obj.ylim_(1)+1)/2+obj.sc_(2)/4,...,
        {'';'';['Gain Margin  : ' num2str(score,'%05g')];'';'';''},....
        'FontSize',24,'VerticalAlignment','top','HorizontalAlignment','Left');
      pause(0.5);
      clearText2.String{4,:} = ['Phase Margin : ' num2str(time,'%05g')];
      pause(0.5);
      clearText2.String{5,:} = ['Stability    : ' num2str(value,'%05g')];      
      if value > obj.topScore_
        pause(0.5);
        clearText2.String{6,:} = 'You are the best engineer!!';
      end
      %}
      imdata = imread('clear2.bmp');
      alpha = ((imdata(:,:,2) == 255) + (imdata(:,:,1) == 0));
      alpha = (alpha == 2);
      image('XData',obj.xlim_,'YData',flip(obj.ylim_,2),'CData',imdata,'AlphaData',~alpha);
      clearText1 = text(obj.xlim_(1)+(obj.xlim_(2)-obj.xlim_(1)+1)/2-1,obj.ylim_(1)+224-1,...
        {'Transfer Function';'has become stable!!'},...
        'VerticalAlignment','top','HorizontalAlignment','Center','FontUnits','normalized','FontSize',0.09);%'FontSize',32,
      pause(1);
      clearText2 = text(obj.xlim_(1)+(obj.xlim_(2)-obj.xlim_(1)+1)/2-1,obj.ylim_(1)+144-1,...
        ['Stability   :   ' num2str(value,'%05g')],...
        'VerticalAlignment','top','HorizontalAlignment','Center','FontUnits','normalized','FontSize',0.08);%'FontSize',28,
      pause(1);
      clearText3 = text(obj.xlim_(1)+(obj.xlim_(2)-obj.xlim_(1)+1)/2-1,obj.ylim_(1)+96-1,...
        {'You are a good';'control engineer!!'},...
        'VerticalAlignment','top','HorizontalAlignment','Center','FontUnits','normalized','FontSize',0.09);
      pause(3);
    end
  end
end