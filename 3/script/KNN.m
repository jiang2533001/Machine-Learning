function class = KNN(k, test_x, validation_x, validation_y)  
    % calculate the distance
    row = size(validation_x, 1);
    col = size(validation_x, 2);
    distance_list  = zeros(row, 2);

    for i = 1:row
        distance = 0.;
        for j = 1:col
            if j == 23
                distance = distance + (test_x(1,j) - validation_x(i,j)).^2;
            else
                distance = distance + (test_x(1,j) - validation_x(i,j)).^2;
            end
        end
        distance_list(i, 1) = sqrt(distance);
        distance_list(i, 2) = validation_y(i, 1);
    end

    % sort the nearest neighbor list
    nearest_neighbor = sortrows(distance_list, 1);
    
    % find class
    if(sum(nearest_neighbor(1:k, 2)) > 0 )
        class = 1;
    else
        class = -1;
    end
end 