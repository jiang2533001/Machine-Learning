function result = calculate_sse(data, sample_index, index_length, mean)
    %Data is the original dataset
    %Sample_index is the holder for sample in the cluster
    %Index length is the number of samples in the cluster
    %Mean is the center of current cluster
    result = 0;
    for i = 1 : index_length
        linear_distance = data(sample_index(i),:) - mean;
        squre_distance = linear_distance * (linear_distance.');
        result = result + squre_distance;
    end
end

