function width = widthFinder(image, borders, segmentArray)
%Width finder - image is the original image (This is really just for show),
%borders is a binary image that contains the borders of the blood vessels
%in segmentArray. SegmentArray is the cell array of skeletal pixels.
%This doesn't store the widths in any data structures because it has
%returns a lot of bad widths.

%Implementing width controls (width can only change by x%, if only one
%border is found, assume symmetry, etc) will probably fix the inaccuracy. 


width = 0;
DSFactor =  1; %Downsampling factor - There's a name for this, what is it?
figure, imshow(image); %REMEMBER TO USE THE DOWNSAMPLED IMAGE GODDAMNIT
for k = 1:length(segmentArray)
    [yVec,xVec] = ind2sub(size(image),cell2mat(segmentArray(k)));
    %[yVec,xVec] = ind2sub(size(image(:,:,2)),cell2mat(segmentArray(60)));  
    segment = ceil([xVec/DSFactor,yVec/DSFactor]); %Ensure integers
    hold on;
    %plot(ceil(xVec./2),ceil(yVec./2));
    for j = 1:35:length(segment)-7;

        %xpos = segment(j,:)'
        %ypos = segment(j+7,:)'
        xpos = [segment(j); segment(j+6)];
        ypos = [segment(j,2); segment(j+6,2)];
        width = detWidth(xpos,ypos, borders);

    end
hold off;
end

end

function width = detWidth(x,y, borders)
%x,y are points, not <x,y>
%improfile line length
probeWidth = 14;
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
%len = norm(vx-vy);
[Cx,Cy,ret] = improfile(borders,vx,vy);

index = find(ret);

pkHigh = max(index);
pkLow = min(index);
line(vx,vy,'Color','red'), axis equal;

qx = [Cx(pkHigh); Cx(pkLow)];
qy = [Cy(pkHigh); Cy(pkLow)];

width = norm(qx-qy);


line(qx,qy,'Color','green'), axis equal;
%Use diff(ret(:,:,2),2) to get 2nd deriv, find max and min local - the
%betweener is our vein.
%figure, hold all,plot(ret(:,:,1),'r+'), plot(ret(:,:,2),'g*'),plot(ret(:,:,3),'bs'), hold off;
%figure, plot(ret(:,:,2));
%line([0,200],[uspt,uspt]);
end

