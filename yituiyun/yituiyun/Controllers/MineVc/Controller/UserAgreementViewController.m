//
//  UserAgreementViewController.m
//  yituiyun
//
//  Created by 张强 on 2016/12/3.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "UserAgreementViewController.h"
#import "UserAgreementModel.h"
#import "UserAgreementCell.h"
#import "TodaySummaryViewController.h"
#import "PushWebViewController.h"

@interface UserAgreementViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@property (nonatomic, assign) NSInteger where;
@end

@implementation UserAgreementViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (instancetype)initWithWhere:(NSInteger)where
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
    [self setupRefresh];
    [self dataArrayFromNetwork];
}

#pragma mark 请求网络数据
- (void)dataArrayFromNetwork {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak UserAgreementViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @"10";
    params[@"page"] = _page;
    params[@"uid"] = model.userID;
    params[@"uModelid"] = @"5";

    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=setpdf.pdfInfo"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    UserAgreementModel *model = [[UserAgreementModel alloc] init];
                    model.name = [NSString stringWithFormat:@"%@%@", subDic[@"projectName"], @"项目用户使用协议"];
                    model.time = [NSString stringWithFormat:@"%@", subDic[@"inputtime"]];
//                    model.link = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"pdf_url"]];
                    model.recordid =[NSString stringWithFormat:@"%@", subDic[@"recordid"]];
                    NSString *pdfpath = [NSString stringWithFormat:@"%@index.php?m=default.pdf_detail&recordid=%@",kHost,model.recordid];
                    
                    
                    model.link = pdfpath;
                    
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
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)configuration:(NSArray *)array
{
    if (_isremo == YES) {
        if ([_dataArray count] != 0) {
            [_dataArray removeAllObjects];
        }
    }
    if (![ZQ_CommonTool isEmptyArray:array]) {
        [_dataArray addObjectsFromArray:array];
    }
    if (_dataArray.count == 0) {
        self.tableView.tableHeaderView = self.thereLabel;
    } else {
        self.tableView.tableHeaderView = self.thereLabel1;
    }
    [self.tableView reloadData];
}

- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"没有更多协议";
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

- (void)setupNav{
    self.title = @"项目合同";
   
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
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
    [self dataArrayFromNetwork];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    [self dataArrayFromNetwork];
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataArray.count - 1 == section) {
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserAgreementCell *cell = [UserAgreementCell cellWithTableView:tableView];
    UserAgreementModel *model = _dataArray[indexPath.section];
    cell.userAgreementModel = model;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserAgreementModel *model = _dataArray[indexPath.section];
    PushWebViewController *vc = [[PushWebViewController alloc] initWith:model.link WithWhere:1];
    vc.title = @"易推云平台使用协议";
    pushToControllerWithAnimated(vc)
}

@end
