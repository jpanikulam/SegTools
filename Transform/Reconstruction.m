%%Isolate

function useVector = Reconstruction(img)
%Give this an RGB or green layer image and it will return a 4th pass
%training vector for the naive bayes classifier
if(size(img,3) > 1)
    G = img(:,:,2);
else
    G = img;
end

Pfilled = imfill(adapthisteq(G));
exclude = G < 5;
exc = ~exclude(:);



se = strel('disk', 20);
PAfilled = adapthisteq(Pfilled,'distribution','exponential');
Ie = imerode(PAfilled, se);
Iobr = imreconstruct(Ie, PAfilled);
% figure, imshow(Iobr), title('Opening-by-reconstruction (Iobr)')

% Iobrd = imdilate(Iobr, se);
% Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
% Iobrcbr = imcomplement(Iobrcbr);
% figure, imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')

extraContrast = adapthisteq(imcomplement(Iobr), 'distribution', 'exponential');
coeff = ones(10)/100;
Avg = conv2(normalizeSet(extraContrast),coeff,'same');




cwtmexh = cwtft2(Iobr,'wavelet','mexh','scales',7); %figure,imagesc(cwtmexh.cfs);
cwtmexh2 = cwtft2(Iobr,'wavelet','mexh','scales',5);%figure,imagesc(cwtmexh2.cfs)
cwtmexh3 = cwtft2(Avg,'wavelet','mexh','scales',5);%figure,imagesc(real(cwtmexh3.cfs))
inVector = [normalizeSet(extraContrast(:)),cwtmexh.cfs(:),cwtmexh2.cfs(:),cwtmexh3.cfs(:)];

useVector = bsxfun(@times,exc,inVector);

end