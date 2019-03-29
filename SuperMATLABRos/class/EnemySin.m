classdef EnemySin < Enemy
  properties
    vxAbs_ = 1;
    vxInit_;
    vx_;
    vy_ = 0;
  end
  methods
    function obj = EnemySin(x,y,direction,num)
      obj@Enemy(x,y,num);
      obj.score_ = 150;
      obj.direction_ = direction;
      obj.vxInit_ = direction * obj.vxAbs_;
      obj.vx_ = direction * obj.vxAbs_;
      obj.imdataInit_ = imread('enemySin.bmp');
      if direction > 0
        obj.imdata_ = flip(obj.imdataInit_,2);
      else
        obj.imdata_ = obj.imdataInit_;
      end
      
    end
    
    function move(obj)
      wX = obj.map_.checkHitX(obj.xpos_,obj.ypos_,obj.vx_);
      if wX ~= 0
        obj.vx_ = -obj.vx_;
%        obj.imdata_ = flip(obj.imdata_,2);
%        set(obj.pic_,'CData',obj.imdata_);
      end
      
      obj.direction_ = sign(obj.vx_);
      if obj.direction_ > 0
        obj.imdata_ = flip(obj.imdataInit_,2);
      else
        obj.imdata_ = obj.imdataInit_;
      end
      set(obj.pic_,'CData',obj.imdata_);
            
      wY = obj.map_.checkHitY(obj.xpos_,obj.ypos_,obj.vy_);
      if wY == -1
        if obj.vy_ == 0
          obj.vy_ = 8;
        else
          obj.vy_ = 0;
          y = obj.ypos_;
          y1 = (ceil(y(2)/16)-1)*16+1;
          y2 = (ceil((y(1)+1)/16)-1)*16;
          obj.ypos_ = [y2 y1];
        end
      end
      if wY == 1
        obj.vy_ = -1;
      end
      
      if wY == 0 
        obj.vy_ = obj.vy_ - 0.6;
      end
      
      obj.xpos_ = obj.xpos_ + obj.vx_;
      obj.ypos_ = obj.ypos_ + obj.vy_;
      obj.posSet;
    end
    
    function enemyReset(obj)
      enemyReset@Enemy(obj);
      obj.vx_ = obj.vxInit_;
    end
  end
end