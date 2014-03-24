%%The whole process
%At some point, this will be on a computing cluster with a bunch of parfors
%simultaneously testing countless slightly different filters

%% Pass 3
% 
% W = wiener2(P,[7,7]); figure,imagesc(W)
% os2 = pass3ArrayGenerator(W); imagesc(os2)
% inVector = [double(P(:)),os2(:)];f

% filtG = fspecial('gaussian',[5,5],2);
% Ig = imfilter(P,filtG, 'same'); figure,imagesc(Ig)
%%
%There is some combination of tree'd filters that will give us what we
%want.
%It almost definitely includes some filtering/blurring.


% ZZ = histeq(imhmax(G,10,8));
% QL = (multipyramid(multipyramid(ZZ,2),-2));
% os4 = pass3ArrayGenerator(QL); imagesc(os4)
% 
% 



% 
% imcrop(P,[0,0,size(QL,2),size(QL,1)]);
% 
% I = imfill(P);
% figure,imagesc(imreconstruct(normalizeSet(os),normalizeSet(imgf)))
% figure,imagesc(imreconstruct(normalizeSet(os),normalizeSet(I)))

function [nb] = Process(inVector, classes, G)

nb = NaiveBayes.fit(inVector,classes);
C = nb.predict(inVector);
try
    figure;
    imshow( reshape(C,size(G)) )
    Out = reshape(C,size(G));
catch
    close(gcf);
    disp('G and C are of different sizes, do everything with return arg 3, which is the nb')
end
truepo = size( C( C & classes) )/size(C( classes == 1 ));
falpo = size( C( C & ~classes)) / size(C ( classes == 0 ));

falneg = size( C( ~C & classes ) ) / size(C( classes == 1 ));

disp(strcat('Correct Identifications: ', num2str(truepo), ' False Positives: ', num2str(falpo), ' False Negatives: ', num2str(falneg)));

%% Pass 2


% [segmented, filter] = Pass2Segmenter(G, binaryvessels);
% 
% dumb = checkRelation(filter, P, binaryvessels);
% if(input('Continue? 1,0: '))
%     
%     [HH,ts] = useCorrelatrix(filter,P, dumb);
%     %%I think checkRelation returns the table in reverse order? Why'd I do
%     %%that?
% end
