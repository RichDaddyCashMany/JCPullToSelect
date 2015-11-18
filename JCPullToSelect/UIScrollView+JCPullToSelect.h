//
//  UIScrollView+JCPullToSelect.h
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHeader.h"
#import "JCFooter.h"

@interface UIScrollView (JCPullToSelect)

@property (nonatomic, strong) JCHeader *header;
@property (nonatomic, strong) JCFooter *footer;

- (void)showFooter;

@end
