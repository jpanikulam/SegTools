
function finimg = cont_eliminate(bwImg, minSize, percentile)
%% Removes objects from a bw image below a given size or percentile
% Takes an image, a minimum size, and a percentile flag
% The minimum size can be the number of pixels, or - if the percentile flag
% is set (by using 'percentile' as the argument (I should really fix that)
% Then it is the minimum percentile size
%
% Example: cont_eliminate(bwimg, 1000)
% Eliminates objects below area of 1000
% Example 2: cont_eliminate(bwimg, 95, 'percentile') 
% Eliminates objects below the 95th percentile
%
% Percentile defaults to false.

finimg = false(size(bwImg));

CC = bwconncomp(bwImg, 4);
[biggest] = cellfun(@numel,CC.PixelIdxList);

if nargin < 1
  error('ERROR: bwimg and minSize required - say minSize of 0 to take the largest object')
end

if nargin > 2
    if strcmpi(percentile,'PERCENTILE')
        titleStr = ['Continuity elimination below the ', num2str(minSize), 'th percentile']; 
        minSize = prctile(biggest, minSize);
    end
    
else
    titleStr = ['Continuity elimination below size ', num2str(minSize), ' pixels'];
end

if minSize > 0
    lgclAccept = CC.PixelIdxList(biggest>minSize);
    stkArr = vertcat(lgclAccept{1,:});
    finimg(stkArr) = 1;
    
else
    lgclAccept = CC.PixelIdxList(biggest==max(biggest));
    finimg(lgclAccept{1,:}) = 1;
end
% figure,imshow(finimg)
% title(titleStr);

end

