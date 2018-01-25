% CS434 Implement Assignment 2 ----- Problem 2
% Logistic Regression
% Wenbo Hou & Zhi Jiang
% 4/18/2017
clear
clc
train_data = dlmread('train_data.csv');
test_data = dlmread('test_data.csv');

iteration =  1000;
% Prepare the traing data
X_train = train_data(:,1:end-1);
X_train = [ones(1400,1) X_train];
Y_train = train_data(:,end);

% Prepare for the test data
X_test = test_data(:,1:end-1);
X_test = [ones(800,1) X_test];
Y_test = test_data(:,end);

% The learning rate from problem 1 
learning_rate = 0.000000005;

% Initial Weight vector
W = zeros(1,257);

% Create array to hold the accurancy calculated per iteration
train_accurancy = zeros(iteration,1);
test_accurancy = zeros(iteration,1);

for a = 1:iteration
        d = zeros(1,257);
        for i = 1:1400
            Y_predict =  1./(1.+exp(-X_train(i,:)*(W.')));
            coefficient = Y_train(i,:) - Y_predict;
            gradient =  coefficient * X_train(i,:);
            d = d + gradient;          
        end
        W = W + learning_rate*d;
        
        % Calculate the model accurancy with train data
        for i = 1:1400
            Y_predict = 1/(1+exp(-X_train(i,:)*(W.')));
            if abs(Y_predict - Y_train(i,:)) <= 0.5
                train_accurancy(a,:) = train_accurancy(a,:) + 1;
            end
        end
        
        % Calculate the model accurancy with test data
        for i = 1:800
            Y_predict = 1/(1+exp(-X_test(i,:)*(W.')));
            if abs(Y_predict - Y_test(i,:)) <= 0.5
                test_accurancy(a,:) = test_accurancy(a,:) + 1;
            end 
        end
end
plot(train_accurancy/1400, 'b');
hold on;
plot(test_accurancy/800, 'r');
xlabel('# of Iteration');
ylabel('Correct Prediction Ratio');
title('Correct Prediction Ratio vs # of Iteration');
legend('accurancy of the train data','accurancy of the test data','Location','southeast');
hold off;
