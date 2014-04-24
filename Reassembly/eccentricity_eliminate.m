function cleaned = eccentricity_eliminate(bwimg, min_area_in, max_area_in)
%% This function eliminates regions with a bounding box below area boxthresh^2 with an eccentricity below 0.9.
% Takes a bwimg that is noisy, and optionally the size of the minimum
% bounding box. The default bounding box size is 100x100.
% Example: eccentricity-eliminate(vesssel_segmented_crappy, 200) for a
% 200x200 bounding box.
if nargin < 2
    max_area = 100*100;
else
    max_area = max_area_in;
end

if nargin < 3
    min_area = 100;
else
    min_area = min_area_in;
end

connectivity = bwconncomp(bwimg); 
property_cells = regionprops(connectivity,'Area','Perimeter','PixelIdxList','Eccentricity','Solidity','BoundingBox');

result = double(zeros(size(bwimg)));

%% Elimination
% In the following loop and assignments, we are taking the areas of size
% less than area_thresh and determining whether or not they have acceptable
% eccentricity.

for region_num = 1:size(property_cells,1)
    region = property_cells(region_num);
    
    area = region.Area;
    perimeter = region.Perimeter;
    pxls = region.PixelIdxList;
    eccentricity = region.Eccentricity;
    
    %It seems like eccentricity > 0.9 is a strong filter
    
    solidity = region.Solidity;
        
    %result(pxls) = perimeter/sqrt(area);
    %result(pxls) = solidity;

    if (area < max_area) && (area > min_area)
        result(pxls) = eccentricity;
    end
end


cleaned = result > 0.9;