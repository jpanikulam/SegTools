function [outimg, outbc] = applyCORF(orig, image,sigma,thresh)
%Applies CORF and displays the generated outline
%First output arg: binarized image applied to input image, second output arg: diagonally shifted binarized CORF
%applyCORF(Original Image, Image to be CORF'd (I use Dickerell_Contrast),  CORF Sigma, CORF threshhold);

[o, bc] = CORF(image,sigma,thresh);


trans = [1,0,0;0,1,0;,3,3,1;];
trans = maketform('affine',trans);
outbc = imtransform(bc,trans,'XData',[1, size(bc,2)], 'YData', [1, size(bc,1)]);

sampfact = length(orig)/length(image);
if(sampfact > 1) %Automatically downsample the source image to match the CORF'd image (Maybe upsampling isn't a bad idea?
    appimg = downsample(orig, sampfact);
else
    appimg = orig;
end
if(size(orig,3) == 3) %If it's a color image, split RGB and color blue
    [r,g,b] = RGBSplit(appimg);
    b(outbc) = 255;
    outimg = cat(3,r,g,b);

else %If it's grayscale, just 255 it
    outimg = appimg;
    outimg(outbc) = 255;
    
end


figure, imshow(outimg);

end

function [ useimg ] = downsample( image, factor )
%Downsamples IMAGE by a factor of FACTOR
%   useimg = image(1:factor:end,1:factor:end,:);
useimg = image(1:factor:end,1:factor:end,:);

end

