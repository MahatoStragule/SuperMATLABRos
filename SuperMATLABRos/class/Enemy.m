classdef Enemy < handle
  properties(SetAccess = protected)
    imdata_;
    imdataInit_;
    pic_;
    xposInit_;
    yposInit_;
    xpos_;
    ypos_;
    map_;
    num_;
    appear_=0;
    score_ = 100;
    canbeat_ = 1;
    death_ = 1;
    
    direction_;
  end
  
  methods
    function obj = Enemy(x,y,num)
      obj.xposInit_ = [x-1 x]*16 + [1 0];
      obj.yposInit_ = [y y-1]*16 + [0 1];
      obj.xpos_ = obj.xposInit_;
      obj.ypos_ = obj.yposInit_;
      obj.num_ = num;
    end
          
    function appear(obj,map)
      obj.map_ = map;
      obj.pic_ = image('XData',obj.xpos_,'YData',obj.ypos_,'CData',obj.imdata_);
      obj.appear_ = 1;
      obj.enemyReset;
    end
    
    function enemyDelete(obj)
      delete(obj.pic_);
    end
    
    function enemyReset(obj)
      set(obj.pic_,'XData',obj.xposInit_,'YData',obj.yposInit_);
      obj.xpos_ = obj.xposInit_;
      obj.ypos_ = obj.yposInit_;
    end
    
    function pos = getCenter(obj)
      pos = zeros(1,2);
      pos(1) = (obj.xpos_(1) + obj.xpos_(2))/2;
      pos(2) = (obj.ypos_(2)+obj.ypos_(1))/2;
    end
    
    function posSet(obj)
      set(obj.pic_,'XData',obj.xpos_,'YData',obj.ypos_);
      %obj.map_.updataEnemy(obj.xpos_,obj.ypos_,obj.num_);
    end
    
    function remove(obj)
      %set(obj.pic_,'Visible','off');
      delete(obj.pic_);
    end
    
    function setNum(obj,num)
      obj.num_ = num;
    end
    
    function score = getScore(obj)
      score = obj.score_;
    end
    
    function check = getCanBeat(obj)
      check = obj.canbeat_;
    end
    
    function death = getDeath(obj)
      death = obj.death_;
    end
  end
end