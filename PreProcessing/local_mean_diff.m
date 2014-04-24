

function difference = local_mean_diff(image, hsize, doPlot)
%% Local Mean Difference
% Finds the dissimilarity between a pixel and its neighboring pixels
% To do this, I take the difference between each pixel and the average of
% all of the pixels in a radius of hsize around it

if nargin < 3
    doPlot = 0;
end

%coeff = ones(hsize);
%coeff = coeff./numel(coeff);
%avg_value_padded = conv2(double(image),coeff);
%avg_value = avg_value_padded(1:size(image,1),1:size(image,2));
%avg_value = avg_value_padded(end-size(image,1)+1:end,end-size(image,2)+1:end);

%% Real Function.
%Turns out pillbox method is VASTLY superior to square convolution. This
%is also because I didn't accurately compensate for the "phase shift" (lol)
%of the image when conv2 is applied.
avg_filter = fspecial('disk',hsize(1));
avg_value = imfilter(image,avg_filter);

difference = double(avg_value)-double(image);

sqrdiff_en = (double(avg_value).^2 - double(image).^2);
sqrdiff = sign(sqrdiff_en).*(abs(sqrdiff_en).^(1/2));

if doPlot == 1
    figure,imagesc(difference)
    title('Difference')
    figure,imagesc(sqrdiff)
    title('Square Difference')
end
