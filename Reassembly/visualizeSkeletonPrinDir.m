

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


[skel_pts_listx, skel_pts_listy] = ind2sub(size(bw),find(thinned));
skel_pts_list = [skel_pts_listx, skel_pts_listy];




figure,imshow(bw)
hold on

spacing = 2;
for pt_pos = 1:spacing:length(skel_pts_list);

    pos_x = uint32(skel_pts_list(pt_pos,1));
    pos_y = uint32(skel_pts_list(pt_pos,2));
    
    gradX = gx(pos_x,pos_y);
    gradY = gy(pos_x,pos_y);
    

    quiver(pos_y,pos_x,gradX,gradY,3,'linewidth',5,'color','r')

end
hold off


end

%% J.P. EE, UF