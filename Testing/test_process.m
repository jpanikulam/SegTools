%% Test Function!

function accuracy_table = test_process(dataset,func)

    for image_num = 1:length(dataset)
        image = dataset{1,image_num};
        ground_truth = dataset{2,image_num};
        
        %reshp = (reshape(resp(:,5),size(img_2_up_man))) > 0;
        response = pass5seg(image);
        figure,imshow(reshape_to_image(response(:,3),image));
        
        auto_segmented = func(dataset{1,image_num});
    
        
        
    end
end

function reshp = reshape_to_image(vector,orig)
    reshp = reshape(vector,size(orig(:,:,1)));
end