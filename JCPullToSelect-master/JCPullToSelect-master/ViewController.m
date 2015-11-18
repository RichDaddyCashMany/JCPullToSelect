//
//  ViewController.m
//  JCPullToSelect-master
//
//  Created by mac on 15/11/12.
//  Copyright © 2015年 HJaycee. All rights reserved.
//

#import "ViewController.h"
#import "JCPullToSelect.h"
#import "JCTableViewController.h"
#import "JCCollectionViewController.h"
#import "JCWebViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JCPullToSelect Demo";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"JCTableViewController";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"JCCollectionViewController";
    } else if (indexPath.row == 2){
        cell.textLabel.text = @"JCWebViewController";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[JCTableViewController new] animated:YES];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[JCCollectionViewController new] animated:YES];
    } else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[JCWebViewController new] animated:YES];
    }
    
}

@end
