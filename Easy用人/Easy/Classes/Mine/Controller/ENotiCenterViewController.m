//
//  ENotiCenterViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ENotiCenterViewController.h"
#import "ENotiCenterTableCell.h"
#import "EMineViewModel.h"

@interface ENotiCenterViewController ()

@property (nonatomic, strong) EMineViewModel *viewModel;
@end

@implementation ENotiCenterViewController

- (EMineViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EMineViewModel alloc]init];
    }
    return _viewModel;
}

#pragma mark - *** cylce life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通知中心";
    self.tableView.rowHeight = E_RealHeight(65);
}

- (void)loadHeaderData{
    /// 无数据显示
    self.tableView.noDataView = [[ENoDataView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    
    JXWeak(self);
    self.viewModel.currentPage = 1;
    [self.viewModel getMsgList:^{
        [weakself endRefreshing];
        [weakself.tableView reloadData];
    }];
}

- (void)loadFooterData{
    JXWeak(self);
    self.viewModel.currentPage ++;
    [self.viewModel getMsgList:^{
        [weakself endRefreshing];
        [weakself.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ENotiCenterTableCell *cell = [ENotiCenterTableCell cellForTableView:tableView];
    cell.model = self.viewModel.models[indexPath.row];
    return cell;
}



@end
