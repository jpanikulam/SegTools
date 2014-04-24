%% Test Function!

function accuracy_table = test_process(dataset,func)
%% Run a segmentation function on a dataset and output accuracy results
% dataset is a cell array, where dataset{1,n} is the nth color image, and
% {2,n} is the nth ground truth image.
% func is a lambda function containing the segmentation function
% Ex: 
%   drive_set = generateDriveDataset();
%   mySegFunc = @(image) pass5seg(image);
%   accuracy_table = test_process(drive_set, mySegFunc);

accuracy_table = []; %Change in size is not significant enough to warrant preallocating
    for image_num = 1:length(dataset)
        image = dataset{1,image_num};
        ground_truth = dataset{2,image_num};
                
        auto_segmented = func(image);
        
        test = auto_segmented(:);
        truth = ground_truth(:);
        [truepo,falpo,falneg] = measure_accuracy(test,truth);
        disp(['Image ', num2str(image_num)])
        disp(['True Positives: ', num2str(truepo)]);
        disp(['False Positives: ', num2str(falpo)]);
        disp(['False Negatives: ', num2str(falneg)]);
        
        accuracy_table = [accuracy_table, truepo];
    end
end

function reshp = reshape_to_image(vector,orig)
    reshp = reshape(vector,size(orig(:,:,1)));
end

function [truepo,falpo,falneg] = measure_accuracy(test,truth)
        %truepo = size( test( test & truth) )/size(test( truth == 1 ));
        truepo = sum(truth==test)/length(test);
        
        falpo = sum(test & ~truth) / length(test);
        falneg = sum(~test & truth) / length(test);
end