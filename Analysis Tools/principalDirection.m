%% PCA Experiment

function vecs = principalDirection(bwimg, plot)
%Input a black and white image with a single object (Doesn't have to be logical)
%You will be returned the principal component vectors, such that if their
%tails were places on the centroid of the bw object, the largest vector
%would point toward its principle orientation, and the smaller oriented
%along its 'width'
%
%Really only works for convex shapes
%
%Note: Neither vector indicates an actual length or width - instead they
%correspond to variance in each direction NTS//Fix that //
%
%Additionally: do principalDirection(bwimg, 'plot') if you'd like do
%display the vectors.


if nargin < 1
  error('ERROR: bwimg required')
end

doPlot = 0;

if nargin == 2
    if strcmpi(plot,'plot')
        doPlot = 1;
    end
end

[ptsx,ptsy] = ind2sub(size(bwimg),find(bwimg));
observations = zscore([ptsx,ptsy]);
[coeff, score] = pca(observations);
varianceTable = var(score); %NTS// Wikipedia suggests scale by sqrt of eigenvalue? Which eigenvalue? Wtf? //
vecs = bsxfun(@times,coeff,varianceTable); %The vectors are scaled by their component variable's variance in the principle component space



if(doPlot)
    S = regionprops(bwimg,'centroid');
    mid = S.Centroid;
    figure,imshow(bwimg)
    hold on
    quiver(mid(1),mid(2),coeff(1,1),coeff(1,2),varianceTable(2),'linewidth',3)
    quiver(mid(1),mid(2),coeff(2,1),coeff(2,2),varianceTable(1),'linewidth',3)
    hold off
end

%% J.P. EE, UF Feb 2014