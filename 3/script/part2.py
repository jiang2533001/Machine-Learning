from __future__ import division
import csv 


class decisionnode ():
    def __init__(self, col = -1, theta = None, label = None, infomation_gain = None,ab = None, bb = None):
        self.col = col
        self.theta = theta
        self.info_g= infomation_gain
        self.label = label
        self.ab = ab
        self.bb = bb 
 
 
def divideset(rows, column, theta):
    split_function = lambda row: row[column] >= theta
    set1 = [row for row in rows if split_function(row)]
    set2 = [row for row in rows if not split_function(row)]
    return (set1, set2)
 
 
def get_thetas(rows, col):
    sorted_matrix = sorted(rows, key=lambda x: x[col])
    results = {}
    for i in range(1, len(rows)):
        if sorted_matrix[i][0] != sorted_matrix[i-1][0]:
            theta = (sorted_matrix[i][col]+sorted_matrix[i-1][col])/2    
            results[theta] = 1
    return results
  
  
def uniquecounts(rows):
    # Return counts for each label
    results = {}
    for row in rows:
        r= row[0]
        if r not in results: 
            results[r] = 0
        results[r] +=1
    return results

    
def entropy(rows):
    from math import log
    log2 = lambda x: log(x)/log(2)
    results = uniquecounts(rows)    
    ent = 0.0
    for r in results.keys():
        p = float(results[r])/len(rows)
        ent = ent - p*log2(p)
    return ent

    
def buildtreestump(rows, scoref=entropy):
    best_gain = 0.
    best_criteria = None
    best_sets = None
    current_score = scoref(rows)
    column_count = len(rows[0])
    for col in range(1,column_count):
        #Get different value in the feature
        column_values = get_thetas(rows, col)
        #test different theta and find the best one
        for value in column_values.keys():
            #print (value)
            (set1, set2) = divideset(rows, col, value)
            p = float(len(set1))/len(rows)
            gain = current_score - p * scoref(set1) - (1-p) * scoref(set2)
            if gain > best_gain and len(set1) > 0 and len(set2) > 0:
                best_gain = gain
                best_criteria = (col, value)
                best_sets = (set1, set2)
    group_ab = classfy_group(uniquecounts(best_sets[0]))
    group_bb = classfy_group(uniquecounts(best_sets[1]))
    return decisionnode(col = best_criteria[0], theta=best_criteria[1],infomation_gain = best_gain,ab = decisionnode(label=group_ab), bb = decisionnode(label=group_bb))
    
    
def classfy_group(set):
    try:
        count_n = set[-1]
    except:
        count_n = 0
    try:
        count_p = set[1]
    except:
        count_p = 0
    if count_n > count_p:
        return {-1:1}
    else:
        return {1:1}
    
    
    
def buildtree(rows, scoref=entropy):
    if len(rows) ==0:
        return decisionnode()
    best_gain = 0.
    best_criteria = None
    best_sets = None
    # entropy of current row
    current_score = scoref(rows)
    column_count = len(rows[0])
    for col in range(1,column_count):
        #Get different value in the feature
        column_values = get_thetas(rows, col)
        #test different theta and find the best one
        for value in column_values.keys():
            #print (value)
            (set1, set2) = divideset(rows, col, value)
            p = float(len(set1))/len(rows)
            gain = current_score - p * scoref(set1) - (1-p) * scoref(set2)
            if gain > best_gain and len(set1) > 0 and len(set2) > 0:
                best_gain = gain
                best_criteria = (col, value)
                best_sets = (set1, set2)
    if best_gain > 0:
        above_branch = buildtree(best_sets[0])
        below_branch = buildtree(best_sets[1])
        return decisionnode(col = best_criteria[0], theta=best_criteria[1],infomation_gain = best_gain,ab = above_branch, bb = below_branch)
    else:
        return decisionnode(label = uniquecounts(rows))
        

def printtree(root, indent=' '):
    if root.label !=None:
        print(indent+str(root.label))
    else:
        print(indent+str(root.col)+':'+str(root.theta)+'?' +'  infomation_gain is ' + str(root.info_g))
        printtree(root.ab,indent+' ')
        printtree(root.bb,indent+' ')

        
def through_tree(entity, tree):
    
    if tree.label != None:
        for key in tree.label.keys():
            return key
    col = tree.col
    theta = tree.theta
    if entity[col]>= theta:
        branch = tree.ab
    else:
        branch = tree.bb
    return through_tree(entity,branch)

    
def test_samples(rows, tree):
    correct_classify = 0
    for row in rows:
        predict = through_tree(row,tree)
        
        if row[0] == predict:
            correct_classify += 1
    return (correct_classify / len(rows))

    
def main ():
    # contain the class label 
    train_data = []
    test_data = []
    # contain the features
    train_file = open('knn_train.csv', 'rb')
    train_reader = csv.reader(train_file)
    for row in train_reader:
        train_data.append(map(float, row))
           
    test_file = open('knn_test.csv', 'rb')
    test_reader = csv.reader(test_file)
    for row in test_reader:
        test_data.append(map(float, row))
    
    stump = buildtreestump(train_data)
    print('-------------------------------------Decision Stump---------------------------------------------')
    printtree(stump)
    train_accuracy_s = test_samples(train_data, stump)
    test_accuracy_s = test_samples(test_data, stump)
   
    print('The error rate of the decision dump on the train data is %f'% (1.0-train_accuracy_s))
    print('The error rate of the decision dump on the test data is %f'% (1.0-test_accuracy_s))
    print
    print
    print('-------------------------------------Complete Decision Tree---------------------------------------------')
    root = buildtree(train_data)    
    printtree(root)
    train_accuracy =test_samples(train_data,root)
    test_accuracy =  test_samples(test_data,root)
    print('The error rate of the complete decision tree on the train data is %f'% (1.0-train_accuracy))
    print('The error rate of the complete decision tree on the test data is %f'% (1.0-test_accuracy))
if __name__ == '__main__':
    main()






