

function map = visualizeSkeletonPrinDir(bw)
%% Skeleton Principal Direction
% 
%   map = skeletonPrinDir(bw) where bw is the original bw image. 
%
% This function generates the principal orientation of 'continuous' thin
% objects in a binary image.
%
% This function works on objects whose toplogy is preserved under
% skeletonization. It takes the gradient of the distance function of the
% skeletonized image and then rotates the direction of ascent by 90 degrees.
% 
% This method will generally yield the principal orientation or the negative
% of the principal orientation of a network of thin objects in a binary
% image.
%


% skeleton = bwmorph(image,'skel',10);
% figure,imshow(skeleton);
% title('Skel');

thinned = bwmorph(bw,'skel',30);
%figure,imshow(thinned);
%title('thinned');

%Skel preserves endpoints better, but also produces a lot of erroneous
%endpoints. Thin reduces the number of erroneous endpts and smooths the
%vessel.
distImg = bwdist(thinned);






%% The gradient method is okay
[gx,gy] = imgradientxy(distImg);
%[gMag, gDir] = imgradient(distImg); %This doesn't quite provide the result
%one might expect

gx = clean_image(gx);
gy = clean_image(gy);

% Rotate by 90 deg
[TH, R] = cart2pol(gx,gy);
offset_angle = pi/2;
[gx,gy] = pol2cart(TH + offset_angle, R);

mapx = gx.*thinned;
mapy = gy.*thinned;

map = cat(3,mapx,mapy);

end

%% J.P. EE, UF