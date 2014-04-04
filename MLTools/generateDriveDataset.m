function set = generateDriveDataset
%% No arguments, just an output cell array. Currently storing the first 7.
% This function combs through all of the "TEST" DRIVE database images and
% Assembles them into one more easily analyzed grouping
% REQUIRES that all of the files in both the segmented and rgb directory
% are images. Otherwise, we're boned, right? right.
% This is not very robust, and will fall apart if the directory isn't
% perfect


%%
%%Determine the paths for the RGB images and the binary
%I am really not sure how to deal with structs, so I create these behemoths
originalPath =  '.\Jacob Segmentation\DRIVE\test\images';
rgbContents = struct2cell(dir(originalPath));

binaryPath = '.\Jacob Segmentation\DRIVE\test\1st_manual';
bwContents = struct2cell(dir(binaryPath));


numImgs = min(length(rgbContents), length(bwContents));
%How many images to iterate
images_to_iterate = 7;
%How much to upsample the images
scale_amt = -2;
%Empty cell array of necessary size
set = cell(2,images_to_iterate - 2);


%% Loop through all of the images available to us
% Must start with 3 - the first to entries in 'dir' are '.' and '..'
for k = 3:images_to_iterate + 2
    imName = strrep(rgbContents{1,k}, '_test.tif', '');

    rgbImg = imread( strcat( originalPath, '\', imName, '_test.tif' ) );
    rgbImg = multipyramid(rgbImg, scale_amt);
    
    bwImgLoc = strcat( binaryPath, '\', imName, '_manual1.gif' ) ; %The folder containing the binary images for this particular image
    %The first two entries in the 'dir' result are '.' and '..' so we start
    %with 3 and 4
    try
        bwimg1 = imread( bwImgLoc );
        bwimg1 = multipyramid(bwimg1, scale_amt);
    catch
        disp(strcat('Image: ', imName, ' Is not available in both binary and RGB'));
        continue
    end
    %Threshhold and clean up the binary images 
    %(They import as RGB with artifacts)
    bwimg1 = im2bw(bwimg1, 0.05);
    bwimg1 = bwmorph(bwimg1, 'clean');

    binaryVessels = bwimg1;
    
    %set{1, k-2} = rgbImg(:,:,2); %Cell section 1 is the green layer
    set{1, k-2} = rgbImg;
    set{2, k-2} = binaryVessels; %Cell section 2 is the binary

end
end
