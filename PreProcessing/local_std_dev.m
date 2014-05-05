function [ lsd ] = local_std_dev( input_image, radius)
%local_std_dev returns the local standard deviation at each pxl
%   For each pixel in the image, the local z-score at that pixel
%   in a sample set of the surrounding pixels in a [$radius]  radius.
%   Radius defaults to 50.
%   Generated using the Jacob-Jacob-Jacobski method.
%   
% Standard deviation is equivalent to 
% sqrt( (1/n) * sum_all( ( x - mean(x))^2 ) )
%
% What's standard deviation?
% Good question.
% How do we find std dev convolutionally? 
% Well, hold my hand - let's go:
%
% Where n is the number of elements where "from 0 to n" means "for i = 0:n"
% variance = (1/n) sum( (xi + x_bar)^2  from 0 to n )
% = (1/n) sum( (xi^2 - 2*xi + x_bar^2)  from 0 to n )
% = (1/n) sum( (xi^2) from 0 to i ) - sum( (2*xi) from 0 to n ) + i*x_bar

if nargin < 2
    radius = 50;
end

op_image = double(input_image);

%Generate a raster circle
circle_size = [radius,radius].*2; %Radius -> diameter
circle = zeros(circle_size); 
circle( sub2ind(circle_size, radius,radius) ) = 1;
circle = double(bwdist(circle) < radius);

num_elements = sum(circle(:));

op_local_mean = local_mean(op_image, circle);
op_local_sum_2 = local_sum(2.*op_image, circle);
op_local_sum_square = local_sum(op_image.^2, circle);

variance = (1/num_elements) * ( op_local_sum_square - op_local_sum_2 + (num_elements*(op_local_mean.^2)) );
figure,imagesc(variance);
title(' r variance ');

std_dev = sqrt(abs(variance));
figure,imagesc(std_dev);
title('std deviation')

z_score = (op_image - op_local_mean)./sqrt(std_dev);
figure,imagesc(z_score);
title('Z Score of each pixel')

lsd = z_score;

figure,imshow(z_score > 0);
title('Local Z-Score > 0, how do you like me now!?');
end

function lm = local_mean(op_image, convmap)
%% Returns an image where each pixel is the mean of its surrounding pixels that are 1's in the convmap. 
loc_mean = conv2(op_image, convmap./sum(convmap(:)));
radius = length(convmap)/2;
lm = loc_mean(1:end-(2*radius)+1,1:end-(2*radius)+1);
end
function ls = local_sum(op_image, convmap)
%% Returns an image where each pixel is the sum of all surrounding pixels that are 1's in the convmap.

loc_sum = conv2(op_image, convmap);
radius = length(convmap)/2;
ls = loc_sum(1:end-(2*radius)+1,1:end-(2*radius)+1);
end

