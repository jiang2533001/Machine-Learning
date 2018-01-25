train_data = dlmread('data-2.txt');
distance = pdist(train_data);
distance_matrix = squareform(distance);
cluster_num = size(distance_matrix, 1);
clusters = (1:cluster_num)';
new_cluster_num = cluster_num + 1;

tree = [];
while cluster_num~=1
	min_value = min(distance_matrix(distance_matrix > 0));
	[p1, p2] = find(distance_matrix==min_value);
    
    p1 = p1(1,1);
    p2 = p2(1,1);
    
    tem = [clusters(p1) clusters(p2) min_value];
    tree = [tree; tem];
    
    clusters(p1) = [];
    clusters(p2) = [];
    clusters = [clusters; new_cluster_num];
    new_cluster_num = new_cluster_num + 1;
    
    new_cluster_index = 1;
    new_cluster = zeros(cluster_num-1, 1);
    for i = 1:cluster_num
		if i ~= p1 && i ~= p2
			if distance_matrix(i, p1)> distance_matrix(i, p2) 
				distance = distance_matrix(i, p1);
			else
				distance = distance_matrix(i, p2);
			end
			new_cluster(new_cluster_index, 1) = distance;
			new_cluster_index = new_cluster_index + 1;
 		end    	
    end

    distance_matrix(p1,:) = [];
    distance_matrix(p2,:) = [];
    distance_matrix(:,p1) = [];
    distance_matrix(:,p2) = [];	

    distance_matrix = [distance_matrix new_cluster(1:end-1,:)];
    distance_matrix = [distance_matrix; new_cluster'];

    cluster_num = cluster_num - 1;
end

figure
dendrogram(tree, 10, 'Colorthreshold', 3200);
ylabel('The distance between the two merged clusters');