function class = KNN(point, k, data, class_labels)
    dist = [];
    for i=1:length(data)
        dist(i) = Euclidian(point, data(i,:));
    end
    [dist_sorted, idx_sorted] = sort(dist);
    n_class = [];
    for i=1:k
        if length(n_class) < class_labels(idx_sorted(i)) +1
            n_class(class_labels(idx_sorted(i))+1) = 0;
        end
        n_class(class_labels(idx_sorted(i))+1) = n_class(class_labels(idx_sorted(i))+ 1) + 1;
    end
    [M,I] = max(n_class);
    class = I-1;
end

function dist = Euclidian(p1, p2)
    dist = sqrt((p1(1)-p2(1))*(p1(1)-p2(1)) + (p1(2)-p2(2))*(p1(2)-p2(2)));
end