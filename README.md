# JCPullToSelect

# 动图演示

![(logo)](http://img1.ph.126.net/Fit3r5t098GhrKmoAUfq3Q==/630785422826569864.gif)

# 功能介绍

* 下拉后继续左右滑动手指可以选择其他功能
* 上拉刷新
* 拖动过程中实时改变弹性球外形效果真实
* 可以自定义功能view数量、默认功能view的index、弹性球颜色等
* 支持tableView、collectionView、webView
* 最低支持iOS6
* 一行代码调用

# 如何使用？

## 1 使用CocoaPods导入

#### 在Podfile增加一行：`pod 'JCPullToSelect'`

## 2 手动导入

#### 复制 `JCPullToSelect` 文件夹到你的工程中


#### 导入完成后请看以下示例代码或直接下载demo文件（推荐下载demo，更详细）

```objc
self.tableView.header = [JCHeader headerWithDefaultIndex:0 ballColor:nil normalViews:@[JCNormalRefreshView] selectedViews:@[JCSelectedRefreshView] callback:^(JCHeader *header, NSInteger index) {
    // 停止刷新
    [header endRefreshing];
}];
    
self.tableView.footer = [JCFooter footerWithCallback:^(JCFooter *footer) {
    // 停止刷新
    [footer endRefreshing];
}];
```

# 联系方式

#### 邮箱 : hjaycee@163.com
#### 博客 : http://blog.csdn.net/hjaycee
#### 如发现框架有bug或者有任何建议或疑问都请发我邮箱，谢谢！
