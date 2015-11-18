//
//  JCHeader.h
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCHeader;

typedef void(^JCHeaderCallback)(JCHeader *header, NSInteger index);

@interface JCHeader : UIView

/** 
 * 功能：
 * 创建一个下拉刷新控件
 * 参数：
 * defaultIndex:默认选中的index
 * ballColor:弹性球的颜色,传nil就是默认色
 * normalViews:非选中状态的view数组
 * selectedViews:选中状态的view数组
 * selectBlock:回调,会传回header和index,header用来调用endRefreshing方法,index用来做相应的处理
 */
+ (instancetype)headerWithDefaultIndex:(NSInteger)defaultIndex ballColor:(UIColor *)ballColor normalViews:(NSArray *)normalViews selectedViews:(NSArray *)selectedViews callback:(JCHeaderCallback)callback;

// 停止下拉刷新
- (void)endRefreshing;

@end
