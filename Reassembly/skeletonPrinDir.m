%% Skeleton Principal Direction

function map = skeletonPrinDir(bw)
% 
% skeleton = bwmorph(image,'skel',10);
% figure,imshow(skeleton);
% title('Skel');

thinned = bwmorph(bw,'thin',10);
%figure,imshow(thinned);
%title('thinned');

%Skel preserves endpoints better, but also produces a lot of erroneous
%endpoints. Thin reduces the number of erroneous endpts and smooths the
%vessel.
%Can do elimination based on "squiggliness" of an object.

distImg = bwdist(bw);

[gx,gy] = imgradientxy(distImg);
[gMag, gDir] = imgradient(distImg);

[xMap, yMap] = meshgrid(1:length(bw)); %Whoa! There's a hack! Whoa! Can't even handle me! Whoa!

xList = xMap(:);
yList = yMap(:);

gxList = gx(:);
gyList = gy(:);

sz = numel(bw);


figure,imagesc(distImg)
hold on



spacing = round(length(bw)/25);

%scatter(yList(1:spacing:sz),xList(1:spacing:sz),10, 'g');
%quiver(yList(1:spacing:sz),xList(1:spacing:sz),gxList(1:spacing:sz),gyList(1:spacing:sz),1,'linewidth',0.2,'color','g');
hold off

%quiver(mid(1),mid(2),coeff(1,1),coeff(1,2),varianceTable(2),'linewidth',3)
%quiver(mid(1),mid(2),coeff(2,1),coeff(2,2),varianceTable(1),'linewidth',3)



end