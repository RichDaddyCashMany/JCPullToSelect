//
//  JCFooter.h
//  JCPullToSelect-master
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCFooter;

typedef void(^JCFooterCallback)(JCFooter *footer);

@interface JCFooter : UIView

// 创建一个上拉刷新控件
+ (instancetype)footerWithCallback:(JCFooterCallback)callback;

// 停止下拉刷新
- (void)endRefreshing;

@end
