
//
//  JCCollectionViewController.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "JCCollectionViewController.h"
#import "JCPullToSelect.h"

@interface JCCollectionViewController()

@property (strong, nonatomic) NSMutableArray *colors;

@end

@implementation JCCollectionViewController

- (NSMutableArray *)colors
{
    if (!_colors) {
        self.colors = [NSMutableArray array];
    }
    return _colors;
}

- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (JCScreenWidth - 30) / 2;
    layout.itemSize = CGSizeMake(width, width);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return [self initWithCollectionViewLayout:layout];
}

static NSString *const JCCollectionViewCellIdentifier = @"color";
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"JCCollectionViewController";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:JCCollectionViewCellIdentifier];
    
    [self updateColor];
    
    // 下拉刷新
    self.collectionView.header = [JCHeader headerWithDefaultIndex:0 ballColor:[UIColor orangeColor] normalViews:@[JCNormalRefreshView] selectedViews:@[JCSelectedRefreshView] callback:^(JCHeader *header, NSInteger index) {
        // 模拟服务器请求延时（拿去用的时候请删除这段代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 改变格子颜色
            [self updateColor];
            // 停止刷新
            [header endRefreshing];
        });
    }];
}

- (void)updateColor{
    [self.colors removeAllObjects];
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    for (int i = 0; i<10; i++) {
        [self.colors addObject:color];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JCCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

@end
