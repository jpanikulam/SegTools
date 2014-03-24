%%Minimum Spanning Tree of "Lost Binary Nodes"
function [mst,sep] = minSpanTree(img)
%This is a kludgey minimum span approximator using bwmorph. It bridge gaps
%(up to a limit), then shrinks down and re-expands to a size that I find
%acceptable.
%If this is the ultimate solution, the output size of each re-expansion
%should be limited by the size of its little probability bubble region.

%%We can make more substantive reassembly decisions with the full pMap
%%generated (from correlatorPmap), but that is extremely computationally
%%expensive.

%%Furthermore, we can improve by creating seperate classes of "large"
%%objects: <5k px, < 1k px, < 500 px, and reconnecting at that level. 
%%I'm going to do that.

% CC = bwconncomp(img);
% 
% distMap = bwdist(img);

CC = bwconncomp(img, 4);

finimg = zeros(size(img));

[biggest] = cellfun(@numel,CC.PixelIdxList);
K = CC.PixelIdxList(biggest<5000);

stkArr = vertcat(K{1,:});

%finimg(CC.PixelIdxList{stkArr}) = 1;
finimg(stkArr) = 1;
figure,imshow(finimg)
HH = finimg;

ZZ = bwmorph(HH,'dilate',10);
FF = bwmorph(ZZ,'shrink',10);
FF = bwmorph(FF,'clean');
FF  = (bwmorph(FF,'dilate',3));
%%Do probabilistic elimination? Ask about clusters at next meeting.
figure, imshow(FF | img);
mst = FF | img;
sep = FF;










% 
% diffx = diff(distMap')';
% diffy = diff(distMap);
% 
% % diffRx = (distMap(:,1:end-1).*diffx);
% % diffRy = (distMap(1:end-1,:).*diffy);
% 
% diffRx = (distMap(:,1:end-1).*diffx);
% diffRy = (distMap(1:end-1,:).*diffy);

% 
% diffR = diffRx(1:end-1,:) + diffRy(:,1:end-1);
% %figure,imagesc(diffR)
% 
% [mg,dir] = imgradient(distMap);

% s = regionprops(CC,'centroid')
% A = cat(1,s.Centroid);
% line(A(:,1), A(:,2), 'Marker', '*', 'MarkerEdgeColor', 'r')

end