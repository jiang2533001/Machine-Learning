function mean = calculate_mean(data,  sample_index, index_length, sample_length)
    % mean is the new cluster center
    % data is original data set
    % sample_index is the index holder for current cluster
    % index_length is the num of sample in the current cluster
    % sample_length is the vector length
    mean = zeros(1,sample_length);
    for i = 1:index_length
        index = sample_index(i);
        mean = mean + data(index,:);
    end
    mean = mean/index_length;
end

