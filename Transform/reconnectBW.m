function [rct] = reconnectBW(BW, x)
rct = x;
se = strel('disk',20);



filled = ~ContEliminator(imcomplement(BW),1000);
% filled = imfill(BW,'holes');



%For the filling: invert the image and find blobs below a certain size:
%fill at the location of the centroids
%This will need fixing eventually


skeleton = bwmorph(filled,'skel',30);



endpts = bwmorph(skeleton,'endpoints');
CC = bwconncomp(skeleton);

pxTbl = CC.PixelIdxList;
%%
%Attempt #1

% Remove the BW entity containing the endpoint, and blot in a circle

[y,x] = ind2sub(size(BW),find(endpts));

ptTable = [x,y];

distTable = pdist2(ptTable,ptTable);

igTable = distTable;
igTable(distTable == 0) = 100;


figure,imagesc(endpts+filled);
hold on
h = waitbar(0,'0%','Name','Generating Training Vectors...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)


%%
% Distance Hunting!
lngt = length(igTable);
for k = 1:lngt
    if getappdata(h,'canceling')
        break
    end
    %length(distTable)
    curSet = igTable(k,1:k);
    
    [minVal, loc] = min(curSet(:));
    if (minVal < 70)
        targBW = false(size(BW));
        startBW = false(size(BW));
        
        targBWpt = targBW;
        %targBWpt(ptTable(loc,:)) = 1;
        
        targBWpt(y(loc),x(loc)) = 1;
        startBWpt = startBW;
        
        %startBWpt(ptTable(k,:)) = 1;
        startBWpt(y(k),x(k)) = 1;
        
        targBW = imreconstruct(targBWpt,filled);
        startBW = imreconstruct(startBWpt,filled);

        if (sum(targBW(:) & startBW(:)) == 0)
        
            plot([x(k),x(loc)], [y(k),y(loc)], 'r', 'Linewidth', 3)
        end
    end
    if(0 == 0)
        waitbar(k/lngt,h,sprintf('%d%% complete', round(100*(k/lngt)) ) );
    end
end
    
delete(h)    


hold off

%knnsearch(ind2sub(size(cSec),find(cSecFillSkeleton)),[75,61]');
%This finds the index of the nearest point, x and y are swapped!
%asijdoiajsdoji


[ptsInSkelx, ptsInSkely] = ind2sub(size(BW),find(skeleton));
ptsInSkel = [ptsInSkelx, ptsInSkely];
% Operate in the endpoint space with attached endpoints removed, look only
% for other endpoints

% If we find something, reconnect at those two points
% % for k = 1:numel(b)
% %     plot(b{k}(:,2), b{k}(:,1), 'r', 'Linewidth', 3)
% % end
% Deskeletonize

end

function yesno = belongsTo(px1,px2,bw2)
%Where bw2 is the blob containing px2
if sum(ismember(px1,bw2) > 0)
    yesno = 1;
else
    yesno = 0;
end


end