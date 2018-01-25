clear;
clc;
%Read Data from file
cluster_data = dlmread('data.txt');
% for i = 2 : 20
%     [idx, C, sumd] = kmeans(cluster_data,i);
%     disp(sum(sumd));
% end
%Get data's shape
[r,c] = size(cluster_data);
%Add cluster pointer
test_data = [cluster_data zeros(r,1)];
SSE_MIN = zeros(1,19);
for k = 2 : 20
    index = randi(r,1,k);
    % Repeat 10 times to find the minimum SSE
    SSE_mini = 0;
    for iteration = 1: 10
        % New random Mean for each iteration
        index = randi(r,1,k);
        Mean = [];
        for i = 1 : k
             Mean = [Mean; cluster_data(index(i),:)];
        end
        % Clustering Process Recourd SSE from previous leanring process
        SSE_Pre = 0;
        while 1
            % Iterate through all data sample
            SSE = 0;
            % Record cluster size
            cluster_size = zeros(1,k);
            for i = 1 : r
                % Calculate distance between each smaple and each cluster
                Distance = 99999999;
                for j = 1 : k
                    temp_distance = distance(Mean(j,:),test_data(i,1:c));
                    if (temp_distance < Distance)
                        Distance = temp_distance;
                        test_data(i,end) = j;
                    end
                end
                SSE = SSE + Distance * Distance;
                % Cluser k size + 1,once assign one sample
                cluster = test_data(i,end); 
                cluster_size(cluster) = cluster_size(cluster)+ 1;
            end
            % Stop Case for the Clustering Process Calculate SSE
            if (SSE_Pre == SSE)
                SSE_Pre = 0;   
                break;
            else
                SSE_Pre = SSE; 
                SSE = 0;
            end           
            % Calculate new Mean
            for i = 1 : r
                cluster_index = test_data(i,end);
                Mean(cluster_index,:) = Mean(cluster_index,:) + test_data(i,1:c);
            end
            for i = 1 : k 
                Mean(i,:) = Mean(i,:)/cluster_size(i);
            end
        end
        if (SSE_mini == 0)
            SSE_mini = SSE;
        elseif (SSE_mini > SSE)
            SSE_mini = SSE;
        end
    end
    SSE_MIN(k-1) = SSE_mini;
   %disp(cluster_size);
end
plot(SSE_MIN);
xlabel('The Value of K');
ylabel('The Value of SSE');
title('SSE versus K value');