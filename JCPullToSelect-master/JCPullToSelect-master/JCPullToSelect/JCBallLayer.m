//
//  JCBallLayer.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "JCBallLayer.h"
#import "JCPullToSelect.h"

@implementation JCBallLayer

- (instancetype)init{
    if (self = [super init]) {
        self.ratio = 0.551915024494;
    }
    return self;
}

-(id)initWithLayer:(JCBallLayer *)layer{
    self = [super initWithLayer:layer];
    if (self) {
        self.ballColor = layer.ballColor;
        self.ratio = layer.ratio;
        self.originX = layer.originX;
        self.originY = layer.originY;
        self.radiusWLeft = layer.radiusWLeft;
        self.radiusWRight = layer.radiusWRight;
        self.radiusH = layer.radiusH;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx{
    CGFloat leftX = self.originX - self.radiusWLeft;
    CGFloat leftY = self.originY;
    
    CGFloat topX = self.originX;
    CGFloat topY = self.originY - self.radiusH;
    CGFloat controlX1 = leftX;
    CGFloat controlY1 = self.originY - self.radiusH * self.ratio;
    CGFloat controlX2 = self.originX - self.radiusWLeft * self.ratio;
    CGFloat controlY2 = self.originY - self.radiusH;
    
    CGFloat rightX = self.originX + self.radiusWRight;
    CGFloat rightY = self.originY;
    CGFloat controlX3 = self.originX + self.radiusWRight * self.ratio;
    CGFloat controlY3 = self.originY - self.radiusH;
    CGFloat controlX4 = rightX;
    CGFloat controlY4 = self.originY - self.radiusH * self.ratio;
    
    CGFloat bottomX = self.originX;
    CGFloat bottomY = self.originY + self.radiusH;
    CGFloat controlX5 = rightX;
    CGFloat controlY5 = self.originY + self.radiusH * self.ratio;
    CGFloat controlX6 = self.originX + self.radiusWRight * self.ratio;
    CGFloat controlY6 = self.originY + self.radiusH;
    
    CGFloat controlX7 = self.originX - self.radiusWLeft * self.ratio;
    CGFloat controlY7 = self.originY + self.radiusH;
    CGFloat controlX8 = leftX;
    CGFloat controlY8 = self.originY + self.radiusH * self.ratio;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(leftX, leftY)];
    [path addCurveToPoint:CGPointMake(topX, topY) controlPoint1:CGPointMake(controlX1, controlY1) controlPoint2:CGPointMake(controlX2, controlY2)];
    [path addCurveToPoint:CGPointMake(rightX, rightY) controlPoint1:CGPointMake(controlX3, controlY3) controlPoint2:CGPointMake(controlX4, controlY4)];
    [path addCurveToPoint:CGPointMake(bottomX, bottomY) controlPoint1:CGPointMake(controlX5, controlY5) controlPoint2:CGPointMake(controlX6, controlY6)];
    [path addCurveToPoint:CGPointMake(leftX, leftY) controlPoint1:CGPointMake(controlX7, controlY7) controlPoint2:CGPointMake(controlX8, controlY8)];
    
    [path closePath];
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetFillColorWithColor(ctx, self.ballColor.CGColor);
    CGContextFillPath(ctx);
}

- (void)animateToNewOriginX:(CGFloat)newOriginX{
    NSArray *keyPaths = @[@"radiusWLeft", @"radiusWRight", @"originX"];
    NSArray *valuesArray = @[@[@(self.radiusWLeft),@25],
                             @[@(self.radiusWRight),@25],
                             @[@(self.originX),@(newOriginX)]];
    
    for (int i = 0; i<keyPaths.count; i++) {
        [self animateWithKeyPath:keyPaths[i] values:valuesArray[i]];
    }
}

- (void)animateWithKeyPath:(NSString *)keyPath values:(NSArray *)values{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    anim.values = values;
    anim.duration = 0.15;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    [self addAnimation:anim forKey:keyPath];
}

- (void)refreshAnimating{
    NSArray *keyPaths = @[@"radiusWLeft", @"radiusWRight", @"radiusH"];
    NSArray *valuesArray = @[@[@(self.radiusWLeft),@15],
                             @[@(self.radiusWRight),@15],
                             @[@(self.radiusH),@15]];
    
    for (int i = 0; i<keyPaths.count; i++) {
        [self animateScaleWithKeyPath:keyPaths[i] values:valuesArray[i]];
    }
}

- (void)animateScaleWithKeyPath:(NSString *)keyPath values:(NSArray *)values{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    anim.values = values;
    anim.duration = 0.25;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    [self addAnimation:anim forKey:[NSString stringWithFormat:@"scale_%@", keyPath]];
}

+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"radiusWLeft"] || [key isEqualToString:@"radiusWRight"] || [key isEqualToString:@"originX"] || [key isEqualToString:@"radiusH"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self removeAnimationForKey:@"radiusWLeft"];
        [self removeAnimationForKey:@"radiusWRight"];
        [self removeAnimationForKey:@"originX"];
    }
}

@end
