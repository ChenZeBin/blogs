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
#include <math.h>
#include <string.h>

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

vector<vector<int>> fourSum(vector<int>& nums, int target) {
    if (nums.size() < 4) return {};
    
    sort(nums.begin(),nums.end());

    vector<vector<int>> res;

    for (int i = 0; i < nums.size() - 3; i++) {

        if (i > 0 && nums[i] == nums[i - 1]) continue;
        if (nums[i] > target) break;

        for (int j = i + 1; j < nums.size() - 2; i++) {

            if (j > i + 1 && nums[j] == nums[j - 1]) continue;
            if (nums[j] > target) break;
            
            int left = j + 1;
            int right = nums.size() - 1;

            while (left < right) {
                int sum = nums[i] + nums[j] + nums[left] + nums[right];

                if (sum == target) {
                    vector<int> tmp = {nums[i], nums[j], nums[left], nums[right]};
                    res.push_back(tmp);

                    while(left < right && nums[left] == nums[left + 1]) left++;
                    while(left < right && nums[right] == nums[right - 1]) right--;
                    left++;
                    right--;
                } else if (sum < target) {
                    left++;
                } else {
                    right--;
                }
            }
        }
    }

    return res;
}
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

/// 单个字符转10进制 0-9，a对应10
/// ASCII码48～57为0到9十个阿拉伯数字
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

vector<int> test(vector<int> nums)
{
    vector<int> vec = {0,0};
    
    int xorRes = 0;
    
    for (int i = 0; i < nums.size(); i++) {
        xorRes = xorRes ^ nums[i];
    }
    
    if (xorRes == 0) {
        return {};
    }
    
    int separator = 1;
    
    while ((separator & xorRes) == 0) {
        separator = separator << 1;
    }
    
    for (int i = 0; i < nums.size(); i++) {
        if ((separator & nums[i]) == 0) {
            vec[0] = vec[0] ^ nums[i];
        } else {
            vec[1] = vec[1] ^ nums[i];
        }
    }
    
    return vec;;
}

void dfs(string curStr,int left,int right,vector<string>& res) {
    if (left == 0 && right == 0) {
        res.push_back(curStr);
        return;
    }
    
    if (left > right) {
        return;
    }
    
    if (left) {
        dfs(curStr + "(", left-1, right, res);
    }
    
    if (right) {
        dfs(curStr + ")", left, right - 1, res);
    }
}

vector<string> generateParenthesis(int n) {
    
    vector<string> res;
    
    if (n == 0) {
        return res;
    }
    
    dfs("",n,n,res);
    
    return res;
}

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(NULL) {}
};


ListNode* swapPairs(ListNode* head)
{
    //新建一个空结点，用来指向头节点
    ListNode* p = new ListNode(0);
    p->next = head;
    //新建和p相同一个curr节点，两个相同的节点一个是当前做改变的节点，一个是保持不动用来返回的节点
    ListNode* curr = p;
    //循环条件为当前节点为NULL或当前的下一个节点为NULL，分别对应偶数和奇数个节点的终止标志
    while(head != NULL && head->next != NULL)
    {
        //为了清晰明了，我们新建两个节点，一节点和二节点
        ListNode* firstNode = head;
        ListNode* secondNode = head->next;
        
        ///把一和二进行交换，并连接前后
        //当前curr节点指向二节点
        curr->next = secondNode;
        //一节点指向二节点此时的下一节点
        firstNode->next = secondNode->next;
        //二节点指向一节点，即交换位置成功
        secondNode->next = firstNode;
        
        //由于每次循环curr节点都指向每次循环的一节点，所以要再次把curr节点指向一节点
        curr = firstNode;
        //每次移动都是由head节点来赋值操作，所以head应向右移动两格，即新循环的一节点
        head = firstNode->next;
    }
    //返回p的下一个节点即对应整个操作后的链表
    return p->next;
    
}


int reverse(int x) {
    
    int res = 0;
    
    while (x != 0) {
        int rem = x % 10;
        x = x / 10;
        
        //如果res * 10 > INT_MAX那么肯定就溢出了，res * 10 == INT_MAX，还不会溢出，溢出还是得余数
        if (res > INT_MAX / 10 || (res == INT_MAX / 10 && rem > INT_MAX % 10)) return 0;
        if (res < INT_MAX / 10 || (res == INT_MIN / 10 && rem < INT_MIN % 10)) return 0;
        
        res = res * 10 + rem;
    }
    
    return res;
}

class Sol {
    vector<int> candidates;
    vector<vector<int>> res;
    vector<int> path;
    
public:
    void DFS(int start, int target) {
        if (target == 0) {
            res.push_back(path);
            return;
        }
        for (int i = start;
             i < candidates.size() && target - candidates[i] >= 0; i++) {
            path.push_back(candidates[i]);
            DFS(i, target - candidates[i]);
            path.pop_back();
        }
    }

    vector<vector<int>> combinationSum(vector<int> &candidates, int target) {
        std::sort(candidates.begin(), candidates.end());
        this->candidates = candidates;
        DFS(0, target);

        return res;
    }


};

string multiply(string num1, string num2)
{
    int m = (int)num1.size(), n = num2.size();
    // 结果最多为 m + n 位数
    vector<int> res(m + n, 0);
    // 从个位数开始逐位相乘
    for (int i = m - 1; i >= 0; i--) {
        for (int j = n - 1; j >= 0; j--) {
            int mul = (num1[i]-'0') * (num2[j]-'0');
            // 乘积在 res 对应的索引位置
            int p1 = i + j, p2 = i + j + 1;
            // 叠加到 res 上
            int sum = mul + res[p2];
            res[p2] = sum % 10;
            res[p1] += sum / 10;
        }
    }
    // 结果前缀可能存的 0（未使用的位）
    int i = 0;
    while (i < res.size() && res[i] == 0)
        i++;
    // 将计算结果转化成字符串
    string str;
    for (; i < res.size(); i++)
        str.push_back('0' + res[i]);
    
    return str.size() == 0 ? "0" : str;
}

string multiply1(string num1, string num2) {
    
    int n = num1.size();
    int m = num2.size();
    
    vector<int> res(n + m,0);
    
    for(int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            int mul =( num1[i] - '0') * (num2[j] - '0');
            int p1 = i + j;
            int p2 = p1 + 1;
            int sum = res[p2] + mul;
            res[p2] = sum % 10;
            res[p1] = res[p1] + sum / 10;
        }
    }
    
    int i = 0;
    
    while(i < res.size() && res[i] == 0) {
        i++;
    }
    
    string str;
    
    for (;i<res.size();i++) {
        str.push_back('0' + res[i]);
    }
    
    return str.size() == 0 ? "0" : str;
    
}

int main(int argc, const char * argv[]) {
    
    int i = 9274;
    // 22072
    _10To8(i);
    
    int j = 24; // 4 * pow(8,0) + 2 * pow(8,1)
    
    _8To10(j);
    
    
    _16To10("1888");
    
    int a = _char2Int('a');
    
    int aa = (int)'0';
    
//    _2To10("111110011");
//    _4To10("33220013");
//    _8To10("76543210");
//
//    _temTo10("111110011",2);
//    _temTo10("33220013",4);
//    _temTo10("76543210",8);
//    _temTo10("76af543210",16);
//    _temTo10("76543210",32);

    
    vector<int> vec = {4,1,2,2,5,1,4,3};
    
//    search(vec,3);
    
//    fourSum(vec,0);
    
//    test(vec);
    
//    generateParenthesis(3);
    
    ListNode *node1 = new ListNode(1);
    ListNode *node2 = new ListNode(2);
    ListNode *node3 = new ListNode(3);
    ListNode *node4 = new ListNode(4);
    
    node1->next = node2;
    node2->next = node3;
    node3->next = node4;
    node4->next = nullptr;
        
    swapPairs(node1);
    
    Sol *s = new Sol();
    
    
    vector<int> vec1 = {2,3,6,7};
    s->combinationSum(vec1,7);
    
    multiply("101","2");
    multiply1("101","2");
    return 0;
}

