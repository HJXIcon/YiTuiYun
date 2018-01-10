/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AddFriendViewController.h"
#import "InvitationManager.h"
#import "ApplyViewController.h"
#import "AddLocationViewController.h"
#import "AddLocationFriendCell.h"
#import "EMSearchBar.h"
#import "FXPersonDetailController.h"
#import "FXCompanyDetailController.h"
#import "AddFriendModel.h"

@interface AddFriendViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@property (nonatomic, assign) NSInteger where;
@end

@implementation AddFriendViewController
- (instancetype)initWithBDOrEnterprise:(NSInteger)where
{
    if (self = [super init]) {
        self.dataSource = [NSMutableArray array];
        self.page = @"1";
        self.isremo = YES;
        self.where = where;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHud];
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

- (void)getGoodsData
{
    __weak AddFriendViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"pagesize"] = @"10";
//    params[@"page"] = _page;
    if (_where == 1) {
        params[@"uModelid"] = @"6";
    } else if (_where == 2) {
        params[@"uModelid"] = @"5";
    }
    params[@"uid"] = model.userID;
    params[@"keyword"] = self.text;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.search"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    AddFriendModel *model = [[AddFriendModel alloc] init];
                    model.avatar = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"avatar"]];
                    model.nickname = [NSString stringWithFormat:@"%@", subDic[@"nickname"]];
                    model.industry = [NSString stringWithFormat:@"%@", subDic[@"industry"]];
                    model.uid = [NSString stringWithFormat:@"%@", subDic[@"uid"]];
                    model.desc = [NSString stringWithFormat:@"%@", subDic[@"desired"]];
                    model.sex = [NSString stringWithFormat:@"%@", subDic[@"sex"]];
//                    model.sex = [NSString stringWithFormat:@"%@", @"2"];
//                    model.desc = [NSString stringWithFormat:@"%@", @"我在地铁上，你问这问题我也查不了啊"];
                    [listDataArray addObject:model];
                }
            }
            [weakSelf configuration:listDataArray];
        } else {
            if (![_page isEqualToString:@"1"]) {
                int i = [_page intValue];
                self.page = [NSString stringWithFormat:@"%d", i - 1];
            }
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

- (void)configuration:(NSArray *)array
{
    if (_isremo == YES) {
        if ([self.dataSource count] != 0) {
            [self.dataSource removeAllObjects];
        }
    }
    if (![ZQ_CommonTool isEmptyArray:array]) {
        [self.dataSource addObjectsFromArray:array];
    }
    if (self.dataSource.count == 0) {
        self.tableView.tableHeaderView = self.thereLabel;
        if (_where == 1) {
            _thereLabel.text = @"没有搜索到符合要求的人";
        } else if (_where == 2) {
            _thereLabel.text = @"没有搜索到符合要求的企业";
        }
    } else {
        self.tableView.tableHeaderView = self.thereLabel1;
    }
    [self.tableView reloadData];
}

- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}

- (UILabel *)thereLabel1
{
    if (!_thereLabel1) {
        _thereLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.0000001)];
    }
    return _thereLabel1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNav];
    [self setUpTableView];
//    [self setupRefresh];    
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"添加好友";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView
{
    [self.view addSubview:self.searchBar];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 101, self.view.frame.size.width, self.view.frame.size.height - 64 - 101) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark - 添加刷新
- (void)setupRefresh{
    [_tableView setHeadRefreshWithTarget:self withAction:@selector(loadNewStatus)];
    [_tableView setFootRefreshWithTarget:self withAction:@selector(loadMoreStatus)];
}

#pragma mark 下拉刷新
- (void)loadNewStatus
{
    self.isremo = YES;
    self.page = @"1";
    [_tableView endRefreshing];
    [self getGoodsData];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    [self getGoodsData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter
#pragma mark - private
//搜索框
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, ZQ_Device_Width, 50)];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
        
        ZQImageAndLabelButton *nearSearchButton = [[ZQImageAndLabelButton alloc] initWithFrame:ZQ_RECT_CREATE(0, 50, ZQ_Device_Width, 50)];
        nearSearchButton.backgroundColor = [UIColor whiteColor];
        nearSearchButton.imageV.image = [UIImage imageNamed:@"nearSearch"];
        nearSearchButton.label.textColor = kUIColorFromRGB(0x404040);
        nearSearchButton.label.font = [UIFont systemFontOfSize:15];
        nearSearchButton.imageV.frame = ZQ_RECT_CREATE(12, 10, 30, 30);
        nearSearchButton.label.frame = ZQ_RECT_CREATE(62, 0, ZQ_Device_Width - 62, 50);
        [nearSearchButton addTarget:self action:@selector(nearSearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nearSearchButton];
        
        if (_where == 1) {
            _searchBar.placeholder = @"姓名/手机号";
            nearSearchButton.label.text = @"附近的人";
        } else if (_where == 2) {
            _searchBar.placeholder = @"企业名称/负责人手机号";
            nearSearchButton.label.text = @"附近的企业";
        }
    }
    
    return _searchBar;
}

- (void)nearSearchButtonClick
{
    [self searchBarCancelButtonClicked:_searchBar];
    AddLocationViewController *vc = [[AddLocationViewController alloc] initWithBDOrEnterprise:_where];
    pushToControllerWithAnimated(vc)
        
}

#pragma mark - UISearchBarDelegate
//搜索将要开始
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [_dataSource removeAllObjects];
    [_tableView reloadData];
    
    return YES;
}

//输入字时
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.text = searchText;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.isremo = YES;
    self.page = @"1";
    [self getGoodsData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00000000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddLocationFriendCell *cell = [AddLocationFriendCell choseCellWithTableView:tableView];
    
    AddFriendModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.addFriendModel = model;

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *userInfo = [ZQ_AppCache userInfoVo];
    AddFriendModel *model = [self.dataSource objectAtIndex:indexPath.section];
    if ([userInfo.identity integerValue] == 6) {
        FXPersonDetailController *detailVc = [[FXPersonDetailController alloc] initPersonId:model.uid];
        pushToControllerWithAnimated(detailVc)
    } else if ([userInfo.identity integerValue] == 5) {
        FXCompanyDetailController *vc = [[FXCompanyDetailController alloc] initCompanyID:model.uid];
        pushToControllerWithAnimated(vc)
    }

}

@end
