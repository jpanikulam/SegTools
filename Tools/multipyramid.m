function outimg = multipyramid(img, amt)
outimg = img;

if(amt > 0)
    for k = 1:amt
        outimg = impyramid(outimg,'reduce');
    end
elseif(amt < 0)
    for k = 1:abs(amt)
        outimg = impyramid(outimg, 'expand');
    end
end