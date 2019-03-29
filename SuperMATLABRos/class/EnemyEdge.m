classdef EnemyEdge < Enemy
  properties
    vxInit_ = 0.5;
    vx_ = 0.5;
  end
  methods
    function obj = EnemyEdge(map,initPos,imdata,num)
      obj@Enemy(map,initPos,imdata,num);
    end
    
    function move(obj)
      if obj.map_.checkEdge(obj.xpos_,obj.ypos_,obj.vx_)
        obj.vx_ = -obj.vx_;
      end
      obj.xpos_ = obj.xpos_ + obj.vx_;
      obj.posSet;
      %{
      set(obj.pic_,'XData',obj.xpos_);
      drawnow;
      flag = obj.map_.checkEnemy(obj.xpos_,obj.ypos_,obj.num_);
      if flag
        disp('death');
      end
      %}
    end
    
    function enemyReset(obj)
      enemyReset@Enemy(obj);
      obj.vx_ = obj.vxInit_;
    end

  end
end