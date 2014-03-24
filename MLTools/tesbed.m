
% 
exclude = bwmorph(Pfilled < 10, 'dilate', 10);
% exclude = ~Exclusion;
exc = ~exclude(:);

%inVector = [normalizeSet(rotMorl2(exc)), normalizeSet(Pfilled(exc)), normalizeSet(filter(exc))];
% Cls = bsxfun(@times, classes, exc);
useVector = bsxfun(@times,exc,inVector);
Cls = classes;
% useVector = inVector;
% useVector(~exc,:) = NaN;

[nb] = Process(useVector, Cls, G);

save('NaiveBayes.mat', 'nb');
% A = normalizeSet(rotMorl2);
% B = normalizeSet(Pfilled);
% C = normalizeSet(filter);

% fits = [ A(:), B(:), C(:) ];
clear predictions
pdd = nb.predict( useVector );
predictions = reshape( pdd, size(G) );
figure,imshow( predictions )
title('Predictions')

Ptt = nb.posterior( useVector );
figure,imagesc(reshape(Ptt(:,1),size(G))) ;
title('Posteriors')
clear Ptt nb pdd Cls exclude