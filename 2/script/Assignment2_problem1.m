% CS434 Implement Assignment 2 ----- Problem 1
% Logistic Regression
% Wenbo Hou & Zhi Jiang
% 4/18/2017
clear
clc
train_data = dlmread('train_data.csv');
test_data = dlmread('test_data.csv');

iteration =  2000;
% Preparation the traing data
X_train = train_data(:,1:end-1);
X_train = [ones(1400,1) X_train];
Y_train = train_data(:,end);
learning_rate = [0.000000001 0.000000006 0.00000001 0.00000006];

for l = 1:4
    W = zeros(1,257);
    % Calculate the weight vector
    total_loss = zeros(iteration,1);
    for a = 1:iteration
        d = zeros(1,257);
        for i = 1:1400
            Y_predict =  1./(1.+exp(-X_train(i,:)*(W.')));
            coefficient = Y_train(i,:) - Y_predict;
            gradient =  coefficient * X_train(i,:);
            d = d + gradient;          
        end
        W = W + learning_rate(l)*d;
    
    % Calculate the total loss for each iteration   
        for i = 1:1400
            Y_predict =  1./(1.+exp(-X_train(i,:)*(W.')));
            loss = -Y_train(i,:)*log(Y_predict) - (1-Y_train(i,:))*log(1 - Y_predict);
           
            total_loss(a,:) = total_loss(a,:) + loss;      
        end
    end
    plot(total_loss);
    hold on;
end
legend('leanrning rate = 0.000000001','leanrning rate = 0.000000006','leanrning rate = 0.00000001','leanrning rate = 0.00000005');

