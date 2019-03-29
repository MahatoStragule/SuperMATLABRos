classdef EnemyPulse < Enemy
  properties
    flag_ = 1;
    vxInit_ = 0;
    vx_ = 0;
    bullet_;
    count_=0;
  end
  methods
    function obj = EnemyPulse(x,y,direction,num)
      obj@Enemy(x,y,num);
      obj.score_ = 200;
      obj.death_ = 0;
      obj.canbeat_ = 0;
      obj.direction_ = direction;
      obj.imdataInit_ = imread('enemyPulse.bmp');
      if direction > 0
        obj.imdata_ = flip(obj.imdataInit_,2);
      else
        obj.imdata_ = obj.imdataInit_;
      end
      obj.bullet_ = EnemyConstant1(obj.xpos_(2)/16+obj.direction_,obj.ypos_(1)/16,obj.direction_,0,obj);
    end
    
    function move(obj)
      obj.count_ = obj.count_ + 1;
      if obj.flag_ && obj.count_ > 100
        %obj.bullet_ = EnemyConstant1(obj.xpos_(2)/16+obj.direction_,obj.ypos_(1)/16,obj.direction_,0,obj);
        obj.map_.generateEnemy(obj.bullet_);
        obj.bullet_.appear(obj.map_);
        obj.flag_ = 0;
        obj.count_ = 0;
      end
    end
    
    function appear(obj,map)
      appear@Enemy(obj,map);
      obj.count_ = randi(50)+30;
      obj.bullet_.parentAppear;
    end
    
    function enemyReset(obj)
      enemyReset@Enemy(obj);
    end
    
    function remove(obj)
      remove@Enemy(obj);
      obj.bullet_.parentRemove;
    end
    
    function flagOn(obj)
      obj.flag_ = 1;
    end
  end
end