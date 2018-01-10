//
//  EHomeListViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/24.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeListViewController.h"
#import "EHomeListWagesHeaderView.h"
#import "EHomeListRecordCell.h"
#import "EHomeListHeaderView.h"
#import "EHomeViewModel.h"

@interface EHomeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EHomeViewModel *viewModel;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) EHomeListHeaderView *headerView;
@end

@implementation EHomeListViewController
- (EHomeListHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[EHomeListHeaderView alloc] init];
        JXWeak(self);
        _headerView.filterBlock = ^{
            [weakself jx_showDataPickerWithCompleteBlock:^(NSDate *beginDate, NSDate *endDate) {
                
                weakself.startTime = [NSString stringWithFormat:@"%.0lf",[beginDate timeIntervalSince1970]];
                weakself.endTime = [NSString stringWithFormat:@"%.0lf",[endDate timeIntervalSince1970]];
                [weakself.tableView.mj_header beginRefreshing];
            }];
        };
    }
    return _headerView;
}
- (EHomeViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EHomeViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 50;
    }
    return _tableView;
}


#pragma mark - *** Cycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    adjustsScrollViewInsets(self.tableView);
    [self setupRefresh];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - *** Private Method
- (void)setupUI{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(EHomeListHeaderViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
}
- (void)setupRefresh{
    MJWeakSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRefreshing];
    }];
    
    self.tableView.mj_header = header;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRefreshing];
    }];
    
    self.tableView.mj_footer = footer;
    
}

- (void)headerRefreshing{
    /// 无数据显示
    self.tableView.noDataView = [[ENoDataView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    
    MJWeakSelf
    self.viewModel.currentPage = 1;
    [self.viewModel getListWithHotelId:self.hotelId startTime:self.startTime endTime:self.endTime completion:^{
        
        weakSelf.headerView.price = weakSelf.viewModel.totalPrice;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)footerRefreshing{
    MJWeakSelf
    self.viewModel.currentPage ++;
    [self.viewModel getListWithHotelId:self.hotelId startTime:self.startTime endTime:self.endTime completion:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.homeLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EHomeListRecordCell *cell = [EHomeListRecordCell cellForTableView:tableView];
    
    cell.model = self.viewModel.homeLists[indexPath.row];
    return cell;
    
    
}



@end
