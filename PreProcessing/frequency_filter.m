%% Frequency Filtering

function filtered = frequency_filter(image)
%% Separating an image features into high and low frequency bands
% This doesn't quite work as well as I thought it might
% Try implementing this directly on the fft

close all

hz=fspecial('sobel');
filter_hz=imfilter(double(image),hz,'replicate', 'conv');

figure,imshow(filter_hz);
title('Unchanged')

log = fspecial('log', [45,45], 0.1);
filter_laplace = imfilter(double(image),log,'replicate','conv');
figure,imagesc((filter_laplace))
title('Llog');

log = fspecial('log', [45,45], 0.01);
filter_laplace = imfilter(double(image),log,'replicate');
figure,imagesc((filter_laplace))
title('Log - Correlation');

%Fc=fftshift(F); % move the origin of the transform to the center of the frequency rectangle
%S2=log(1+abs(Fc)); % use abs to compute the magnitude (handling imaginary) and use log to brighten display
%figure, imshow(S2,[])




end