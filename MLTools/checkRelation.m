function [prb] = checkRelation(image1, image2, binary)
%Plots the posterior probability or something
%It's something like P(v | image1, image2) where v-> vessel and image1 and
%2 are whatever you want to try correlating to

%binary is just a training binary
% %Next:
% - sum of both values should be one at every point, right?
% - Multiple Dimensions




N = sum(binary)/sum(~binary);
%Assumed: Image is the filtered image
image = normalizeSet(image1);
%intensities = double(image2)./255;
intensities = normalizeSet(image2);


unqInt = unique(intensities);

intTrue = intensities(binary);
intFalse = intensities(~binary);

prb = [];
pt = 1;

% Main Loop
%% So many of these weird processes could be sped up if I could deterministically figure out the number of entries in the end.
%%Work on parellelizing this

h = waitbar(0,'0%','Name','Generating Classifier Relation...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)
Len = length(unqInt');
j = 0;
for k = unqInt'
    if getappdata(h,'canceling')
        break
    end
    
    postBin = (intensities == k);
    %This is the logical matrix of the points of intensity k
    [comb, true, false] = prob2d(image(postBin), binary(postBin));
    %prb(pt) = true;
    pt = pt + 1;
    
    prb = [prb, [repmat(k,1,length(comb));comb;true]];
    if(mod(j,5) == 0)
        waitbar(j/Len,h,sprintf('%d%% complete',round(100*(j/Len))));
    end
    j = j + 1;
end

delete(h)

figure
%%Draw visualization
x=prb(1,:)';
y=prb(2,:)';
z=prb(3,:)';
dx=0.0025;
dy=0.0025;
x_edge=[floor(min(x)):dx:ceil(max(x))];
y_edge=[floor(min(y)):dy:ceil(max(y))];
[X,Y]=meshgrid(x_edge,y_edge);
Z=griddata(x,y,z,X,Y);
surf(X,Y,Z)
shading interp


hold off
title('3D Probability Plot')
xlabel('Intensity')
ylabel('Mexican Hat')
zlabel('Probability')
end


function [combTable,trueTable,falseTable] = prob2d(image, binary)
%Determines the posterior probability of "Truth" according to binary given
%contents of image
    trues = image(binary);
    falses = image(~binary);

    unqTrue = unique(trues(:));
    unqFalse = unique(falses(:));
    combTable = union(unqTrue(:)',unqFalse(:)');
    %trueTable = zeros(size( union( unqTrue(:)',unqFalse(:)' ) ));
    trueTable = [];
    falseTable = [];
    %Finds the amount of pixels in image1 of a specific intensity that are true
    for a = combTable
        trueTable = [trueTable, sum(trues(:) == a)];
        falseTable = [falseTable, sum(falses(:) == a)];

    end

    sumTable = trueTable + falseTable;
    trueTable = trueTable./sumTable;
    falseTable = falseTable./sumTable;

    %Same as above, but for false
    % for a = unqFalse(:)'
    %     falseTable = [falseTable, sum(falses(:) == a)];
    % end

    both = union(unqTrue,unqFalse);

%     figure, hold on
%     %originally unqTrue and unqFalse instead of combTable
%     plot(combTable,trueTable, 'g')
%     plot(combTable,falseTable,'r')
%     hold off
%     title('Probability Graph - Green: True, Red: False')
%     xlabel('Input Image Normalized Value')
%     ylabel('Probability')

end

% function out = normalizeSet(input)
% %Returns the values of a set normalized to between 0 and 1
% image = input - min(input(:));
% image = image./max(image(:));
% 
% out = round(double(image)*100)/100;
% end
