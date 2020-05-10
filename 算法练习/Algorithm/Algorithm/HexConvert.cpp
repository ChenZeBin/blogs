//
//  HexConvert.cpp
//  Algorithm
//
//  Created by chenzebin on 2020/4/23.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#include <stdio.h>
#include "AlgorithmHeader.h"

using namespace std;

class HexConvert {
    
public:

#pragma mark - 单字符转整型
    /// 单个字符转10进制 0-9，a对应10
    /// ASCII码48～57为0到9*十个阿拉伯数字
    int _char2Int(char c)
    {
        if(c >= '0' && c <= '9')
            return c - '0';
        else if(c >= 'a' && c <= 'f')
            return (c - 'a' + 10);
        else if(c >= 'A' && c <= 'F')
            return (c - 'A' + 10);
        
        return 0;
    }
    
#pragma mark - n进制转10进制
    
    int _2To10(string s)
    {
        int len = (int)s.length();
        int k = 0;
        
        for (int i = 0; i < len; i++) {
            // i = 0，就是最高位
            int j = len - i - 1;
            int tmp = _char2Int(s[i]) * pow(2, j);
            k = k + tmp;
        }
        
        return k;
    }

    int _4To10(string s)
    {
        int len = (int)s.length();
        int k = 0;
        
        for (int i = 0; i < len; i++) {
            // i = 0，就是最高位
            int j = len - i - 1;
            int tmp = _char2Int(s[i]) * pow(4, j);
            k = k + tmp;
        }
        
        return k;
    }

    int _8To10(string s)
    {
        int len = (int)s.length();
        int k = 0;
        
        for (int i = 0; i < len; i++) {
            // i = 0，就是最高位
            int j = len - i - 1;
            int tmp = _char2Int(s[i]) * pow(8, j);
            k = k + tmp;
        }
        
        return k;
    }

    long long _temTo10(string s,int tem)
    {
        long long len = (int)s.length();
        long long k = 0;
        
        for (long long i = 0; i < len; i++) {
            // i = 0，就是最高位
            long long j = len - i - 1;
            long long tmp = _char2Int(s[i]) * pow(tem, j);
            k = k + tmp;
        }
        
        return k;
    }
    
    long long _2To10(long long val)
    {
        int k = 0;
        
        for (int i = 0; val != 0; i++) {
            // 对10求余可以得出尾数
            int rem = val % 10;
            // 尾数 * 2的n次方
            k = k + rem * pow(2, i);
            
            // 除以10，砍掉尾数
            val = val / 10;
        }
        
        return k;
    }
    
#pragma mark -

    
    vector<int> _10To8(int val)
    {
        vector<int> vec;
        
        while (val) {
            int rem = val % 8;
            val = val / 8;
            
            vec.insert(vec.begin(), rem);
        }
        
        return vec;
    }

    

    int _16To10(string szHex)
    {
        int len = (int)szHex.size();
        int result = 0;
        for(int i = 0; i < len; i++)
        {
            // 16进制  aaa
            // a * 16的2次方 + a * 16的1次方 + a * 16的0次方
            result = result + (int)pow((float)16, (int)len-i-1) * _char2Int(szHex[i]);
        }
        return result;
    }

    // 不用考虑溢出，因为8进制代表的数值肯定大于10进制代表的数值
    int _8To10(int val)
    {
        int k = 0;
        
        for (int i = 0; val != 0; i++)
        {
            // 求每位数
            int rem = val%10;
            k = k + rem * pow(8,i);
            val = val / 10;
        }
        return k;
    }

};
