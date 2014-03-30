%% Skeleton Principal Direction

function map = skeletonPrinDir(bw)
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
%Can do elimination based on "squiggliness" of an object.

distImg = bwdist(thinned);






%% The gradient method is okay
[gx,gy] = imgradientxy(distImg);
%[gMag, gDir] = imgradient(distImg);

gx = clean_image(gx);
gy = clean_image(gy);

% Rotate by 90 deg
[TH, R] = cart2pol(gx,gy);
offset_angle = pi/2;
[gx,gy] = pol2cart(TH + offset_angle, R);


[skel_pts_listx, skel_pts_listy] = ind2sub(size(bw),find(thinned));
skel_pts_list = [skel_pts_listx, skel_pts_listy];




figure,imshow(thinned)
hold on

spacing = round(length(bw)/25);
for pt_pos = 1:25:length(skel_pts_list);
    %[pos_y, pos_x] = ginput(1);
    pos_x = uint32(skel_pts_list(pt_pos,1));
    pos_y = uint32(skel_pts_list(pt_pos,2));
    
    gradX = gx(pos_x,pos_y);
    gradY = gy(pos_x,pos_y);
    

    quiver(pos_y,pos_x,gradX,gradY,3,'linewidth',5,'color','r')

end
hold off


end