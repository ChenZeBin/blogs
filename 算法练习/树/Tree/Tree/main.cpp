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
};

int main(int argc, const char * argv[]) {
    
    Tree tree;
    
    // 建立二叉树
    vector<int> vec = {2,3,4,5,'#',6,9,10,11,'#'};
    
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
    
    return 0;
}
