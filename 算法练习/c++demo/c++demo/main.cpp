//
//  main.cpp
//  c++demo
//
//  Created by chenzebin on 2020/2/22.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#include <iostream>
#include <vector>
#include <stack>
#include <queue>
#include <map>
#include <iterator>

using namespace std;


struct TreeNode {
  int val;
  TreeNode *left;
  TreeNode *right;
  TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};
 
class Solution {
public:
    
    string addStrings(string num1, string num2) {
        string res = "";

        int carry = 0;
        int i = num1.length() - 1;
        int j = num2.length() - 1;

        while (i >= 0 || j >= 0 || carry == 1) {
            int intI = i < 0 ? 0 : num1[i] - '0';
            int intJ = j < 0 ? 0 : num2[i] - '0';

            int tmp = intI + intJ + carry;
            
            carry = tmp / 10;
            
            int val = tmp % 10;

            char c = char(val)+'0';
            res.insert(0, 1, c);

            i--;
            j--;
        }

        return res;

    }
    
    string boldWords(vector<string>& words, string S) {

        int length = S.size();

        vector<int> vec(length);

        for (string s : words) {
            int j = 0;

            while (j < length) {
                int index = S.find(s,j);

                if (index < 0 || index > length) break;

                for (int k = 0; k < s.size(); k++) {
                    vec[index + k] = 1;
                }

                j = index + 1;
            }
        }

        string res = "";
        for (int i = 0; i < vec.size(); i++) {
            if (vec[i] == 1) {
                if (i > 0 && vec[i-1] != 1) {
                    res.append("<b>");
                    res.push_back(S[i]);
                } else if (i < vec.size() - 1 && vec[i+1] != 1) {
                    res.push_back(S[i]);
                    res.append("</b>");
                } else if (i == vec.size() - 1) {
                    res.push_back(S[i]);
                    res.append("</b>");
                } else {
                    res.push_back(S[i]);
                }
            } else {
                char c = S[i];
                res.push_back(c);
            }
        }

        return res;
    }
    
    void split(vector<int>& A, long left, long right)
    {
        if (left > right) return;
        
        long i = left;
        long j = right;
        
        long baseIndex = left;
        long baseVal = A[left];
        
        while (i != j) {
            while (A[j] >= baseVal && i < j) {
                j--;
            }
            while (A[i] <= baseVal && i < j) {
                i++;
            }
            
            if (i < j) {
                swap(A[i], A[j]);
            }
        }
        
        swap(A[baseIndex],A[i]);
        
        split(A, left, i-1);
        split(A,i+1,right);
    }
    
    void merge(vector<int>& A, int m, vector<int>& B, int n) {
        for (int i : B) {
            A[m++] = i;
        }
        
        split(A, 0, A.size()-1);
        
        
    }
    
    bool isSameTree(TreeNode* p, TreeNode* q) {
        bool isSame = false;

        if (p->val != q->val) return isSame;

        queue<vector<TreeNode *>> mQueue;

        mQueue.push({p,q});

        while (!mQueue.empty()) {
            int n = (int)mQueue.size();

            for (int i = 0; i < n; i++) {
                vector<TreeNode *> mVector =  mQueue.front();
                mQueue.pop();
                TreeNode *curPNode = mVector[0];
                TreeNode *curQNode = mVector[1];

                if (curPNode->val == curQNode->val) {
                    if (curQNode->left->val == curQNode->left->val) {
                        mQueue.push({curQNode->left,curQNode->left});
                    } else {
                        return false;
                    }

                    if (curQNode->right->val == curQNode->right->val) {
                        mQueue.push({curQNode->right,curQNode->right});
                    } else {
                        return false;
                    }
                } else {
                    return false;
                }

            }
        }
        return  isSame;
    

    }
    
    TreeNode* invertTree(TreeNode* root) {
        
        if (root == NULL) return root;
        
        queue<TreeNode *> q;
        
        q.push(root);
        
        while (!q.empty()) {
            TreeNode *node = q.front();
            TreeNode *tmp = node->left;
            node->left = node->right;
            node->right = tmp;
            
            q.pop();
            
            if (node->left) {
                q.push(node->left);
            }
            
            if (node->right) {
                q.push(node->right);
            }
            
            
        }
        
        return root;
    }
    
    TreeNode* mergeTrees(TreeNode* t1, TreeNode* t2) {
        if (t1==NULL) {
            return t2;
        }
        if (t2==NULL) {
            return t1;
        }
        
        stack<vector<TreeNode *>> stack;
        
        stack.push({t1, t2});
        
        while (!stack.empty()) {
            // 取顶层元素
            vector<TreeNode *> arr = stack.top();
            
            if (arr[0] == NULL || arr[1] == NULL)
            {
                continue;
            }
            
            t1->val = arr[0]->val + arr[1]->val;
            
            
            if (arr[0]->left == NULL) {
                arr[0]->left = arr[1]->left;
            } else {
                stack.push({arr[0]->left,arr[1]->left});
            }
            
            if (arr[0]->right == NULL) {
                arr[0]->right = arr[1]->right;
            } else {
                stack.push({arr[0]->right,arr[1]->right});
            }
            
        }
        
        return t1;
    }
};


int main(int argc, const char * argv[]) {
    

    Solution s;

    
    map<int,vector<TreeNode *>> m;
    
    TreeNode *node = new TreeNode(1);
    m[2].push_back(node);
    
    map<int,vector<TreeNode *>>::iterator i1 = m.begin();
//    map<int,vector<TreeNode *>>::iterator i2 = *m.begin();
    pair<int, vector<TreeNode *>> p = *m.begin();

    auto q = i1->first;
    auto ss = i1->second;

    
    return 0;
}

