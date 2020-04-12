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

class Window {
public:
    // 求最小子字符串。给你一个字符串S，一个字符串T，请在字符串S中,找出包含T所有字母的最小子串
    string min(string s, string t) {
        int left = 0, right = 0;
        // 用于记录最小串的区间
        int start = 0, minLen = INT_MAX;
        map<char,int> needs;
        map<char,int> window;
        
        for (char c : t) {
            needs[c]++;
        }
        
        // 记录window中已经有多少字符符合要求
        int match = 0;
        
        while (right < s.size()) {
            char c1 = s[right];
            
            if (needs.count(c1)) {
                window[c1]++;
                
                if (window[c1] == needs[c1]) {
                    match++;
                }
            }
            
            right++;
            
            // 当window满足要求了
            while (match == needs.size()) {
                if (right - left < minLen) {
                    start = left;
                    minLen = right - left;
                }
                
                char c2 = s[left];
                
                if (needs.count(c2)) {
                    window[c2]--;
                    
                    if (window[c2] < needs[c2]) {
                        match--;
                    }
                }
                
                left++;
            }
        }
        
        return minLen == INT_MAX ? "" : s.substr(start,minLen);
        
    }
};

int main(int argc, const char * argv[]) {
    
    int a = 1;
    int b = 4;
    
    int c = a ^ b;
    
    int d = 3 << 2;

    
    return 0;
}

