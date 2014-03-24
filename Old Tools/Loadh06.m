h06ba = imread('C:\Users\Jacob\Documents\MATLAB\Segmentation\Healthy\Binary Decoupled\06_H\06_H_0001_arteries.tif');
h06bv = imread('C:\Users\Jacob\Documents\MATLAB\Segmentation\Healthy\Binary Decoupled\06_H\06_H_0002_Veins.tif');
h06o = imread('C:\Users\Jacob\Documents\MATLAB\Segmentation\Healthy\Original\06_h.jpg');
binaryveins = im2bw(h06bv(:,:,2),0.08);
binaryarteries = im2bw(h06ba(:,:,2),0.08);
binaryvessels = binaryarteries;
binaryvessels(binaryveins == 1) = 1;
G = h06o(:,:,2);