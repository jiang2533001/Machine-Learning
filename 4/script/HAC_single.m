train_data = dlmread('data-2.txt');
example_num = size(train_data, 1);
point_distance_list = zeros((example_num * (example_num - 1))/2, 3);
distance_num = size(point_distance_list, 1);
index = 1;

distance = pdist(train_data);
for i = 1:example_num-1
    for j = i+1:example_num
        point_distance_list(index, 1) = i;
        point_distance_list(index, 2) = j;
        point_distance_list(index, 3) = distance(1,index);
        index = index + 1;
    end
end

clusters_num = example_num;
clusters = (1:clusters_num)';
cluster_index = clusters_num;
tree = [];

[values, order] = sort(point_distance_list(:,3));
sorted_list = point_distance_list(order,:);

tree = [];
index = 1;
new_cluster = clusters_num + 1;
while clusters_num ~= 1
    index_1 = sorted_list(index,1);
    index_2 = sorted_list(index,2);
    if clusters(index_1) ~= clusters(index_2)
        tem = [clusters(index_1) clusters(index_2) sorted_list(index, 3)];
        tree = [tree; tem];
        temp1 = clusters(index_1);
        temp2 = clusters(index_2);
        for i = 1:example_num
            if clusters(i) == temp1 || clusters(i) == temp2
                clusters(i) = new_cluster;
            end
        end
        clusters_num = clusters_num - 1;
        new_cluster = new_cluster + 1;
    end
    index = index + 1;
end

figure
dendrogram(tree, 10, 'Colorthreshold', 2060);
ylabel('The distance between the two merged clusters');