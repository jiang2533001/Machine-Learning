% Part 1
% read file
M_tr = dlmread('housing_train.txt');
M_te = dlmread('housing_test.txt');

% get X matrix and Y matrix
X_tr = M_tr(:,1:13);
Y_tr = M_tr(:,14);

% Introduce the dummy variable to X
a = ones(433,1);
X_tr = [a X_tr];

% Part 2
% compute the optimal weight vector
w = (X_tr' * X_tr)^(-1) * X_tr' * Y_tr;

disp("Part 2");
fprintf("The weight vector is:\n");
disp(w);

% Part 3
% compute the sum of squared error (SSE) of training data
disp("Part 3");
TrainingE = (Y_tr - X_tr * w)' * (Y_tr - X_tr * w);
fprintf("SSE of training data:");
disp(TrainingE);

% deal with testing data
X_te = M_te(:,1:13);
Y_te = M_te(:,14);

a = ones(74,1);
X_te = [a X_te];

% compute the sum of squared error (SSE) of testing data
TestingE = (Y_te - X_te * w)' * (Y_te - X_te * w);
fprintf("SSE of testing data:");
disp(TestingE);

% Part 4
% we do not introduce the dummy variable to X
% training data without dummy variable
disp("Part 4");
X_tr = M_tr(:,1:13);
Y_tr = M_tr(:,14);

w = (X_tr' * X_tr)^(-1) * X_tr' * Y_tr;

TrainingE = (Y_tr - X_tr * w)' * (Y_tr - X_tr * w);
fprintf("SSE of training data without dummay variable:");
disp(TrainingE);

% testing data without dummy variable
X_te = M_te(:,1:13);
Y_te = M_te(:,14);

TestingE = (Y_te - X_te * w)' * (Y_te - X_te * w);
fprintf("SSE of testing data without dummy variable:");
disp(TestingE);

% Part 5
% generate several random features
% training data
a = ones(433,1);
X_tr = [a X_tr];

a = ones(74,1);
X_te = [a X_te];

result_train = [];
result_test  = [];

for number = [10., 37., 95., 100., 175., 198., 230., 265., 300., 353.]
    random_feature = number * rand(433, 1);
    X_tr = [X_tr random_feature];
    w = (X_tr' * X_tr)^(-1) * X_tr' * Y_tr;
    TrainingE = (Y_tr - X_tr * w)' * (Y_tr - X_tr * w);
    result_train = [result_train TrainingE];
  
    random_feature = number * rand(74, 1);
    X_te = [X_te random_feature];
    TestingE = (Y_te - X_te * w)' * (Y_te - X_te * w);
    result_test = [result_test TestingE];
end

figure
plot(result_train);
title('Training data with more features');

figure
plot(result_test);
title('Testing data with more features');

% Part 6
lambda = [0.01, 0.05, 0.1, 0.5, 1, 5.];

% deal with training data
X_tr = M_tr(:,1:13);
a = ones(433,1);
X_tr = [a X_tr];
I_tr = eye(size(X_tr' * X_tr));

X_te = M_te(:,1:13);
a = ones(74,1);
X_te = [a X_te];
I_te = eye(size(X_te' * X_te));

result_train_r = [];
result_test_r  = [];

for lambda = linspace(0.0001, 1000, 10000)
   
    w = (X_tr' * X_tr + I_tr * lambda)^(-1) * X_tr' * Y_tr;
    TrainingE = (Y_tr - X_tr * w)' * (Y_tr - X_tr * w);
    result_train_r = [result_train_r TrainingE];
     
    w = (X_tr' * X_tr + I_te * lambda)^(-1) * X_tr' * Y_tr;
    TestingE = (Y_te - X_te * w)' * (Y_te - X_te * w);
    result_test_r = [result_test_r TestingE];
end

lam = linspace(0.0001, 1000, 10000);

indexmin = find(min(result_test_r)==result_test_r);
xmin = lam(indexmin);
ymin = result_test_r(indexmin);

figure
plot(lam, result_train_r);
title('Training data with lambda');

figure
plot(lam, result_test_r);
title('Testing data with lambda');

disp("Part 6")
fprintf("The best lambda is:");
disp(xmin);

% Part 7
result_w = [];
for lambda = linspace(0.0001, 1000, 10000)
    w = (X_tr' * X_tr + I_tr * lambda)^(-1) * X_tr' * Y_tr;
    result_w = [result_w w];
end

result_norm = [];

for i = 1:10000
    result_norm = [result_norm norm(result_w(1:end, i))];
end
    
figure
plot(lam,result_norm);
title('Norm of weight vs lambda');
xlabel('lambda');
ylabel('norm of weight');



figure
x = lam;
hold on
for i = [1:14]
    y = result_w(i, 1:end);
    plot(x, y);
end
title('Combine Plots with weight');
hold off




