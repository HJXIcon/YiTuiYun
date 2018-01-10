//
//  EPartManagerViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPartManagerViewController.h"
#import "EPartManagerViewController+NoData.h"
#import "EPartManagerCell.h"
#import "EPartManagerHeaderView.h"
#import "EPartManagerViewModel.h"
#import "EStatisticalTableViewController.h"
#import "EEntryFormViewController.h"

@interface EPartManagerViewController ()
@property (nonatomic, strong) EPartManagerViewModel *viewModel;
@end

@implementation EPartManagerViewController
#pragma mark - *** lazy load
- (EPartManagerViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EPartManagerViewModel alloc]init];
    }
    return _viewModel;
}


#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兼职管理";
    self.tableView.rowHeight = E_RealHeight(144);
    self.tableView.backgroundColor = EBackgroundColor;
    [self.tableView registerClass:[EPartManagerHeaderView class] forHeaderFooterViewReuseIdentifier:@"EPartManagerHeaderView"];
    
    [self jx_showNoDataView];
}

#pragma mark - *** override
- (void)loadHeaderData{
    
    self.viewModel.currentPage = 1;
    JXWeak(self);
    [self.viewModel getPartManagerListData:^{
        [weakself endRefreshing];
        if (weakself.viewModel.partManagerLists.count == 0) {
            return ;
        }
        [weakself jx_removeNoDataView];
        [weakself.tableView reloadData];
        weakself.refresh = YES;
    }];
}

- (void)loadFooterData{
    self.viewModel.currentPage ++;
    JXWeak(self);
    [self.viewModel getPartManagerListData:^{
        [weakself endRefreshing];
        [weakself.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.partManagerLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JXWeak(self);
    EPartManagerCell *cell = [EPartManagerCell cellForTableView:tableView];
    cell.model = self.viewModel.partManagerLists[indexPath.row];
    cell.signBlock = ^{
        EEntryFormViewController *vc = [[EEntryFormViewController alloc]init];
        vc.demandPriceId = self.viewModel.partManagerLists[indexPath.row].demandPriceId;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        JXWeak(self);
        EPartManagerHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EPartManagerHeaderView"];
        header.frame = CGRectMake(0, 0, kScreenW, E_RealHeight(44));
        header.headerBlock = ^{
            [weakself.navigationController pushViewController:[[EStatisticalTableViewController alloc]init] animated:YES];
        };
        return header;
    }
    
    return  [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? E_RealHeight(44) : 0.00001;
}


@end
