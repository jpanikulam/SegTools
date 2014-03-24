function [intiles, outtiles] = NNTileData(image,binary)

tiling = [8, 8];
useimg = adapthisteq(image);
usebin = binary;
for k = 1:3
    useimg = impyramid(useimg, 'reduce');
    usebin = impyramid(usebin, 'reduce');
end

xdiv = floor(size(image,1)/tiling(1));
ydiv = floor(size(image,2)/tiling(2));


needsize = [xdiv*ydiv, prod(tiling)]; %Couldn't make this work properly, imcrop area is not reliable
%intiles = zeros(needsize);
%outtiles = zeros(needsize);
%size(intiles)

intiles = [];
outtiles = [];



for k = 0:xdiv
    for j = 0:ydiv  
        %tileimg = imcrop(useimg, [[k,j].*tiling, ([k,j]+1).*tiling]); %Something like this is the key
        %tilebin = imcrop(usebin,[[k,j].*tiling, ([k,j]+1).*tiling]);
        
        tileimg = imcrop(useimg, [[k,j].*tiling, tiling]); %Something like this is the key
        tilebin = imcrop(usebin,[[k,j].*tiling, tiling]);
        
%         disp('Tile Sizes')
%         [[k,j].*tiling, ([k,j]+1).*tiling]
%         disp('Sizes')
%         [size(tileimg),size(tilebin)]
%         figure, imshow(tileimg)
        
        %size(reshape(tileimg, 1, prod(tiling)));
        if(size(tileimg) >= tiling)
%             size(tileimg)
%             size(reshape(tileimg, 1, numel(tileimg)))
%             intiles = [intiles; reshape(tileimg, 1, numel(tileimg))];
%             outtiles = [outtiles; reshape(tilebin, 1, numel(tilebin))];
            intiles = [intiles; tileimg(1:64)];
            outtiles = [outtiles; tilebin(1:64)];
        end
    end
end


intiles = double(intiles)';

outtiles = double(outtiles)';
outtiles(outtiles == 1) = 255;

end