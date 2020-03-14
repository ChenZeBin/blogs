//
//  main.cpp
//  LRU
//
//  Created by chenzebin on 2020/3/13.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#include <iostream>
#import "LRUCache.cpp"

int main(int argc, const char * argv[]) {
    
    LRUCache* lruCache = new LRUCache(3);
    lruCache->set(1,1);
    lruCache->set(2,3);
    cout<<lruCache->getSize()<<endl;
    lruCache->set(3,5);
    cout<<lruCache->getSize()<<endl;
    cout<< lruCache->get(1)<<endl;
    lruCache->set(6,3);
    cout<<lruCache->getSize()<<endl;
    cout<< lruCache->get(3)<<endl;
    cout<< lruCache->get(1)<<endl;
    cout<< lruCache->get(2)<<endl;
    

    return 0;
}
