function LOOCV = getLOOCV(K)
    load lab3_2.mat;

    data = lab3_2;
    nr_of_classes = 2;

    % Class labels
    class_labels = floor( (0:length(data)-1) * nr_of_classes / length(data) );

    n_correct = 0;
    for i=1:length(data)
        test_data = data;
        test_labels = class_labels;
        test_data(i,:) = [];
        test_labels(i) = [];
    
        result = KNN(data(i,:),K,test_data,test_labels);
        if result == class_labels(i)
            n_correct = n_correct + 1;
        end
    end

    LOOCV = 1 - (n_correct / length(data));
end