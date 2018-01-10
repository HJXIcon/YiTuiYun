//
//  EMyCommentViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMyCommentViewController.h"
#import "EMyCommentCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "EMyCommentViewModel.h"

@interface EMyCommentViewController ()

@property (nonatomic, strong) EMyCommentViewModel *viewModel;

@end

@implementation EMyCommentViewController
#pragma mark - *** lazy load
- (EMyCommentViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EMyCommentViewModel alloc]init];
    }
    return _viewModel;
}

#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title  = @"我的评价";
    [self.tableView registerClass:[EMyCommentCell class] forCellReuseIdentifier:@"myCommentCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = EBackgroundColor;
}


- (void)loadHeaderData{
    /// 无数据显示
    self.tableView.noDataView = [[ENoDataView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    
    JXWeak(self);
    self.viewModel.currentPage = 1;
    [self.viewModel getMyCommentList:^{
        [weakself endRefreshing];
        [weakself.tableView reloadData];
        
    }];
}

- (void)loadFooterData{
    JXWeak(self);
    self.viewModel.currentPage ++;
    [self.viewModel getMyCommentList:^{
        [weakself endRefreshing];
        [weakself.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.myCommentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCommentCell"];
    cell.model = self.viewModel.myCommentList[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"myCommentCell" configuration:^(EMyCommentCell *cell) {
        
        cell.model = self.viewModel.myCommentList[indexPath.row];
    }] + 10;
}

@end
