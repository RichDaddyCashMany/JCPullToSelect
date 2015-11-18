//
//  JCWebViewController.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "JCWebViewController.h"
#import "JCPullToSelect.h"

@implementation JCWebViewController
{
    UIWebView *_webView;
    NSString *_urlStr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"JCWebViewController";

    CGFloat Y = [UIDevice currentDevice].systemVersion.floatValue < 7 ? 0 : 64;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, Y, JCScreenWidth, JCScreenHeight - 64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    [self loadWebWithFilename:@"1.html"];
    
    UILabel *labelNormal1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    labelNormal1.text = @"网页1";
    [self configLabel:labelNormal1];
    
    UILabel *labelSelected1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    labelSelected1.text = @"网页1";
    labelSelected1.textColor = [UIColor whiteColor];
    [self configLabel:labelSelected1];
    
    UILabel *labelNormal2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    labelNormal2.text = @"网页2";
    [self configLabel:labelNormal2];
    
    UILabel *labelSelected2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    labelSelected2.text = @"网页2";
    labelSelected2.textColor = [UIColor whiteColor];
    [self configLabel:labelSelected2];
    
    // 下拉刷新
    _webView.scrollView.header = [JCHeader headerWithDefaultIndex:0 ballColor:[UIColor purpleColor] normalViews:@[labelNormal1,labelNormal2] selectedViews:@[labelSelected1,labelSelected2] callback:^(JCHeader *header, NSInteger index) {
        // 模拟服务器请求延时（拿去用的时候请删除这段代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (index == 0) {
                [self loadWebWithFilename:@"1.html"];
            } else {
                [self loadWebWithFilename:@"2.html"];
            }
            // 停止刷新
            [header endRefreshing];
        });
    }];
}

- (void)configLabel:(UILabel *)label{
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
}

- (void)loadWebWithFilename:(NSString *)fileName{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [_webView loadRequest:request];
}

@end
