clc
% Read file
train_data = dlmread('knn_train.csv');
test_data = dlmread('knn_test.csv');

% Prepare the traing data
X_train = train_data(:,2:end);
Y_train = train_data(:,1);

% Prepare for the test data
X_test = test_data(:,2:end);
Y_test = test_data(:,1);

% Prepare for the K list
total_result = [];
k_list = [];
k_max = 100;
for k = 1:k_max
    if mod(k,2) ~= 0
        k_list = [k_list, k];
    end
end
%k_list = k_list(:,2:end);
k_function(k_list, X_train, Y_train, X_test, Y_test);
