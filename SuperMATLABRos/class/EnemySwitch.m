classdef EnemySwitch < Enemy
  properties
    vxAbs_ = 1;
    vyInit_ = -4;
    vy_;
    initCount_;
    count_ = 0;
  end
  methods
    function obj = EnemySwitch(x,y,num)
      obj@Enemy(x,y,num);
      obj.initCount_ = randi(50);
      obj.vy_ = obj.vyInit_;
      obj.canbeat_ = 0;
      obj.imdataInit_ = imread('enemySwitch.bmp');
      obj.imdata_ = obj.imdataInit_;
    end
    
    function move(obj)
      if obj.initCount_ > 0
        obj.initCount_ = obj.initCount_ - 1;
      else
        wY = obj.map_.checkHitY(obj.xpos_,obj.ypos_,obj.vy_);
        if obj.count_ > 0
          obj.count_ = obj.count_ - 1;
           if obj.count_ == 0
            obj.vy_ = 1;
            obj.imdata_ = obj.imdataInit_;
            set(obj.pic_,'CData',obj.imdata_);
          end
        else
          if wY == -1
            obj.count_ = 20;
            obj.ypos_ = ceil(obj.ypos_(2)/16)*16*[1 1]-[0 15];
  %          obj.imdata_ = obj.imdataInit_;
  %          set(obj.pic_,'CData',obj.imdata_);
          elseif wY == 1
            obj.vy_ = -4;
            obj.ypos_ = ceil(obj.ypos_(1)/16)*16*[1 1]-[0 15];
            obj.imdata_ = flip(obj.imdataInit_,1);
            set(obj.pic_,'CData',obj.imdata_);
          else
            obj.ypos_ = obj.ypos_ + obj.vy_;
          end
        end
      end
      set(obj.pic_,'XData',obj.xpos_,'YData',obj.ypos_);
      %obj.posSet;
    end
    
    function enemyReset(obj)
      enemyReset@Enemy(obj);
      obj.vy_ = obj.vyInit_;
    end
  end
end