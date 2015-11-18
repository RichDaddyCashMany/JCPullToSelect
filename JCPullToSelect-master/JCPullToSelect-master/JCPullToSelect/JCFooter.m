//
//  JCFooter.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "JCFooter.h"
#import "JCPullToSelect.h"

#define FooterHeight 40

@interface JCFooter ()

@property (nonatomic, copy) JCFooterCallback callBack;
@property (nonatomic, weak) UIScrollView *superScrollView;
@property (nonatomic, getter=isCanRefresh) BOOL canRefresh;
@property (nonatomic, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) UIActivityIndicatorView *aiView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation JCFooter

+ (instancetype)footerWithCallback:(JCFooterCallback)callback{
    JCFooter *footer = [[JCFooter alloc] initWithFrame:CGRectMake(0, 0, JCScreenWidth, FooterHeight)];
    footer.backgroundColor = [UIColor clearColor];
    footer.callBack = callback;
    [footer setup];
    return footer;
}

- (void)setup{
    self.tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.tipLabel.text = JCFooterTipReadyText;
    self.tipLabel.font = JCFooterTipTextFont;
    self.tipLabel.textColor = JCFooterTipTextColor;
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipLabel];
    
    self.aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aiView.center = CGPointMake(JCScreenWidth * 0.35, self.frame.size.height * 0.5);
    [self addSubview:self.aiView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    
    self.superScrollView = (UIScrollView *)newSuperview;
    self.superScrollView.alwaysBounceVertical = YES;
    
    [self moveFooter];
    
    [self addObservers];
}

- (void)dealloc{
    [self removeObservers];
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
    [self moveFooter];
    
    if (self.superScrollView.isDragging) {
        self.canRefresh = NO;
        self.refreshing = NO;
        self.tipLabel.text = JCFooterTipReadyText;
        [self.aiView stopAnimating];
    } else {
        self.canRefresh = YES;
    }

    CGFloat contentInsetT = self.superScrollView.contentInset.top;
    CGFloat contentOffsetY = self.superScrollView.contentOffset.y;
    CGFloat rectH = self.superScrollView.frame.size.height;
    CGFloat contentSizeH = self.superScrollView.contentSize.height;
    CGFloat canScrollH = contentSizeH - (rectH - contentInsetT);
    CGFloat needContentOffsetY = -contentInsetT + canScrollH + FooterHeight;
    
    if (!self.canRefresh || self.refreshing || self.hidden) return;
    
    if (canScrollH > 0) {
        // 在屏幕外面
        if (contentOffsetY >= needContentOffsetY) {
            [self.superScrollView setContentOffset:CGPointMake(0, needContentOffsetY) animated:YES];
            [self refreshing];
        }
    } else {
        // 全部在屏幕里面
        if (canScrollH + FooterHeight > 0) {
            // 上拉控件在屏幕外面
            if (contentOffsetY >= needContentOffsetY) {
                [self.superScrollView setContentOffset:CGPointMake(0, needContentOffsetY) animated:YES];
                [self refreshing];
            }
        } else {
            // 上拉控件在屏幕里面，上拉操作完后，不改变contentOffset
            if (contentOffsetY >= -contentInsetT + FooterHeight) {
                [self refreshing];
            }
        }
    }
}

- (void)moveFooter{
    CGRect f = self.frame;
    f.origin.y = self.superScrollView .contentSize.height;
    self.frame = f;
}

- (void)refreshing{
    self.tipLabel.text = JCFooterTipRefreshingText;
    self.superScrollView.userInteractionEnabled = NO;
    self.refreshing = YES;
    [self.aiView startAnimating];
    self.callBack(self);
}

- (void)endRefreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.superScrollView.userInteractionEnabled = YES;
        self.tipLabel.text = JCFooterTipReadyText;
        [self.aiView stopAnimating];
    });
}

@end
