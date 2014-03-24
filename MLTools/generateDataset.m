function set = generateDataset

%%This function combs through all of the "health" gold standard images and
%%Assembles them into one more easily analyzed grouping
%%REQUIRES that all of the files in both the segmented and rgb directory
%%are images. Otherwise, we're boned, right? right.
%%This is not very robust, and will fall apart if the directory isn't
%%perfect


%%
%%Determine the paths for the RGB images and the binary
%I am really not sure how to deal with structs, so I create these behemoths
originalPath =  '.\Segmentation\Healthy\Original';
rgbContents = struct2cell(dir(originalPath));

binaryPath = '.\Segmentation\Healthy\Binary Decoupled';
bwContents = struct2cell(dir(binaryPath));


numImgs = min(length(rgbContents), length(bwContents));

set = cell(2,numImgs - 2);


%%Loop through all of the images available to us
for k = 3:numImgs
    imName = strrep(rgbContents{1,k}, '.jpg', '');

    rgbImg = imread( strcat( originalPath, '\', imName, '.jpg' ) );

    bwImgLoc = strcat( binaryPath, '\', imName ) ; %The folder containing the binary images for this particular image
    bwImgList = struct2cell( dir(bwImgLoc) );

    %The first two entries in the 'dir' result are '.' and '..' so we start
    %with 3 and 4
    try
        bwimg1 = imread( strcat( bwImgLoc, '\', bwImgList{1, 3} ) );
        bwimg2 = imread( strcat( bwImgLoc, '\', bwImgList{1, 4} ) );
    catch
        disp(strcat('Image: ', imName, ' Is not available in both binary and RGB'));
        continue
    end
    %Threshhold and clean up the binary images 
    %(They import as RGB with artifacts)
    bwimg1 = im2bw(bwimg1, 0.05);
    bwimg2 = im2bw(bwimg2, 0.05);

    bwimg1 = bwmorph(bwimg1, 'clean');
    bwimg2 = bwmorph(bwimg2, 'clean');

    binaryVessels = bwimg1 | bwimg2;
    
    %set{1, k-2} = rgbImg(:,:,2); %Cell section 1 is the green layer
    set{1, k-2} = rgbImg;
    set{2, k-2} = binaryVessels; %Cell section 2 is the binary

end
end
