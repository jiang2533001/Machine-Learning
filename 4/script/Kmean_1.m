clear;
clc;
%Read Data from file
cluster_data = dlmread('data.txt');
[r,c] = size(cluster_data);
% K value
k = 2;
%Initial Mean 
index = randi(r,1,k);
Mean = [];
for i = 1 : k
     Mean = [Mean; cluster_data(index(i),:)];
end
%Learning Process
repeat = 1;
SSE_t = zeros(1, 50);
while repeat <=50
    %Distance Holder
    Distance = zeros(1,k);
    %Sample Holder for each cluster (Index)
    Sample = zeros(k,r);
    Sample_length = zeros(k,1);
    % SSE for each cluster
    SSE = 0;
    % Iterate data set
    for i = 1 : r
        %Calculate Distance of between the sample and cluster centers
        for j = 1 : k
            Distance(j) = distance(Mean(j,:), cluster_data(i,:));
        end
        %Find the cluster with minimum distance
        [M,I] = min(Distance);
        %Assign the sample (index) to that cluster
        SSE = SSE + M;
        Sample_length(I) = Sample_length(I) + 1; 
        Sample(I,Sample_length(I)) = i;
    end
    SSE_t(repeat) = SSE;
    % Calculate new mean for new clusters
    for i = 1 : k
        length = Sample_length(i);
        Mean(i,:) = calculate_mean(cluster_data,Sample(i,1:length), length, c);
    end
    repeat = repeat + 1;
end
plot(SSE_t);
xlabel('Number of Learning Process');
ylabel('SSE')
title('SSE of Each Learning Process When K=2')

