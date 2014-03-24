function [segmented,truesR] = useCorrelatrix(I2,I1, correlator)
%Given a 3xN matrix called the "Correlator" we take the pixels that have a
%probability of being a vessel greater than 50% and make those trues.



% P = normalizeSet(double(adapthisteq(image)));
% 
% cwtmexh = cwtft2(P,'wavelet','mexh','scales',7);
% filtered = normalizeSet(cwtmexh.cfs);
%% make it work for any inputs

I1 = normalizeSet(I1);
I2 = normalizeSet(I2);

binary = zeros(size(I1));
HH = correlator(3,:) > .5;

%highPixels = correlator(HH);

AA = correlator(1,HH); %%This is the list of first row values in Correlator
BB = correlator(2,HH); %%2nd row values

% 
% x=correlator(1,:)';
% y=correlator(2,:)';
% z=correlator(3,:)';
% dx=0.005;
% dy=0.005;
% x_edge=[floor(min(x)):dx:ceil(max(x))];
% y_edge=[floor(min(y)):dy:ceil(max(y))];
% [X,Y]=meshgrid(x_edge,y_edge);
% Z=griddata(x,y,z,X,Y);
%%Check for only I2 locations where 

%%-----------%%

%%%% Using Z, work some kind of (x*200,y*200) magic where we check for
%%%% coordinates




trues = [];


%%Could presize Trues using ismember?
%% Crawl through the correlator and find all of the vectors above p = .5

Len = length(AA);

% h = waitbar(0,'1','Name','Segmenting Image...',...
%             'CreateCancelBtn',...
%             'setappdata(gcbf,''canceling'',1)');
% setappdata(h,'canceling',0)
%%Can't use waitbar with parfor, (ways around, will look someday)
%%Cuts execution time in half, easily.
parfor k = 1:Len
%     if getappdata(h,'canceling')
%         break
%     end
    %%Method 2.1
    %truthImage((I1 == AA(k)) & (I2 == BB(k))) = 1;
    
    %%Method 1 - faster than Method 2 :(
    %This re-uses a lot of information. Could speed this up by being clever
    intList = find(I1 == AA(k));
    mexList = find(I2 == BB(k));
    niceList = intersect(intList,mexList);
    trues = [trues; niceList];
%     if(mod(k,15) == 0)
%         waitbar(k/Len,h,sprintf('%d%% complete',round(100*(k/Len))));
%     end
    
end
% delete(h)


binary(trues) = 1;
figure,imshow(binary)
segmented = binary;
truesR = trues;

end

