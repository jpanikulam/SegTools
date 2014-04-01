%% Clean up an eye image before processing

%clean_image serves to remove image noise using a gaussian blur

function cleaned = clean_image(image, amt)

if nargin < 2
    amt = 64;
end

gauss_filt = fspecial('gaussian', [amt,amt],2); %play with sigma

gauss = imfilter(image,gauss_filt);%,'replicate');

cleaned = gauss;
%Dear reader: Can you guess why I did that?

end
%% J.P. EE, UF