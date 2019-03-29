classdef Needle < MapChip
  methods
    function obj = Needle(x,y,direction)
      obj@MapChip(x,y);
      obj.name_ = 'block';
      obj.rigit_ = 0;
      obj.death_ = 1;
      switch direction
        case 1
          obj.imdata_ = imread('needleUp.bmp');
        case 2
          obj.imdata_ = imread('needleRight.bmp');
        case 3
          obj.imdata_ = imread('needleDown.bmp');
        case 4
          obj.imdata_ = imread('needleLeft.bmp');
      end
    end
    
    function imSet(obj)
      alpha = (obj.imdata_(:,:,1) ~= 255);
      obj.pic_ = image('XData',obj.xpos_,'YData',obj.ypos_,'CData',obj.imdata_,'AlphaData',alpha);
    end
    
    function imDelete(obj)
      delete(obj.pic_);
    end

  end
end