//
//  EStatisticalTableViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EStatisticalTableViewController.h"
#import "EStatisticalTableHeaderView.h"
#import "EStatisticalTableCell.h"
#import "EStatisticalTableViewModel.h"

@interface EStatisticalTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextF;
@property (nonatomic, strong) EStatisticalTableHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EStatisticalTableViewModel *viewModel;

/// >>>>> 记录网络请求参数
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *keys;
@end

@implementation EStatisticalTableViewController

#pragma mark - *** lazy load
- (EStatisticalTableViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EStatisticalTableViewModel alloc]init];
    }
    return _viewModel;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (EStatisticalTableHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[EStatisticalTableHeaderView alloc]init];
        _headerView.hiddenPeopleNumLabel = YES;
        JXWeak(self);
        _headerView.filterBlock = ^{
            [weakself jx_showDataPickerWithCompleteBlock:^(NSDate *beginDate, NSDate *endDate) {
                if (beginDate && endDate) {
                    weakself.startTime = [NSString stringWithFormat:@"%lf",[beginDate timeIntervalSince1970]];
                    weakself.endTime = [NSString stringWithFormat:@"%lf",[endDate timeIntervalSince1970]];
                    [weakself.tableView.mj_header beginRefreshing];
                }
                else {
                    [weakself showHint:@"请选择正确的日期"];
                }
                
            }];
        };
    }
    return _headerView;
}

- (UITextField *)searchTextF{
    if (_searchTextF == nil) {
        _searchTextF = [[UITextField alloc]init];
        _searchTextF.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, 0, 15 + 43 * 0.5, 43 *0.5);
        leftView.centerY = _searchTextF.centerY;
        UIImageView *leftImageV = [[UIImageView alloc]init];
        leftImageV.frame = CGRectMake(15, 0, 43 * 0.5, 43 *0.5);
        leftImageV.image = [UIImage imageNamed:@"mine_sousuo"];
        [leftView addSubview:leftImageV];
        _searchTextF.leftView = leftView;
        _searchTextF.size = CGSizeMake(E_RealWidth(330), E_RealHeight(40));
        _searchTextF.cornerRadius = E_RealHeight(20);
        _searchTextF.backgroundColor = [UIColor whiteColor];
        [_searchTextF addTarget:self action:@selector(searchTextAction:) forControlEvents:UIControlEventEditingDidEndOnExit | UIControlEventEditingDidEnd];
        _searchTextF.returnKeyType = UIReturnKeySearch;
        _searchTextF.delegate = self;
    }
    return _searchTextF;
}

#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"统计表";
    [self setupUI];
    [self setupRefresh];
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.tableView.noDataView == nil) {
        /// 无数据显示
        self.tableView.noDataView = [[ENoDataView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    }
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - *** Private Method
- (void)setupUI{
    [self.view addSubview:self.searchTextF];
    [self.searchTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 + E_StatusBarAndNavigationBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(330), E_RealHeight(40)));
    }];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextF.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(88);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(0.5);
    }];
}

- (void)setupRefresh{
    
    MJWeakSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.viewModel.currentPage = 1;
        [weakSelf.viewModel demandGroupManageWithDemandPriceId:@"0" targetUserId:nil startTime:weakSelf.startTime endTime:weakSelf.endTime keys:weakSelf.keys completion:^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView  reloadData];
            weakSelf.headerView.price = weakSelf.viewModel.totalPrice;
        }];
    }];
    
    self.tableView.mj_header = header;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.viewModel.currentPage ++;
        [weakSelf.viewModel demandGroupManageWithDemandPriceId:@"0" targetUserId:nil startTime:weakSelf.startTime endTime:weakSelf.endTime keys:weakSelf.keys completion:^{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView  reloadData];
            weakSelf.headerView.price = weakSelf.viewModel.totalPrice;
        }];
    }];
    
    self.tableView.mj_footer = footer;
    
}

#pragma mark - *** Actions
- (void)searchTextAction:(UITextField *)textF{
    self.keys = textF.text;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.tableModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EStatisticalTableCell *cell = [EStatisticalTableCell cellForTableView:tableView];
    cell.model = self.viewModel.tableModels[indexPath.row];
    return cell;
}

#pragma mark - *** UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
