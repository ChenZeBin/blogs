git rebase

```
// 使用这个commit
p, pick = use commit 
// 修改commit信息
r, reword = use commit, but edit the commit message
// 
e, edit = use commit, but stop for amending
// 合并到前一个commit
s, squash = use commit, but meld into previous commit
f, fixup = like “squash”, but discard this commit’s log message
x, exec = run command (the rest of the line) using shell
// 删除commit
d, drop = remove commit
```

----

--force-with-lease

[Git 更安全的强制推送，--force-with-lease](https://blog.csdn.net/wpwalter/article/details/80371264)