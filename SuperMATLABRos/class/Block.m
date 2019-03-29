classdef Block < MapChip
  methods
    function obj = Block(x,y)
      obj@MapChip(x,y);
      obj.name_ = 'block';
      obj.rigit_ = 1;
      obj.death_ = 0;
      obj.imdata_ = imread('block.bmp');
    end
    
    function imSet(obj)
      obj.pic_ = image('XData',obj.xpos_,'YData',obj.ypos_,'CData',obj.imdata_);
    end
    
    function imDelete(obj)
      delete(obj.pic_);
    end
  end
end