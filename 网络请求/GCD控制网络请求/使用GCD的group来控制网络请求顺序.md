# 使用GCD的group来控制网络请求顺序

## 同时发起多个网络请求，等都完成后，再统一处理

`dispatch_group_notify`会等`dispatch_group_async `的任务都执行完，再执行

```
- (void)group1Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务一完成");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务二完成");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}
```

如果`NSLog(@"任务一完成");`也是异步的，那么就会先输出**“都完成了”**，这个更符合实际的网络请求的场景，`dispatch_group_async `中放的是一个网络请求，我们要的**“都完成了”**,应该是网络请求都回调了才输出**"都完成了"**

```
- (void)group2Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            NSLog(@"任务一完成");
        });
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            NSLog(@"任务二完成");
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}
```

这时候的输出结果为：

```
都完成了
任务一完成
任务二完成

```
显然这不是我们想要的效果，因此对于这种情况，我们需要用到`dispatch_group_enter`,`dispatch_group_leave`

```
- (void)group3Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

```

这就达到我们的预期了

```
任务一完成
任务二完成
都完成了
```

**需要注意一点，这里的任务一和任务二不是顺序执行的，因为我模拟的都是延迟2s后执行**

`dispatch_group_enter` 和 `dispatch_group_leave` 一般是成对出现的, 进入一次，就得离开一次。也就是说，当离开和进入的次数相同时，就代表任务组完成了。如果enter比leave多，那就是没完成，如果leave调用的次数多了， 会崩溃的；

`dispatch_group_leave`和`dispatch_group_enter`不能在同一个线程，不然会死锁

其实我们上面的`group3Use`的方法就是应用于**同时多个发起多个网络请求，等都完成后，再统一处理**

比如：我进入一个app某个页面，这个页面要显示的数据，需要通过5个接口获取，那么我们就可以用这种方式，同时发起5个请求，等请求都回调完成了，再统一拿数据刷新界面

## 依次进行网络请求

介绍一个函数`dispatch_group_wait`，这个函数会卡住线程，直到group内的任务执行完。

所以我们可以利用这个函数，来达到**依次进行网络请求**

```
- (void)group4Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    // 注意，故意将这个任务一的延迟时间调成4s，比任务二多2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    // 现在group内的任务只有任务一，所以这时候会卡住线程，等任务一执行完毕，这个类似信号量，所以dispatch_group_leave和dispatch_group_enter不能在同一个线程，不然会死锁
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

```
输出：

```
任务一完成
任务二完成
都完成了
```
## 结语
/ >。< star这个项目支持下，今年有空会从笔记中整理一些东西出来

[文章代码](https://github.com/ChenZeBin/blogs/tree/master/%E7%BD%91%E7%BB%9C%E8%AF%B7%E6%B1%82/GCD%E6%8E%A7%E5%88%B6%E7%BD%91%E7%BB%9C%E8%AF%B7%E6%B1%82)
