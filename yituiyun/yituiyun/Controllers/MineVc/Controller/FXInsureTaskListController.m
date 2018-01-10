//
//  FXInsureTaskListController.m
//  yituiyun
//
//  Created by fx on 16/10/20.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXInsureTaskListController.h"
#import "ProjectModel.h"
#import "TaskHallCell.h"
#import "FXChoseInsureController.h"
#import "FXInsureBuyListController.h"

@interface FXInsureTaskListController ()<UITableViewDelegate,UITableViewDataSource>

/** 数据源  */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 主视图 */
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@property (nonatomic, assign) NSInteger where;

@end

@implementation FXInsureTaskListController

- (instancetype)initWith:(NSInteger)where
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
        self.where = where;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setUpHeaderView];
    [self setUpTableView];
    [self setupRefresh];
    [self getMyTaskHall];
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"选择投保任务";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = kUIColorFromRGB(0xffffff);

}

- (void)leftBarButtonItem{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//明细
- (void)detailBtnClick{
    FXInsureBuyListController *listVc = [[FXInsureBuyListController alloc] init];
    [self.navigationController pushViewController:listVc animated:YES];
}

- (void)setUpHeaderView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    backView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [self.view addSubview:backView];
    
    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
    starLabel.text = @"*";
    starLabel.textAlignment = NSTextAlignmentCenter;
    starLabel.textColor = MainColor;
    [backView addSubview:starLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, self.view.frame.size.width - 40, 40)];
    titleLabel.text = @"保险是针对每个项目单独购买的，上传凭证截图时也需单独上传";
    titleLabel.textColor = kUIColorFromRGB(0x404040);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [backView addSubview:titleLabel];
}

- (void)getMyTaskHall 
{
    __weak FXInsureTaskListController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    [self showHudInView:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = model.userID;
    params[@"status"] = @"0,1";
    params[@"page"] = _page;
    params[@"pagesize"] = @"10";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.myTasks"];
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
                    model.isNew = @"0";
                    model.timeType = [NSString stringWithFormat:@"%@", subDic[@"timeType"]];
                    model.projectPrice = [NSString stringWithFormat:@"%@", subDic[@"wn"]];
                    model.doingName = [NSString stringWithFormat:@"%@", subDic[@"doingName"]];
                    model.doingDemandid = [NSString stringWithFormat:@"%@", subDic[@"doingDemandid"]];
                    model.status = [NSString stringWithFormat:@"%@", subDic[@"status"]];
                    model.startTime = subDic[@"startDate"];
                    model.endTime = subDic[@"endDate"];
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
        _thereLabel.text = @"您无需要购买保险的任务";
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

-(void)setUpTableView{
    //初始化 tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height - 64 - 46) style:UITableViewStyleGrouped];
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
    [self getMyTaskHall];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    [self getMyTaskHall];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"taskHallCell";
    TaskHallCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TaskHallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ProjectModel *model = _dataArray[indexPath.section];
    cell.model = model;
    cell.button.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectModel *model = _dataArray[indexPath.section];
    FXChoseInsureController *taskVc = [[FXChoseInsureController alloc] initWithProjectModel:model];
    taskVc.taskId = model.projectId;
    taskVc.taskLastDays = model.timeType;
    taskVc.taskStartDate = model.startTime;
    if ([model.timeType isEqualToString:@"9999"]) {
        taskVc.taskEndDate = @"2099-12-31";
    }else{
        taskVc.taskEndDate = model.endTime;
    }
    taskVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskVc animated:YES];
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _dataArray.count - 1) {
        return 10;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
