function makeImdata
%imdata.space = ones(16,16,3);
imdata.block = imread('block.bmp');
imdata.needleUp = imread('needleUp.bmp');
imdata.needleRight = imread('needleRight.bmp');
imdata.needleDown = imread('needleDown.bmp');
imdata.needleLeft = imread('needleLeft.bmp');
imdata.mainChara = imread('mainChara.bmp');
imdata.enemyConstant = imread('enemyConstant.bmp');
imdata.enemySin = imread('enemySin.bmp');
imdata.enemyPulse = imread('enemyPulse.bmp');
imdata.enemySwitch = imread('enemySwitch.bmp');
imdata.goal = imread('goal.bmp');
save('imdata.mat','imdata');
end