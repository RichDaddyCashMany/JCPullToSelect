//
//  UIScrollView+JCPullToSelect.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "UIScrollView+JCPullToSelect.h"
#import <objc/runtime.h>

@implementation UIScrollView (JCPullToSelect)

static const char JCHeaderKey = '\0';
- (void)setHeader:(JCHeader *)header{
    if (header != self.header) {
        [self.header removeFromSuperview];
        [self addSubview:header];
        
        [self willChangeValueForKey:@"header"];
        objc_setAssociatedObject(self, &JCHeaderKey, header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"];
    }
}

- (JCHeader *)header
{
    return objc_getAssociatedObject(self, &JCHeaderKey);
}

static const char JCFooterKey = '\0';
- (void)setFooter:(JCFooter *)footer{
    if (footer != self.footer) {
        [self.footer removeFromSuperview];
        [self addSubview:footer];
        
        [self willChangeValueForKey:@"footer"];
        objc_setAssociatedObject(self, &JCFooterKey, footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"];
    }
}

- (JCFooter *)footer
{
    return objc_getAssociatedObject(self, &JCFooterKey);
}

- (void)showFooter{
    self.footer.hidden = NO;
}

@end
