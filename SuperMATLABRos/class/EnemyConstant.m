classdef EnemyConstant < Enemy
  properties
    vxAbs_ = 1;
    vxInit_;
    vx_;
  end
  methods
    function obj = EnemyConstant(x,y,direction,num)
      obj@Enemy(x,y,num);
      obj.direction_ = direction;
      obj.vxInit_ = direction * obj.vxAbs_;
      obj.vx_ = direction * obj.vxAbs_;
      obj.imdataInit_ = imread('enemyConstant.bmp');
      if direction > 0
        obj.imdata_ = flip(obj.imdataInit_,2);
      else
        obj.imdata_ = obj.imdataInit_;
      end
      
    end
    
    function move(obj)
      wX = obj.map_.checkHitX(obj.xpos_,obj.ypos_,obj.vx_);
      if wX ~= 0 || obj.map_.checkEdge(obj.xpos_,obj.ypos_,obj.vx_);
        obj.vx_ = -obj.vx_;
%        obj.imdata_ = flip(obj.imdata_,2);
%        set(obj.pic_,'CData',obj.imdata_);
      end
      
      direction = sign(obj.vx_);
      if direction ~= obj.direction_
        obj.direction_ = direction;
        if obj.direction_ > 0
          obj.imdata_ = flip(obj.imdataInit_,2);
        else
          obj.imdata_ = obj.imdataInit_;
        end
      set(obj.pic_,'CData',obj.imdata_);
      end
      
      obj.xpos_ = obj.xpos_ + obj.vx_;
      set(obj.pic_,'XData',obj.xpos_,'YData',obj.ypos_);
      %obj.posSet;
    end
    
    function enemyReset(obj)
      enemyReset@Enemy(obj);
      obj.vx_ = obj.vxInit_;
    end
  end
end