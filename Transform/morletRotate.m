function [ imgr,imgi, imgf ] = morletRotate( P , sc)
%% Do not use this function - it will cause a crash
%morletRotate - Rotates a morlet wavelet at intervals of 10deg and takes
%the maxima
%   nothing too funky fresh

%cwtmorl = cwtft2(P,'wavelet',{'morl',{6,1,1}},'scales',sc,'angles',0:deg2rad(10):pi-deg2rad(10));
%cwtmorl = cwtft2(P,'wavelet',{'esmexh', {1,0.5}},'scales',5,'angles',0:deg2rad(10):pi-deg2rad(10));
imgi = max(imag(cwtmorl.cfs),[],5);

imgr = max(real(cwtmorl.cfs),[],5);

imgf = min(abs(cwtmorl.cfs),[],5).^2;

figure,imagesc(imgi)
title('imaginary maximum')
figure,imagesc(imgr)
title('real maximum')
figure,imagesc(imgf)
title('Image absd')
end

