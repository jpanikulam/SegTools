function LABadjusted = colorCorrect(rgbImage,plot)

if nargin < 1
  error('ERROR: Image Required')
end

doPlot = 0;

if nargin == 2
    if strcmpi(plot,'plot')
        doPlot = 1;
    end
end

if(size(rgbImage,3) < 3)
    error('RGB Image Required');
    return
end

cform = makecform('srgb2lab');
labImage = applycform(rgbImage,cform);

imL = labImage(:,:,1);
imA = labImage(:,:,2);
LABadjusted = imcomplement(normalizeSet(imL)) + normalizeSet(imA);
%figure,imagesc(LABadjusted)

G = rgbImage(:,:,2);
Pfilled = imfill(adapthisteq(G));
PAfilled = adapthisteq(Pfilled,'distribution','exponential');

result = imcomplement(normalizeSet(PAfilled)) + LABadjusted;
if(doPlot)
    figure,imagesc(LABadjusted)
    title('Lab Adjusted')
    figure,imagesc(result);
    title('Returned')
end