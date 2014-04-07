

function difference = local_mean_diff(image, hsize)
%% Local Mean Difference
% Finds the dissimilarity between a pixel and its neighboring pixels
% To do this, I take the difference between each pixel and the average of
% all of the pixels in a radius of hsize around it

doPlot = 0;

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
if doPlot == 1
    figure,imagesc(double(avg_value)-double(image));
end
