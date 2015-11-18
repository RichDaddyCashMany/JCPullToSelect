//
//  JCBallLayer.h
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface JCBallLayer : CALayer

@property (nonatomic, strong) UIColor *ballColor;

@property (nonatomic) CGFloat ratio;
@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;
@property (nonatomic) CGFloat radiusWLeft;
@property (nonatomic) CGFloat radiusWRight;
@property (nonatomic) CGFloat radiusH;

- (void)animateToNewOriginX:(CGFloat)newOriginX;

@end
