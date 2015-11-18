//
//  JCTableViewController.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "JCTableViewController.h"
#import "JCPullToSelect.h"

@interface JCTableViewController ()
{
    NSInteger _loadMore;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JCTableViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"JCTableViewController";
    
    self.tableView.backgroundColor = JCColor(245, 245, 245); 
    
    // 默认不对数据排序
    [self noSort];
    
    UIImageView *upViewNormal = [self createImageView:@"jc_up_normal"];
    UIImageView *downViewNormal = [self createImageView:@"jc_down_normal"];
    UIImageView *upViewSelected = [self createImageView:@"jc_up_selected"];
    UIImageView *downViewSelected = [self createImageView:@"jc_down_selected"];
    
    // 普通状态的view数组，显示在弹性球上面
    NSArray *normalViews = @[upViewNormal, JCNormalRefreshView, downViewNormal];
    // 选中状态的view数组，显示在弹性球上面
    NSArray *selectedViews = @[upViewSelected, JCSelectedRefreshView, downViewSelected];
    
    // 下拉刷新
    self.tableView.header = [JCHeader headerWithDefaultIndex:1 ballColor:nil normalViews:normalViews selectedViews:selectedViews callback:^(JCHeader *header, NSInteger index) {
        // 模拟服务器请求延时（拿去用的时候请删除这段代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (index) {
                case 0:
                    [self sortAscending];
                    break;
                case 1:
                    [self noSort];
                    break;
                case 2:
                    [self sortDescending];
                    break;
            }
            // 停止刷新
            [header endRefreshing];
        });
    }];
    
    // 用来标记上拉次数（仅供测试）
    _loadMore = 0;
    
    // 上拉刷新
    self.tableView.footer = [JCFooter footerWithCallback:^(JCFooter *footer) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [footer endRefreshing];
            
            // 假设上拉刷新2次以后服务器不再返回数据了（拿去用的时候请删除这段代码）
            _loadMore ++;
            if (_loadMore > 1) {
                // 隐藏footer，用于关闭上拉刷新功能
                footer.hidden = YES;
                _loadMore = 0;
            }
            // 随机数据
            for (int i = 0; i<5; i++) {
                [self.dataArray addObject:[NSString stringWithFormat:@"%zi", arc4random_uniform(1000)]];
            }
            // 刷新表格
            [self.tableView reloadData];
        });
    }];
}

// 升序
- (void)sortAscending{
    NSArray *array = @[@"1",@"2", @"3", @"4", @"5"];
    [self.dataArray removeAllObjects];
    for (NSString *str in array) {
        [self.dataArray addObject:str];
    }
    [self.tableView reloadData];
}

// 降序
- (void)sortDescending{
    NSArray *array = @[@"5",@"4", @"3", @"2", @"1"];
    [self.dataArray removeAllObjects];
    for (NSString *str in array) {
        [self.dataArray addObject:str];
    }
    [self.tableView reloadData];
}

// 不排序
- (void)noSort{
    NSArray *array = @[@"3",@"5", @"1", @"4", @"2"];
    [self.dataArray removeAllObjects];
    for (NSString *str in array) {
        [self.dataArray addObject:str];
    }
    [self.tableView reloadData];
}

- (UIImageView *)createImageView:(NSString *)name{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

@end
