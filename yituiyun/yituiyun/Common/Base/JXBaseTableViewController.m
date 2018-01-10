//
//  JXBaseTableViewController.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXBaseTableViewController.h"

@interface JXBaseTableViewController ()

@end

@implementation JXBaseTableViewController

- (JXNoDataImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        
        _nodataImageView = [[JXNoDataImageView alloc]initWithFrame:self.view.bounds];
    }
    return _nodataImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
    [self.view addSubview:self.nodataImageView];
    self.nodataImageView.hidden = YES;
    
    
    [self setupRefresh];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - 添加刷新
- (void)setupRefresh{
    [self.tableView setHeadRefreshWithTarget:self withAction:@selector(loadHeaderAction)];
    [self.tableView setFootRefreshWithTarget:self withAction:@selector(loadFooterAction)];
}

- (void)loadDataSuccess{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}


@end
