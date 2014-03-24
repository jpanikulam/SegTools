function pMap = correlatorPmap(I2,I1, correlator)
%This function returns the 2D probability map of an image given a
%correlator from checkRelation.

I1 = normalizeSet(I1);
I2 = normalizeSet(I2);

sumSteps = length(correlator);
pMap = double(zeros(size(I1)));

% h = waitbar(0,'0%','Name','Computing Probability Map...',...
%             'CreateCancelBtn',...
%             'setappdata(gcbf,''canceling'',1)');
% setappdata(h,'canceling',0)
% warning('off','images:initSize:adjustingMag')
%%Waitbar can't be used because of parallelization. There are ways around
%%this, but I don't think they're worth finding just yet.
%%Could improve speed by using intersect isntead of &
AA = correlator(1,:);
BB = correlator(2,:);
CC = correlator(3,:);

ZZ = I1(:);
YY = I2(:);
VV = cell(1,length(correlator));
GG = cell(1,length(correlator));
parfor l = 1:sumSteps
%     if getappdata(h,'canceling')
% %         break
%     end
    %%Method 2 - using parellelization, this is twice as fast as the other
    %%method
    list1 = find(ZZ == AA(l));
    list2 = find(YY == BB(l));
    trueList = intersect(list1,list2); 
    VV{l} = trueList;
    GG{l} = CC(l);
    %%FIGURE OUT HOW TO PARELLELIZE THIS
    
    
    %%Method 1 - very slow, need to improve. I think the &ing isn't
    %%helping, doing a find, intersect will be faster.
%     agreements = (I1 == AA(l)) & (I2 == BB(l))
%     pMap(agreements) = CC(l);

%     if(mod(l,15) == 0)
%         waitbar(l/sumSteps,h,sprintf('%d%% Complete',round(100*(l/sumSteps))));
%     end
end
%delete(h)
for k = 1:length(VV)
pMap(VV{k}) = GG{k};
end

figure,imagesc(pMap)