
%% Note to self: Improve the friggin naming criteria

function result = visualize_elimination_criteria(bw,property, maxval)
%% Visualize criteria for eliminating objects
% This function takes an image and generates a scaled blue-red image that
% shows each bw conncomp region (each object) colored according to the
% magnitude of some property
% Ex: visualize_elimination_criteria(bwimg, 'area')
%
% Permissible properties are: 
%   'Area','Perimeter','PixelIdxList','Eccentricity','Solidity'

if nargin < 2
    property = 'all';
end
if nargin < 3
    maxval = inf;
end

connectivity = bwconncomp(bw);

property_cells = regionprops(connectivity,'Area','Perimeter','PixelIdxList','Eccentricity','Solidity');

% Skeletal data can't be used unless reconstructive measures are used,
% because the list indices are not necessarily synced. i.e. the same object
% in the image may not have the same numerical label
% 
% skeleton = bwmorph(bw,'skel',30);
% skeleton_connectivity = bwconncomp(skeleton);
% skeleton_property_cells =  regionprops(skeleton_connectivity,'Area','Perimeter','PixelIdxList','Eccentricity','Solidity');

result = double(zeros(size(bw)));
result_skel = double(zeros(size(bw)));

for region_num = 1:size(property_cells,1)
    region = property_cells(region_num);
    
    area = region.Area;
    perimeter = region.Perimeter;
    pxls = region.PixelIdxList;
    eccentricity = region.Eccentricity;
    %It seems like eccentricity > 0.9 is a strong filter
    
    solidity = region.Solidity;
    
    %rProps gives an orientation, it's okay.
    
    %result(pxls) = perimeter/sqrt(area);
    if strcmp(property,'all')
        result(pxls) = eccentricity;
    else
        try
            if eval(property) < maxval
                eval(['result(pxls) = ', lower(property),';']);
            end
        catch
            disp('Not an acceptable property');
            break
        end
    end
    
    %result(pxls) = solidity;
   
    % Using skeleton data is impossible unless using reconstructive
    % measures to ensure the skeleton connected componenet labels are in
    % sync with the bw connected components.
    
    %result(pxls) = region_num;
    %result_skel(skel_pxls) = region_num;
    
end

%Potential: Diff, filled area and area
figure,imagesc(result);
%figure,imagesc(result_skel);
end