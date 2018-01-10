//
//  WorkerTaskViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/1/11.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "WorkerTaskViewController.h"
#import "ProjectModel.h"
#import "HomeListTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "MyLogViewController.h"

@interface WorkerTaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;

@property (nonatomic, assign) NSInteger where;
@end

@implementation WorkerTaskViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (instancetype)initWith:(NSInteger)where
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
    __weak WorkerTaskViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = [USERDEFALUTS objectForKey:@"location"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"t"] = @"2";
    params[@"status"] = @"6";
    params[@"page"] = _page;
    params[@"pagesize"] = @"10";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    ProjectModel *model = [[ProjectModel alloc] init];
                    model.projectId = [NSString stringWithFormat:@"%@", subDic[@"demandid"]];
                    model.projectName = [NSString stringWithFormat:@"%@", subDic[@"projectName"]];
                    model.projectImage = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"thumb"]];
                    model.tagArray = [NSMutableArray array];
                    [model.tagArray addObjectsFromArray:subDic[@"tags"]];
                    model.projectTime = [NSString stringWithFormat:@"%@", subDic[@"timeTypeStr"]];
                    NSInteger time1 = [subDic[@"inputtime"] integerValue];
                    NSInteger time2 = 86400 * 3 + time1;
                    NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
                    if (time1 <= [timeSp integerValue] && [timeSp integerValue] <= time2) {
                        model.isNew = @"1";
                    } else {
                        model.isNew = @"0";
                    }
                    model.timeType = [NSString stringWithFormat:@"%@", subDic[@"timeType"]];
                    model.projectPrice = [NSString stringWithFormat:@"%@", subDic[@"wn"]];
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
        _thereLabel.text = @"没有职工任务";
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
    self.title = @"职工任务";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"workerLogs" selectedImage:@"workerLogs" target:self action:@selector(rightBarButtonItemClick)];

}

- (void)leftBarButtonItem{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemClick
{
    MyLogViewController *vc = [[MyLogViewController alloc] initWithWhere:2];
    pushToControllerWithAnimated(vc)
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
    if (section == 0) {
        return 10;
    }
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"WorkerTaskView";
    HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HomeListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ProjectModel *projectModel = _dataArray[indexPath.section];
    cell.model = projectModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *userInfoModel = [ZQ_AppCache userInfoVo];
    if ([userInfoModel.userID isEqualToString:@"0"]) {
        [ZQ_CallMethod againLogin];
    } else {
        ProjectModel *projectModel = _dataArray[indexPath.section];
        ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:projectModel.projectId WithType:@"6" WithWhere:1];
        pushToControllerWithAnimated(vc)
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
