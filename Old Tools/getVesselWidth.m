function [width, pro] = getVesselWidth(image)
%Takes an image, applies crazy contrast and filters, then takes user input
%along a vein. Returns the profile taken (red line), and the width of the
%vessel (length of green line)
[red,green,blue]=RGBSplit(image);

redNew = adapthisteq(red);
greenNew = adapthisteq(green);
blueNew = adapthisteq(blue);

redDraw = redNew;
greenDraw = greenNew;
blueDraw = blueNew;

newImg = cat(3,redDraw,greenDraw,blueDraw);
figure,imshow(newImg);
[x,y] = ginput(2);


%Probe width
probeWidth = 25;

% Slope of current line
m = (diff(y)/diff(x));
% Slope of new line
minv = -1/m;
%vx = [mean(x)-probeWidth mean(x)+probeWidth]
%vy = [mean(y)-(probeWidth*minv) mean(y)+probeWidth*minv]
theta = atan(minv);

px = mean(x);
py = mean(y);
[polx, poly] = pol2cart([theta],[probeWidth]);
vx = [px - polx, px + polx];
vy = [py - poly, py + poly];
len = norm(vx-vy)

[Cx,Cy,ret] = improfile(newImg,vx,vy);


line(x,y);
line(vx,vy,'Color','red'), axis equal;

gProfile = ret(:,:,2);
pro = ret(:,:,2);
[loc, mag] = peakfinder(gProfile,[],[],-1);
minpt = mag(getClosest(loc, len/2));
maxpt = max(pro);
usePt = ((maxpt+minpt)/3);

uspt = usePt;
%Use anything greater than the lowest peak that is greater than usePt.

peakList = peakfinder(gProfile)
[pkUse, pkUseInd] = min(gProfile(peakList>usePt))


gProfile(gProfile > (1.0 * pkUse)) = 0;

pkHigh = find(gProfile>0,1,'last');
pkLow = find(gProfile>0,1);

width = pkHigh - pkLow;

qx = [Cx(pkHigh); Cx(pkLow)];
qy = [Cy(pkHigh); Cy(pkLow)];

line(qx,qy,'Color','green'), axis equal;
%Use diff(ret(:,:,2),2) to get 2nd deriv, find max and min local - the
%betweener is our vein.
%figure, hold all,plot(ret(:,:,1),'r+'), plot(ret(:,:,2),'g*'),plot(ret(:,:,3),'bs'), hold off;
figure, plot(ret(:,:,2));
line([0,200],[pkUse,pkUse]), axis equal;

end
function [ R, G, B ] = RGBSplit( datain )
%RGB Split returns [R, G, B] of an RGB image
%   Kind of patchy
R = datain(:,:,1);
G = datain(:,:,2);
B = datain(:,:,3);


end

function index = getClosest(vec,num)
%Returns the index of the element in vec that is closest in value to num
tmp = abs(vec-num);
[c,c] = min(tmp);
index = c;

end