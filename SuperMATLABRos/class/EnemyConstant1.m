classdef EnemyConstant1 < Enemy
  properties
    parent_;
    vxAbs_ = 4;
    vxInit_;
    vx_;
  end
  methods
    function obj = EnemyConstant1(x,y,direction,num,parent)
      obj@Enemy(x,y,num);
      obj.score_ = 50;
      obj.parent_ = parent;
      obj.direction_ = direction;
      obj.vxInit_ = direction * obj.vxAbs_; 
      obj.vx_ = obj.vxInit_;
      obj.imdataInit_ = imread('enemyConstant1.bmp');
      if direction > 0
        obj.imdata_ = flip(obj.imdataInit_,2);
      else
        obj.imdata_ = obj.imdataInit_;
      end
    end
    
    function move(obj)
      obj.xpos_ = obj.xpos_ + obj.vx_;
      obj.posSet;
    end
    
    function parentAppear(obj)
      obj.pic_ = image('XData',obj.xpos_,'YData',obj.ypos_,'CData',obj.imdata_,'Visible','off');
    end
    
    function appear(obj,map)
      obj.map_ = map;
      obj.pic_.Visible = 'on';
      obj.appear_ = 1;
      obj.enemyReset;
    end
    
    function enemyReset(obj)
      enemyReset@Enemy(obj);
      %obj.map_.enemyArrayDelete(obj.num_);
    end
    
    function remove(obj)
      %remove@Enemy(obj);
      if isvalid(obj.pic_)
        obj.pic_.Visible = 'off';
      end
      obj.xpos_ = obj.xposInit_;
      obj.ypos_ = obj.yposInit_;
      obj.parent_.flagOn;
    end
    
    function parentRemove(obj)
      delete(obj.pic_);
    end
  end
end