classdef MainChara < handle
  properties
    imdata_;
    imdataInit_;
    alpha_;
    alphaInit_;
    pic_;
    xpos_;
    ypos_;
    xposInit_;
    yposInit_;
    vx_=0;
    vy_=0;
    vxMax_ = 2.8;
    map_;
    
    jumpButton_= 0;
    
    direction_ = 1;
    
    BGMjump_;
    
    BGMbeat_;
    
    
  end
  methods 
    function obj = MainChara(xinit,yinit,map)
      load('BGMdata.mat','BGMdata');
      obj.BGMjump_ = {BGMdata.jump.music,BGMdata.jump.fs};
      obj.BGMbeat_ = {BGMdata.beat.music,BGMdata.beat.fs};
      obj.xposInit_ = xinit;
      obj.yposInit_ = yinit;
      obj.xpos_ = obj.xposInit_;
      obj.ypos_ = obj.yposInit_;
      obj.imdataInit_ = imread('mainChara2.bmp');
      obj.imdata_ = obj.imdataInit_;
      obj.alphaInit_ = ((obj.imdata_(:,:,1) ~= 255) + (obj.imdata_(:,:,2) ~= 255) + (obj.imdata_(:,:,3) ~= 255));
      obj.alpha_ = obj.alphaInit_;
      obj.pic_ = image('XData',xinit,'YData',yinit,'CData',obj.imdata_,'AlphaData',obj.alpha_);
      obj.map_ = map;
    end
    
    function forceMove(obj,vx,vy)
      obj.xpos_ = obj.xpos_ + vx;
      obj.ypos_ = obj.ypos_ + vy;
      obj.posSet;
    end
    
    function move(obj,vxKey)
      x = obj.xpos_;
      y = obj.ypos_;
      accelx = vxKey;
      vx = sign(obj.vx_+accelx)*min(abs(obj.vx_ + accelx),obj.vxMax_);
      vy = obj.vy_;
      
      direction = sign(accelx);
      if direction ~= obj.direction_
        obj.direction_ = direction;
        if obj.direction_ < 0
          obj.imdata_ = flip(obj.imdataInit_,2);
          obj.alpha_ = flip(obj.alphaInit_,2);
        elseif obj.direction_ > 0
          obj.imdata_ = obj.imdataInit_;
          obj.alpha_ = obj.alphaInit_;
        end
        set(obj.pic_,'CData',obj.imdata_,'AlphaData',obj.alpha_);
      end
      
      wX = obj.map_.checkHitX(obj.xpos_,obj.ypos_,vx);
      if wX ~= 0
        vx = 0;
      end
  
      wY = obj.map_.checkHitY(obj.xpos_,obj.ypos_,vy);
      if wY == 1
        vy = -1;
      end
  
      if wY == -1 || wY == 2
        vy = 0;
        y1 = (ceil(y(2)/16)-1)*16+1;
        y2 = (ceil((y(1)+1)/16)-1)*16;
        y = [y2 y1];
        if ~accelx
          vx = vx*0.8;
        end
      end
    
      if wY == 0 
        if obj.jumpButton_ && vy > 0
          vy = vy - 0.4;
        else
          vy = vy - 0.8;
        end
      end
      if vy < 0
        obj.jumpButton_ = 0;
      end
      obj.xpos_ = x + vx;
      obj.ypos_ = y + vy;
      obj.vx_ = vx;
      obj.vy_ = vy;
      obj.posSet;
    end
    
    function posSet(obj)
      set(obj.pic_,'XData',obj.xpos_,'YData',obj.ypos_);
    end

    function jump(obj)
      w = obj.map_.checkHitY(obj.xpos_,obj.ypos_,obj.vy_);
      if w == -1
        obj.vy_ = 7.5;
        obj.jumpButton_ = 1;
        sound(obj.BGMjump_{1},obj.BGMjump_{2});
      end 
    end
    
    function jumpKeyUp(obj)
      obj.jumpButton_ = 0;
    end
    
    function jumpAuto(obj)
      obj.vy_ = 7.5;
      sound(obj.BGMbeat_{1}/3,obj.BGMbeat_{2});
    end
    
    function [xpos,ypos] = getPos(obj)
      xpos = obj.xpos_;
      ypos = obj.ypos_;
    end
    
    function death(obj)
      pause(0.5)
      ypos = obj.ypos_;
      g = 0.7;
      vy = 7;
      while(ypos(1) > 0)
        ypos = ypos + vy;
        obj.ypos_ = ypos;
        obj.posSet;
        drawnow;
        vy = vy - g;
      end
    end
    
    function death2(obj)
      ypos = obj.ypos_;
      g = 0.7;
      vy = obj.vy_;
      while(ypos(1) > 0)
        ypos = ypos + vy;
        obj.ypos_ = ypos;
        obj.posSet;
        drawnow;
        vy = vy - g;
      end
    end
    
    function clear(obj)
      obj.pic_.Visible = 'off';
    end
  end
end