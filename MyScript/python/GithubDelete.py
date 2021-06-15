#!/user/bin/env python3
# coding=UTF-8

from time import sleep
import requests

# 去https://github.com/settings/tokens，选择delete_repo，生成对应的token，输入到这个
TOKEN = "df9b0ef08acc35e86cf2657bd819a5032d48fc15"
DELETE_LIST = ['ChenZeBin/BLeaksFinder','ChenZeBin/SPPage','ChenZeBin/ARKitDemo','ChenZeBin/BinKVO']
URL = "https://api.github.com/repos/{}/{}"

REQUEST_HEAD = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": TOKEN,# 此处的XXX代表上面的token
    "X-OAuth-Scopes": "repo"
}

if __name__ == '__main__':
    for repo in DELETE_LIST:
        print(repo)
https://www.jianshu.com/p/308b85e1fe69