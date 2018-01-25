function k_function(k_list, X_train, Y_train, X_test, Y_test)
    % number of errors of training data
    % ==================================
    row = size(X_train, 1);
    size_k = size(k_list,2);
    train_errors_list = zeros(size_k, 1);
    norm_X_train = normc(X_train);
     
    for i = 1:size_k
        train_errors = 0;
        for j = 1:row
            if KNN(k_list(1,i), norm_X_train(j,:), norm_X_train, Y_train) ~= Y_train(j, 1)
                train_errors = train_errors + 1;
            end
        end
        train_errors_list(i, 1) = train_errors;
    end
 
    % Make plot
    % ==================================
    figure;
    plot(k_list, train_errors_list);
    title('Number of Train Error');
       
    % Leave-one-out cross-validation errors
    % ==================================
    cross_validation_errors_list = zeros(size_k, 1);
    
    for i = 1:size_k
        train_errors = 0;
        for j = 1:row
            if j == 1
                X_train_temp = norm_X_train(2:end,:);
                Y_train_temp = Y_train(2:end,:);
            elseif j == row
                X_train_temp = norm_X_train(1:end-1,:);
                Y_train_temp = Y_train(1:end-1,:);
            else
                X_train_temp = [norm_X_train(1:j-1,:)' norm_X_train(j+1:end,:)'];
                X_train_temp = X_train_temp';
                Y_train_temp = [Y_train(1:j-1,:)'  Y_train(j+1:end,:)'];
                Y_train_temp = Y_train_temp';
            end
            
            if KNN(k_list(1,i), norm_X_train(j,:), X_train_temp, Y_train_temp) ~= Y_train(j, 1)
                train_errors = train_errors + 1;
            end
        end
        cross_validation_errors_list(i, 1) = train_errors / row;
    end
    
    % Make plot
    % ==================================
    figure;
    plot(k_list, cross_validation_errors_list);
    title('Cross Validation Error');
    
    % number of errors of testing data
    % ==================================
    row = size(X_train, 1);
    size_k = size(k_list,2);
    test_errors_list = zeros(size_k, 1);
    norm_X_train = normc(X_train);
    norm_X_test = normc(X_test);
    
    for i = 1:size_k
        test_errors = 0;
        for j = 1:row
           if KNN(k_list(1,i), norm_X_test(j,:), norm_X_train, Y_train) ~= Y_test(j, 1)
                test_errors = test_errors + 1;
           end
            test_errors_list(i, 1) = test_errors;
        end
    end
    
    % Make plot
    % ==================================
    figure;
    plot(k_list, test_errors_list);
    title('Number of Test Error');
    
    % Make plot of combining three kinds of errors
    figure;
    hold all
    plot(k_list, cross_validation_errors_list, 'r');
    plot(k_list, train_errors_list/row, 'b');
    plot(k_list, test_errors_list/row, 'g');
    legend('cross validation error','train error', 'test error');
    title('Compare these three kinds of error');  
end

