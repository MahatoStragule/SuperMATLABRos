classdef Map < handle
  properties (Access = 'private')
    mapSet_;
    mapSize_;
    
    xpos_;
    ypos_;
    xposInit_;
    yposInit_;
    
    mainChara_;
    
    enemySet_;
    enemyArray_;
    
    enemyPosArray_;
    enemyAppearArray_;
    
    sc_;
    
    gravity_ = 0.6;
    
    goal_;
    goalPos_;
    
    panorama_;
end
  methods
    function obj = Map(mapdata,screenSize,stageNum)
      mapSet = mapdata.mapSetChip;
      xinit = mapdata.initPos(1);
      yinit = mapdata.initPos(2);
      obj.mapSize_ = size(mapSet);
      obj.mapSet_ = mapSet;
      
      initpage = [ceil(xinit/24) ceil(yinit/18)];
      initxsize = [1 24]+(initpage(1)-1)*24;
      initysize = [1 18]+(initpage(2)-1)*18;
      obj.panorama_ = image('XData',[(initxsize(1)-1)*16+1 initxsize(2)*16],...
        'YData',[initysize(2)*16 (initysize(1)-1)*16+1],'CData',imread('panorama.bmp'));
      %{
      for j = 1:obj.mapSize_(2)
        for i = 1:obj.mapSize_(1)
          obj.mapSet_{i,j}.imSet;
        end
      end
      %}
      for j = initysize(1):initysize(2)
        for i = initxsize(1):initxsize(2)
          obj.mapSet_{i,j}.imSet;
        end
      end
      xposInit = [xinit xinit+1]*16 + [1 0];
      yposInit = [yinit+1 yinit]*16 + [0 1];
      obj.xposInit_ = xposInit;
      obj.yposInit_ = yposInit;
      obj.mainChara_ = MainChara(xposInit,yposInit,obj);
      goalXPos = [mapdata.goalPos(1)-2 mapdata.goalPos(1)]*16 + [1 0];
      goalYPos = [mapdata.goalPos(2) mapdata.goalPos(2)-1]*16 + [0 1];
      obj.goal_ = image('XData',goalXPos,'YData',goalYPos,'CData',imread('goal.bmp'));
      obj.goalPos_ = [(goalXPos(1)+goalXPos(2))/2 (goalYPos(1)+goalYPos(2))/2];
      
      obj.enemySet_ = mapdata.enemySet;
      obj.enemyArray_ = obj.enemySet_{initpage(1),initpage(2)};
      obj.enemyPosArray_ = zeros(2,length(obj.enemyArray_));
      for i = 1:length(obj.enemyArray_)
        obj.enemyPosArray_(:,i) = obj.enemyArray_{i}.getCenter;
      end
      
      obj.sc_ = Screen(screenSize,initpage,obj.mapSize_,obj,obj.panorama_,stageNum,mapdata.timeLimit);
    end
    
    function clearflag = mainCharaMove(obj,vxKey)
      clearflag = 0;
      obj.mainChara_.move(vxKey);
      [xpos,ypos] = obj.mainChara_.getPos;
      obj.checkSink(xpos,ypos);
      cent = [(xpos(1)+xpos(2))/2 (ypos(1)+ypos(2))/2];
      checkHit = (abs(cent(1)-obj.goalPos_(1)) < 24) + (abs(cent(2)-obj.goalPos_(2)) < 16);
      if checkHit > 1
        clearflag = 1;
      end
    end
    
    function death = checkFall(obj)
      death = 0;
      [xpos,ypos] = obj.mainChara_.getPos;
      if ypos(2) <= 0
        death = 1;
      end
    end
    
    function checkSink(obj,xpos,ypos)
      xleft = max(ceil(xpos(1)/16),1);
      xright = min(ceil(xpos(2)/16),obj.mapSize_(1));
      ytop = min(ceil(ypos(1)/16),obj.mapSize_(2));
      ybuttom = min(max(ceil(ypos(2)/16),1),obj.mapSize_(2));
      if obj.mapSet_{xleft,ytop}.rigit_ || obj.mapSet_{xleft,ybuttom}.rigit_
        obj.mainChara_.forceMove(ceil(xpos(1)/16)*16-xpos(1)+1,0);
      elseif obj.mapSet_{xright,ybuttom}.rigit_ || obj.mapSet_{xright,ytop}.rigit_
        obj.mainChara_.forceMove((ceil(xpos(2)/16)-1)*16-xpos(2),0);
      end
    end
    
    function jumpKeyDown(obj)
      obj.mainChara_.jump;
    end
    
    function jumpKeyUp(obj)
      obj.mainChara_.jumpKeyUp;
    end
    
    function updatePos(obj,xpos,ypos)
      obj.xpos_ = xpos;
      obj.ypos_ = ypos;
    end
    
    function updataEnemy(obj)
      deleteItr = [];
      for i = 1:length(obj.enemyArray_)
        obj.enemyPosArray_(:,i) = obj.enemyArray_{i}.getCenter';
        pos = obj.enemyPosArray_(:,i);
        [xlim,ylim] = obj.sc_.getScreenSize;
        if pos(1) < xlim(1) || pos(1) > xlim(2) || pos(2) < ylim(1) || pos(2) > ylim(2)
          deleteItr = [deleteItr i];
        end
      end
      for i=1:length(deleteItr)
        obj.enemyArrayDelete(deleteItr(i));
        deleteItr = deleteItr-1;
      end
    end
    %{
    function updataEnemy(obj,xposE,yposE,num)
      obj.enemyPosArray_(:,num) = [(xposE(1)+xposE(2))/2; (yposE(2)+yposE(1))/2];
      pos = obj.enemyPosArray_(:,num);
      [xlim,ylim] = obj.sc_.getScreenSize;
      if pos(1) < xlim(1) || pos(1) > xlim(2) || pos(2) < ylim(1) || pos(2) > ylim(2)
        obj.enemyArrayDelete(num)
      end
    end
    %}
    function enemyArrayDelete(obj,num)
      obj.enemyArray_{num}.remove;
      obj.enemyArray_(num) = [];
      obj.enemyPosArray_(:,num) = [];
      for i = 1:length(obj.enemyArray_)
        obj.enemyArray_{i}.setNum(i);
      end
    end
    
    function hobj = getAt(obj,x,y)
      if x < 1
        x = 1;
      end
      if x > obj.mapSize_(1)
        x = obj.mapSize_(1);
      end
      if y < 1
        %hobj = Space(0,0);
        y = 1;
      end
      if y > obj.mapSize_(2)
        y = obj.mapSize_(2);
      end
      hobj = obj.mapSet_{x,y};
    end
    
    function wX = checkHitX(obj,xpos,ypos,vx)
      wX = 0;
      if xpos(1)+vx < 1
        wX = -1;
        return
      elseif xpos(2)+vx > obj.mapSize_(1)*16
        wX = 1;
        return
      end
      leftBottomX = obj.getAt(ceil((xpos(1)+vx)/16),ceil(ypos(2)/16));
      leftTopX = obj.getAt(ceil((xpos(1)+vx)/16),ceil(ypos(1)/16));
            
      if leftBottomX.rigit_ || leftTopX.rigit_
        wX = -1;
      end
      rightBottomX = obj.getAt(ceil((xpos(2)+vx)/16),ceil(ypos(2)/16));
      rightTopX = obj.getAt(ceil((xpos(2)+vx)/16),ceil(ypos(1)/16));
      if rightBottomX.rigit_ || rightTopX.rigit_
        if wX == 0
          wX = 1;
        end
      end
      
    end
        
    function wY = checkHitY(obj,xpos,ypos,vy)
      wY = 0;
      %{
      if ypos(2)-1+vy < 1
        wY = 0;
        return;
      elseif ypos(1)+1+vy > obj.mapSize_(2)*16
        wY = 0;
        return;
      end
      %}
      leftBottomY = obj.getAt(ceil(xpos(1)/16),ceil((ypos(2)-1+vy)/16));
      rightBottomY = obj.getAt(ceil(xpos(2)/16),ceil((ypos(2)-1+vy)/16));
      if leftBottomY.rigit_ || rightBottomY.rigit_
        wY = -1;
      end

      leftTopY = obj.getAt(ceil(xpos(1)/16),ceil((ypos(1)+1+vy)/16));
      rightTopY = obj.getAt(ceil(xpos(2)/16),ceil((ypos(1)+1+vy)/16));
      if leftTopY.rigit_ || rightTopY.rigit_
        if wY == 0
          wY = 1;
        else
          wY = 2;
        end
      end
    end
    
    function wY = checkEdge(obj,xpos,ypos,vx)
      wY = 0;
      leftBottomY = obj.getAt(ceil((xpos(1)+vx)/16),ceil((ypos(2)-1)/16));
      rightBottomY = obj.getAt(ceil((xpos(2)+vx)/16),ceil((ypos(2)-1)/16));
      if ~leftBottomY.rigit_ || ~rightBottomY.rigit_
        wY = 1;
      end
    end
    
    function enemyAppear(obj,page)
      obj.enemyArray_ = obj.enemySet_{page(1),page(2)};
      obj.enemyPosArray_ = zeros(2,length(obj.enemyArray_));
      for i = 1:length(obj.enemyArray_)
        obj.enemyPosArray_(:,i) = obj.enemyArray_{i}.getCenter;
        obj.enemyArray_{i}.appear(obj);
      end
    end
    
    function death = scroll(obj)
      [xpos, ypos] = obj.mainChara_.getPos;
      [flag,page,death] = obj.sc_.scroll(xpos,ypos);
      if flag
        for i = 1:length(obj.enemyArray_)
          obj.enemyArray_{i}.remove;
        end
        obj.enemyAppear(page);
      end
    end
        
    function mapChipUpdata(obj,direction)
      [xlim,ylim] = obj.sc_.getScreenSize;
      xMin = (xlim(1)-1)/16;
      yMin = (ylim(1)-1)/16;
      for j = 1:18
        for i = 1:24
          obj.mapSet_{xMin+i-direction(1)*24,yMin+j-direction(2)*18}.imDelete;
          obj.mapSet_{xMin+i,yMin+j}.imSet;
        end
      end
    end
    
    function enemyMove(obj)
      deleteItr = [];
      for i = 1:length(obj.enemyArray_)
        obj.enemyArray_{i}.move;
        obj.enemyPosArray_(:,i) = obj.enemyArray_{i}.getCenter';
        pos = obj.enemyPosArray_(:,i);
        [xlim,ylim] = obj.sc_.getScreenSize;
        if pos(1) < xlim(1) || pos(1) > xlim(2) || pos(2) < ylim(1) || pos(2) > ylim(2)
          deleteItr = [deleteItr i];
        end
      end
      for i=1:length(deleteItr)
        obj.enemyArrayDelete(deleteItr(i));
        deleteItr = deleteItr-1;
      end
      %obj.updataEnemy;
    end
    
    function check = checkDeath(obj)
      check = 0;
      [xpos,ypos] = obj.mainChara_.getPos;
      
      % x方向の確認
      leftBottomX = obj.getAt(ceil((xpos(1))/16),ceil(ypos(2)/16));
      leftTopX = obj.getAt(ceil((xpos(1))/16),ceil(ypos(1)/16));
      rightBottomX = obj.getAt(ceil((xpos(2))/16),ceil(ypos(2)/16));
      rightTopX = obj.getAt(ceil((xpos(2))/16),ceil(ypos(1)/16));
      if rightBottomX.death_ || rightTopX.death_ || leftBottomX.death_ || leftTopX.death_
        check = 1;
        return
      end
      if ceil(ypos(1)/16) < 0
        check = 1;
        return
      end
      %{
      % y方向の確認
      leftBottomY = obj.getAt(ceil(xpos(1)/16),ceil((ypos(2))/16));
      rightBottomY = obj.getAt(ceil(xpos(2)/16),ceil((ypos(2))/16));
      leftTopY = obj.getAt(ceil(xpos(1)/16),ceil((ypos(1))/16));
      rightTopY = obj.getAt(ceil(xpos(2)/16),ceil((ypos(1))/16));
      if leftTopY.death_ || rightTopY.death_ || leftBottomY.death_ || rightBottomY.death_
        check = 1;
        return
      end
      %}
      if isempty(obj.enemyArray_)
        return
      end
      
      centx = (xpos(1)+xpos(2))/2;
      centy = (ypos(2)+ypos(1))/2;

      cent = [centx*ones(1,length(obj.enemyArray_));
              centy*ones(1,length(obj.enemyArray_))];
      checkHit = sum((abs(cent-obj.enemyPosArray_) < 16));
      checkVer = ((centy-obj.enemyPosArray_(2,:)) > 0);
      checkEnemy = find((checkHit+checkVer)>2,1);
      
      if ~isempty(checkEnemy)
        if obj.enemyArray_{checkEnemy(1)}.getCanBeat
          score = obj.enemyArray_{checkEnemy(1)}.getScore;
          obj.sc_.addScore(score);
          obj.enemyArrayDelete(checkEnemy(1));
          [pagex,pagey] = obj.sc_.getPage;
          obj.enemySet_{pagex,pagey} = obj.enemyArray_;
          checkHit(checkEnemy(1)) = [];
          obj.mainChara_.jumpAuto;
        end
      end
      if any(checkHit(:)>1)
        checkHitItr = find(checkHit>1);
        for i = 1:length(checkHitItr)
          if obj.enemyArray_{checkHitItr(i)}.getDeath
            check = 1;
          end
        end
      end
      
      %{
      cent = [centx*ones(1,length(itr));
              centy*ones(1,length(itr))];
      enemyPos = [obj.enemyPosArray_(1,itr);
                  obj.enemyPosArray_(2,itr)];
      checkHit = sum((abs(cent-enemyPos) < 16));
      checkVer = ((cent(2,:)-enemyPos(2,:)) > 10);
      check = find((checkHit+checkVer)>2,1);
      if ~isempty(check)
        obj.enemyArray_{itr(check)}.remove;
        checkHit(check) = 0;
      end
      if any(checkHit(:)>1)
        disp('death!');
      end
      %}
    end
    function death(obj)
      obj.mainChara_.death;
    end
    
    function death2(obj)
      obj.mainChara_.death2;
    end
    
    function clear(obj)
      obj.mainChara_.clear;
      obj.sc_.clear;
    end
    
    function num = getEnemyNum(obj)
      num = length(obj.enemyArray_);
    end
    
    function generateEnemy(obj,enemy)
      enemyNum = length(obj.enemyArray_);
      obj.enemyArray_{enemyNum+1} = enemy;
      enemy.setNum(enemyNum+1);
      obj.enemyPosArray_(:,enemyNum+1) = enemy.getCenter;
    end
  end
end