function result = reassembler(bwimg, weights, plot)
%% This function makes an effort to reassemble a fractured binary image
%So: How do we reassemble a fractured bw image?
%I'll tell ya: Jacob Panikulam's patented reassembly transform.
%Weights is a matrix of size = bwimg, where the each pixel is the
%_complement_ of vessel probability

%% Notes:
% Using Bayes' posteriors does not give satisfactory results.
% Using PAfilled seems to give pretty good results
% colorCorrect result even better
% Forget everything - input colorCorrect result. Posterior probabilities
% won't work

%% Todo:


if nargin < 2
  error('ERROR: bwimg and weights required')
end

doPlot = 0;

if nargin == 3
    if strcmpi(plot,'plot')
        doPlot = 1;
    end
end




if islogical(bwimg)

else 
   bwimg = logical(bwimg); 
    
end

filled = ~ContEliminator(imcomplement(bwimg),1000); %Quality leaves something to be desired
%skeleton = bwmorph(filled,'skel',30);
%endpts = bwmorph(skeleton,'endpoints');



%% SO:
weightMatrix = mat2gray(weights); % If weights is already grayed, there's no change

distMatrix = graydist(weightMatrix,filled);
result = distMatrix < 0.5;
iterations = 1;
for k = 1:iterations
    result = graydist(weightMatrix,result) < 0.2;
end

closed = bwmorph(result,'close');
result = ContEliminator(closed,95,'percentile'); % Maybe just do the largest body? Yes - do the largest body

%result = distMatrix < 1;
%result = filled + ((distMatrix < 1) & (distMatrix > 0) & (dilatedEndpts));


if(doPlot)
    %figure,imagesc((2*double(bwimg)) - double(result))
    showable = cat(3,255*bwimg,255*result,0*result);
    figure,imshow(showable);
    %figure,imshow(distMatrix < 1);
end

end

%% JP EE UF 2014 - OQULUS