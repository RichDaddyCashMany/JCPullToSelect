//
//  JCHeader.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "JCHeader.h"
#import "JCPullToSelect.h"

// 勿改
#define BallRadius 25
#define BallWidth BallRadius * 2
#define ViewHeight 66
#define LeaveMoveRate 0.45

@interface JCHeader () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) JCBallLayer *ballLayer;
@property (nonatomic, strong) NSArray *normalViews;
@property (nonatomic, strong) NSArray *selectedViews;
@property (nonatomic, copy) JCHeaderCallback selectBlock;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, weak) UIScrollView *superScrollView;
@property (nonatomic, getter=isCanRefresh) BOOL canRefresh;
@property (nonatomic, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) UIImageView *rotationView;

@end

static NSInteger count;
static NSInteger defaultIndex;

@implementation JCHeader
{
    CGFloat margin;
    NSInteger index;
    CGFloat defaultOriginX;
    CGFloat defaultOriginY;
    CGFloat defaultRadiusH;
    CGFloat defaultRadiusWLeft;
    CGFloat defaultRadiusWRight;
    CGFloat originContentInsetTop;
}

- (instancetype)initWithFrame:(CGRect)frame ballLayerColor:(UIColor *)ballLayerColor{
    if (self = [super initWithFrame:frame]) {
        JCBallLayer *ballLayer = [[JCBallLayer alloc] init];
        ballLayer.frame = self.bounds;
        ballLayer.contentsScale = [UIScreen mainScreen].scale;
        ballLayer.ballColor = ballLayerColor;
        [self.layer addSublayer:ballLayer];
        self.ballLayer = ballLayer;
        
        self.rotationView = JCRefreshingView;
        self.rotationView.frame = CGRectMake(0, 0, BallWidth, BallWidth);
        [self addSubview:self.rotationView];
        self.rotationView.alpha = 0;
        
        [self initialization];
    }
    return self;
}

- (void)initialization{
    margin = (self.frame.size.width - BallWidth * count) / (count + 1);
    index = defaultIndex;
    
    defaultOriginX = BallRadius + BallWidth * index + margin * (index + 1);
    defaultOriginY = self.frame.size.height / 2;
    defaultRadiusH = BallRadius;
    defaultRadiusWLeft = BallRadius;
    defaultRadiusWRight = BallRadius;
    
    [self resetBall];
    
    [self.ballLayer setNeedsDisplay];
}

- (void)change:(CGFloat)change{
    [self ifShowTipLabel];
    
    [self moveLeftWithChange:change];
    [self moveRightWithChange:change];
    
    [self.ballLayer setNeedsDisplay];
}

- (void)moveLeftWithChange:(CGFloat)change{
    if (index == 0) return;
    CGFloat move = margin;
    change += defaultIndex * (margin + defaultRadiusH * 2);
    if (change < defaultRadiusH + margin + (defaultRadiusH * 2 + margin) * (index - 1)) {
        [self deformToLeftWithChange:change - margin - defaultRadiusH - (defaultRadiusH * 2 + margin) * (index - 1)];
    }
    if (change < defaultRadiusH + margin - move + (defaultRadiusH * 2 + margin) * (index - 1)) {
        index --;
        defaultOriginX = defaultRadiusH + defaultRadiusH * 2 * index + margin * (index + 1);
        [self.ballLayer animateToNewOriginX:defaultOriginX];
        [self resetBall];
        [self hasDrag];
    }
}

- (void)moveRightWithChange:(CGFloat)change{
    if (index == count -1) return;
    CGFloat move = margin;
    change += defaultIndex * (margin + defaultRadiusH * 2);
    if (change > defaultRadiusH + (margin + defaultRadiusH * 2) * index) {
        [self deformToRightWithChange:change - defaultRadiusH - (margin + defaultRadiusH * 2) * index];
    }
    if (change > defaultRadiusH + move + (margin + defaultRadiusH * 2) * index) {
        index ++;
        [self toggleFocusView];
        defaultOriginX = defaultRadiusH + defaultRadiusH * 2 * index + margin * (index + 1);
        [self.ballLayer animateToNewOriginX:defaultOriginX];
        [self resetBall];
        [self hasDrag];
    }
}

- (void)hasDrag{
    [[NSUserDefaults standardUserDefaults] setValue:JCPullToSelectHasDragedBallValue forKey:JCPullToSelectHasDragedBall];
}

- (void)resetBall{
    self.ballLayer.originX = defaultOriginX;
    self.ballLayer.originY = defaultOriginY;
    self.ballLayer.radiusH = defaultRadiusH;
    self.ballLayer.radiusWLeft = defaultRadiusWLeft;
    self.ballLayer.radiusWRight = defaultRadiusWRight;
    [self toggleFocusView];
}

- (void)toggleFocusView{
    NSInteger viewCount = self.normalViews.count;
    for (int i = 0; i<viewCount; i++) {
        UIView *normalView = self.normalViews[i];
        UIView *selectedView = self.selectedViews[i];
        normalView.hidden = i == index;
        selectedView.hidden = i != index;
    }
}

- (void)deformToRightWithChange:(CGFloat)change{
    CGFloat movex = change * LeaveMoveRate;
    CGFloat moveRadius = change * (1 - LeaveMoveRate);
    self.ballLayer.originX = defaultOriginX + movex;
    self.ballLayer.radiusWRight = defaultRadiusWRight + moveRadius * 0.6;
    self.ballLayer.radiusWLeft = defaultRadiusWLeft + moveRadius * 0.4;
}

- (void)deformToLeftWithChange:(CGFloat)change{
    change = -change;
    CGFloat movex = change * LeaveMoveRate;
    CGFloat moveRadius = change * (1 - LeaveMoveRate);
    self.ballLayer.originX = defaultOriginX - movex;
    self.ballLayer.radiusWRight = defaultRadiusWRight + moveRadius * 0.4;
    self.ballLayer.radiusWLeft = defaultRadiusWLeft + moveRadius * 0.6;
}

- (void)addNormalViews:(NSArray *)normalViews{
    self.normalViews = normalViews;
    NSInteger viewCount = normalViews.count;
    CGFloat viewMargin = (self.frame.size.width - BallWidth * viewCount) / (viewCount + 1);
    for (int i = 0; i<viewCount; i++) {
        UIView *view = normalViews[i];
        view.center = CGPointMake(BallRadius + BallWidth * i + viewMargin * (i + 1), defaultOriginY);
        [self addSubview:view];
    }
    [self toggleFocusView];
}

- (void)addSelectedViews:(NSArray *)selectedViews{
    self.selectedViews = selectedViews;
    NSInteger viewCount = selectedViews.count;
    CGFloat viewMargin = (self.frame.size.width - BallWidth * viewCount) / (viewCount + 1);
    for (int i = 0; i<viewCount; i++) {
        UIView *view = selectedViews[i];
        view.center = CGPointMake(BallRadius + BallWidth * i + viewMargin * (i + 1), defaultOriginY);
        [self addSubview:view];
        view.hidden = YES;
    }
    [self toggleFocusView];
}

+ (instancetype)headerWithDefaultIndex:(NSInteger)di ballColor:(UIColor *)bc normalViews:(NSArray *)normalViews selectedViews:(NSArray *)selectedViews callback:(JCHeaderCallback)callback{
    if (normalViews.count != selectedViews.count) {
        JCLog(@"JCPullToSelect Error：normalViews和selectedViews数量不相等");
        return nil;
    }
    if (di > normalViews.count - 1 || di < 0) {
        JCLog(@"JCPullToSelect Error：defaultIndex越界");
        return nil;
    }
    count = normalViews.count;
    defaultIndex = di;
    UIColor *ballColor = bc;
    if (!ballColor) {
        ballColor = JCDefaultBallColor;
    }
    JCHeader *header = [[JCHeader alloc] initWithFrame:CGRectMake(0, -ViewHeight, JCScreenWidth, ViewHeight) ballLayerColor:ballColor];
    header.selectBlock = callback;
    [header addNormalViews:normalViews];
    [header addSelectedViews:selectedViews];
    return header;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];

    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    
    self.superScrollView = (UIScrollView *)newSuperview;
    self.superScrollView.alwaysBounceVertical = YES;
    originContentInsetTop = self.superScrollView.contentInset.top;
    CGRect f = self.frame;
    f.origin.y -= originContentInsetTop;
    self.frame = f;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.superScrollView addGestureRecognizer:pan];
    
    [self addObservers];
    [self addTipLabel];
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self initialization];
    }
    CGPoint point = [gestureRecognizer translationInView:self];
    
    [self change:point.x];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}

- (void)dealloc{
    [self removeObservers];
    [self endRefreshing];
}

- (void)addTipLabel{
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -11, JCScreenWidth, 11)];
    self.tipLabel.text = JCFirstUseTipText;
    self.tipLabel.font = [UIFont systemFontOfSize:11];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = JCFirstUseTipTextColor;
    [self addSubview:self.tipLabel];
}

- (void)ifShowTipLabel{
    NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:JCPullToSelectHasDragedBall];
    self.tipLabel.hidden = [value isEqual:JCPullToSelectHasDragedBallValue] || count == 1;
}

- (void)addObservers{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)removeObservers{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    CGFloat newContentOffsetY = self.superScrollView.contentOffset.y;
    
    self.alpha = fabs(newContentOffsetY + self.superScrollView.contentInset.top) / ViewHeight;

    if (self.superScrollView.isDragging) {
        self.canRefresh = NO;
        self.refreshing = NO;
    } else {
        self.canRefresh = YES;
        defaultOriginX = defaultRadiusH + defaultRadiusH * 2 * index + margin * (index + 1);
        [self.ballLayer animateToNewOriginX:defaultOriginX];
        [self resetBall];
    }
    
    if (newContentOffsetY < -self.superScrollView.contentInset.top - ViewHeight && self.isCanRefresh && !self.isRefreshing) {
        [self.superScrollView setContentOffset:CGPointMake(0, -self.superScrollView.contentInset.top - ViewHeight) animated:YES];
        self.superScrollView.userInteractionEnabled = NO;
        self.refreshing = YES;
        [self refreshAnimating];
        [self.superScrollView showFooter];
        self.selectBlock(self, index);
    }
}

- (void)refreshAnimating{
    self.rotationView.center = CGPointMake(defaultOriginX, defaultOriginY);
    self.rotationView.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.rotationView.alpha = 1.0;
    } completion:^(BOOL finished) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        [self.rotationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }];
}

- (void)endRefreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rotationView.alpha = 0;
        [self.rotationView.layer removeAllAnimations];
        [self.superScrollView setContentOffset:CGPointMake(0, -self.superScrollView.contentInset.top) animated:YES];
        self.superScrollView.userInteractionEnabled = YES;
        [self.ballLayer removeAllAnimations];
    });
}

@end

