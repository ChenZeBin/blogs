//
//  LRUCache.cpp
//  LRU
//
//  Created by chenzebin on 2020/3/13.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#include<iostream>
#include<map>

using namespace std;

struct ListNode
{
    int key;
    int val;
    ListNode *pre;
    ListNode *next;
    
    ListNode(int key, int val) {
        key = key;
        val = val;
        pre = nullptr;
        next = nullptr;
    }
};

class LRUCache {
    
private:
    int m_capacity;
    ListNode *pHead;
    ListNode *pTail;
    map<int, ListNode *> mp;
    
public:
    
    LRUCache(int capacity) {
        m_capacity = capacity;
        pHead = nullptr;
        pTail = nullptr;
    }
    
    ~LRUCache() {
        map<int, ListNode *>::iterator it = mp.begin();
        while (it != mp.end()) {
            delete it->second;
            it->second = nullptr;
            mp.erase(it++);
        }
    }
    
    void remove(ListNode *node) {
        
        if (node == nullptr) return;
        
        // 头结点
        if (node->pre == nullptr) {
            pHead = node->next;
            pHead->pre = nullptr;
        } else if (node->next == nullptr) {
            pTail = node->pre;
            pTail->next = nullptr;
        } else {
            ListNode *pre = node->pre;
            ListNode *next = node->next;
            
            pre->next = next;
            next->pre = pre;
        }
    }
    
    void setHead(ListNode *node) {
        
        if (node == nullptr) return;
        
        if (pHead == nullptr) {
            node->pre = nullptr;
            pHead = node;
        } else {
            node->pre = nullptr;
            node->next = pHead;
            
            pHead->pre = node;
            pHead = node;
        }
        
        if (pTail == nullptr) {
            pTail = pHead;
        }
    }
    
    void set(int key,int val) {
        map<int, ListNode *>::iterator it = mp.find(key);
        
        // 存在
        if (it != mp.end()) {
            
            ListNode *node = it->second;
            // 这里不是真的移除这个节点，修改下这个节点的值，就可以利用这块内存了（应该叫更新）
            remove(node);
            
            node->val = val;
            setHead(node);
        } else {
            ListNode *node = new ListNode(key,val);
            
            if (mp.size() >= m_capacity) {
                // 移除尾结点（尾结点即为最久没使用的）
                if (pTail) {
                    remove(pTail);
                    
                    map<int, ListNode *>::iterator it = mp.find(pTail->key);
                    
                    if (it != mp.end()) {
                        delete it->second;
                        
                        mp.erase(it);
                    }
                    
                }
            }
            
            setHead(node);
            mp[key] = node;
        }
    }
    
    int get(int key) {
        map<int, ListNode *>::iterator it = mp.find(key);
        
        if (it != mp.end()) {
            ListNode *node = it->second;
            // 这里不是真的移除这个节点，修改下这个节点的值，就可以利用这块内存了（应该叫更新）
            remove(node);
            setHead(node);
            
            return node->val;
        } else {
            return -1;
        }
    }
    
    int getSize() {
        return mp.size();
    }
};
