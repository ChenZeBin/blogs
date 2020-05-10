//
//  main.cpp
//  Tree
//
//  Created by chenzebin on 2020/3/7.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#include <iostream>
#include <vector>
#include <stack>
#include <queue>
#include <map>
#include <iterator>

// 二叉树

using namespace std;

struct Node {
    int val;
    Node *left;
    Node *right;
    Node(int val) : val(val), left(nullptr), right(nullptr) {};
};

class Tree {
private:

public:
    
    // 递归
    void preorderTraverse(Node *root, vector<Node *> & vec) {
        if (root == nullptr) return;
        
        vec.push_back(root);
        preorderTraverse(root->left, vec);
        preorderTraverse(root->right, vec);
    }
    
    
    vector<double> averageOfLevels(Node* root) {

        if (root == nullptr) return {};

        queue<Node *> q;
        q.push(root);
        vector<double> vec;
        while (!q.empty()) {
            int len = (int)q.size();

            double sum = 0.0;
            while (len--) {
                Node *top = q.front();
                q.pop();

                if (top->left) q.push(top->left);
                if (top->right) q.push(top->right);

                sum += top->val;
            }

            vec.push_back(sum / len);
        }
        return vec;
    }
    
    // 根据数组创建二叉树，数组'#'表示空结点
    Node *initTree(vector<int> vec) {
        if (vec.front() == '#') return nullptr;
        
        Node *root = new Node(vec[0]);;
        queue<Node *> q;
        q.push(root);
        for (int i = 0; i < vec.size() / 2; i++) {
            
            Node *curr = q.front();
            q.pop();
            
            if (i * 2 + 1 < vec.size() && vec[i * 2 + 1] != '#') {
                curr->left =  new Node(vec[i * 2 + 1]);
                cout<<curr->val<<"左子节点为"<<curr->left->val<<endl;
                q.push(curr->left);
            }
            
            if (i * 2 + 2 < vec.size() && vec[i * 2 + 2] != '#') {
                curr->right = new Node(vec[i * 2 + 2]);
                cout<<curr->val<<"右子节点为"<<curr->right->val<<endl;
                q.push(curr->right);
            }
            
        }
        
        return root;
    }
    
    // 层序遍历
    vector<Node *> level(Node *root) {
        
        if (root == nullptr) return {};
        
        vector<Node *> res;
        
        queue<Node *> q;
        
        q.push(root);
        
        while (!q.empty()) {
            Node *topNode = q.front();
            q.pop();
            
            if (topNode->left) q.push(topNode->left);
            if (topNode->right) q.push(topNode->right);
            
            res.push_back(topNode);
        }
        
        for (Node *n : res) {
            cout<<n->val<<endl;
        }
        
        return res;
    }

    // 层序遍历变形，求深度
    int levelToDeep(Node *root) {
        if (root == nullptr) return 0;
        
        queue<Node *> q;
        
        q.push(root);
        
        int count = 0;
        
        while (!q.empty()) {
            count++;
            int len = (int)q.size();
            
            while (len--) {
                Node *top = q.front();
                q.pop();
                
                if (top->left) q.push(top->left);
                if (top->right) q.push(top->right);
            }
        }
        
        return count;
    }
    
    vector<Node *> preorder(Node *root) {
        stack<pair<Node *, bool>> sk;
        sk.push(make_pair(root, false));
        vector<Node *> vec;
        
        while (!sk.empty()) {
            Node *top = sk.top().first;
            bool isVisited = sk.top().second;
            sk.pop();
            
            if (top == nullptr) continue;
            
            if (isVisited) {
                vec.push_back(top);
            } else {
                sk.push(make_pair(top->right, false));
                sk.push(make_pair(top->left, false));
                sk.push(make_pair(top, true));
            }
        }
        
        
        for (Node *n : vec) {
            cout<<n->val<<endl;
        }
        
        return vec;
    }
    
    vector<Node *> inorder(Node *root) {
        stack<pair<Node *, bool>> sk;
        sk.push(make_pair(root, false));
        vector<Node *> vec;
                
        while (!sk.empty()) {
            Node *top = sk.top().first;
            bool isVisited = sk.top().second;
            
            sk.pop();
            
            if (top == nullptr) continue;

            if (isVisited) {
                vec.push_back(top);
            } else {
                sk.push(make_pair(top->right, false));
                sk.push(make_pair(top, true));
                sk.push(make_pair(top->left, false));
            }
        }
        
        for (Node *n : vec) {
            cout<<n->val<<endl;
        }
        
        return vec;
    }
    
    
    vector<Node *> postorder(Node *root) {
        stack<pair<Node *, bool>> sk;
        sk.push(make_pair(root, false));
        vector<Node *> vec;
        
        while (!sk.empty()) {
            Node *top = sk.top().first;
            bool isVisited = sk.top().second;
            sk.pop();
            
            if (top == nullptr) continue;
            
            if (isVisited) {
                vec.push_back(top);
            } else {
                sk.push(make_pair(top, true));
                sk.push(make_pair(top->right, false));
                sk.push(make_pair(top->left, false));
            }
        }
        
        for (Node *n : vec) {
            cout<<n->val<<endl;
        }
        
        return vec;
    }
    
    vector<Node *> dfs(Node *root) {
        
        if (root == nullptr) return {};
        
        vector<Node *> vec;
        
        stack<Node *> sk;
        sk.push(root);
        
        while (!sk.empty()) {
            Node *top = sk.top();
            vec.push_back(top);
            sk.pop();
            
            if (top->right) sk.push(top->right);
            if (top->left) sk.push(top->left);
            
        }
        
        for (Node *n : vec) {
            cout<<n->val<<endl;
        }
        
        return vec;
    }
    
    vector<string> dfsToPats(Node *root) {
        
        if (root == nullptr) return {};
        
        vector<string> paths;
        
        stack<Node *> nodeSk;
        nodeSk.push(root);
        
        stack<string> pathSk;
        pathSk.push(to_string(root->val));
 
        while (!nodeSk.empty()) {
            Node *top = nodeSk.top();
            nodeSk.pop();
            
            string path = pathSk.top();
            pathSk.pop();
            
            if (top->left == nullptr && top->right == nullptr) {
                paths.push_back(path);
            }
            
            if (top->right) {
                nodeSk.push(top->right);
                pathSk.push(path+"->"+to_string(top->right->val));
            }
            
            if (top->left) {
                nodeSk.push(top->left);
                pathSk.push(path+"->"+to_string(top->left->val));
            }
            
        }
        
        return paths;
    }
    
    // 求最长直径，注意不是最大深度哦
//    int diameter(Node *root) {
//
//    }
    
    int majorityElement(vector<int>& nums) {
        map<int,int> mp;

        for (int i : nums) {
            map<int, int>::iterator iter = mp.find(i);

            if (iter != mp.end()) {
                mp[i] = mp[i] + 1;
            } else {
                mp[i] = 1;
            }
        }

        int max1 = 0;

        map<int,int>::iterator iter;
        iter = mp.begin();
        while (iter != mp.end()) {
            max1 = max(max1,iter->second);
            iter++;
        }

        return max1 / 2;
    }
};

int main(int argc, const char * argv[]) {
    
    Tree tree;
    
    // 建立二叉树
    vector<int> vec = {2,3,4,5,'#',6,9,'#',11};
    tree.majorityElement(vec);
    
    Node *root = tree.initTree(vec);
    
    cout<<"层序遍历"<<endl;
    tree.level(root);
    
    cout<<"前序遍历"<<endl;
    tree.preorder(root);
    
    cout<<"中序遍历"<<endl;
    tree.inorder(root);
    
    cout<<"后序遍历"<<endl;
    tree.postorder(root);
    
    
    cout<<"深度遍历"<<endl;
    tree.dfs(root);
    
    cout<<"层序遍历求深度"<<tree.levelToDeep(root)<<endl;
    
    cout<<"深度遍历求路径"<<endl;
    for (string s : tree.dfsToPats(root)) {
        cout<<"路径："<<s<<endl;
    }
    
    tree.averageOfLevels(root);
    
    // 递归
    
    // 前序遍历
    vector<Node *> preorderTraverseVec;
    tree.preorderTraverse(root,preorderTraverseVec);
    cout<<"递归前序遍历"<<endl;
    for (Node *n : preorderTraverseVec) {
        cout<<n->val<<endl;
    }
        
    return 0;
}
