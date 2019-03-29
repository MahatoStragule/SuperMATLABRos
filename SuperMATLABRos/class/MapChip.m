classdef MapChip < handle
  properties (SetAccess = 'protected')
    name_;
    imdata_;
    pic_;
    picEditor_;
    xpos_;
    ypos_;
    rigit_;
    death_;
  end
  methods
    function obj = MapChip(x,y)
      xLeft = (x-1)*16+1;
      xRight = x*16;
      yBottom = (y-1)*16+1;
      yTop = y*16;
      obj.xpos_ = [xLeft xRight];
      obj.ypos_ = [yTop yBottom];
    end
    function name = getName(obj)
      name = obj.name_;
    end
    
    function setPos(obj,x,y)
      xLeft = (x-1)*16+1;
      xRight = x*16;
      yBottom = (y-1)*16+1;
      yTop = y*16;
      obj.xpos_ = [xLeft xRight];
      obj.ypos_ = [yTop yBottom];
    end
  end
end