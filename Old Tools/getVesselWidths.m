function [width] = getVesselWidths(segmentArray,image)
%Takes an image, applies crazy contrast and filters, then takes user input
%along a vein. Returns the profile taken (red line), and the width of the
%vessel (length of green line)
[red,green,blue]=RGBSplit(image);

redNew = adapthisteq(red);
greenNew = adapthisteq(green);
blueNew = adapthisteq(blue);

redDraw = redNew;
greenDraw = (greenNew + redNew)/3;
blueDraw = blueNew;
%greenDraw(cell2mat(segmentArray(1))) = 255;
newImg = cat(3,redDraw,greenDraw,blueDraw);
figure,imshow(newImg);
for k = 1:length(segmentArray)
    [yVec,xVec] = ind2sub(size(image),cell2mat(segmentArray(k)));
    %[yVec,xVec] = ind2sub(size(image(:,:,2)),cell2mat(segmentArray(60)));  
    segment = [xVec,yVec];
    hold on;
    %plot(xVec,yVec);
    for j = 1:35:length(segment)-7;

        %xpos = segment(j,:)'
        %ypos = segment(j+7,:)'
        xpos = [segment(j); segment(j+6)];
        ypos = [segment(j,2); segment(j+6,2)];
        width = detWidth(xpos,ypos, newImg);

    end
hold off;
end

end

function width = detWidth(x,y, newImg)
%x,y are points, not <x,y>
%improfile line length
probeWidth = 25;
line(x,y); axis equal;

% Slope of current line
m = (diff(y)/diff(x));
% Slope of new line
minv = -1/m;
theta = atan(minv);

px = mean(x);
py = mean(y);
%Generate the perpendicular bisector of length (probeWidth) - it's easier
%to do in polar and then convert.
[polx, poly] = pol2cart([theta],[probeWidth]);
vx = [px - polx, px + polx];
vy = [py - poly, py + poly];
len = norm(vx-vy);

[Cx,Cy,ret] = improfile(newImg,vx,vy);

line(vx,vy,'Color','red'), axis equal;

gProfile = ret(:,:,2);

[loc, mag] = peakfinder(gProfile,[],[],-1);
minpt = mag(getClosest(loc, len/2));
maxpt = max(gProfile);
usePt = ((maxpt+minpt)/2);

uspt = usePt;


gProfile(gProfile > (1.0 * usePt)) = 0;
pkHigh = find(gProfile>0,1,'last');
pkLow = find(gProfile>0,1);
width = pkHigh - pkLow;



qx = [Cx(pkHigh); Cx(pkLow)];
qy = [Cy(pkHigh); Cy(pkLow)];

line(qx,qy,'Color','green'), axis equal;
%Use diff(ret(:,:,2),2) to get 2nd deriv, find max and min local - the
%betweener is our vein.
%figure, hold all,plot(ret(:,:,1),'r+'), plot(ret(:,:,2),'g*'),plot(ret(:,:,3),'bs'), hold off;
%figure, plot(ret(:,:,2));
%line([0,200],[uspt,uspt]);
end

function [ R G B ] = RGBSplit( datain )
%RGB Split returns [R, G, B] of an RGB image
%   Kind of patchy
R = datain(:,:,1);
G = datain(:,:,2);
B = datain(:,:,3);


endfunction xx = key2note(X, keynum, dur)
% KEY2NOTE Produce a sinusoidal waveform corresponding to a
% given piano key number
%
% usage: xx = key2note (X, keynum, dur)
%
% xx = the output sinusoidal waveform
% X = complex amplitude for the sinusoid, X = A*exp(j*phi).
% keynum = the piano keyboard number of the desired note
% dur = the duration (in seconds) of the output note
%
fs = 11025; %-- or use 8000 Hz
tt = 0:(1/fs):dur;
freq = %<=============== fill in this line
xx = real( X*exp(j*2*pi*freq*tt) );


function index = getClosest(vec,num)
%Returns the index of the element in vec that is closest in value to num
tmp = abs(vec-num);
[c,c] = min(tmp);
index = c;

end