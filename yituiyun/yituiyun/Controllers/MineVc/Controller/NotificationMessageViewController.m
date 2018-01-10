//
//  NotificationMessageViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/28.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "NotificationMessageViewController.h"
#import "NotificationMessageModel.h"
#import "NotificationMessageCell.h"
#import "GoodsDetailViewController.h"
#import "GoodsModel.h"

#import "FXMyWalletController.h"
#import "FXNeedsListController.h"
#import "TaskDetailViewController.h"
#import "FXInsureTaskListController.h"
#import "GoodsListViewController.h"
#import "InformationListViewController.h"
#import "ProjectDetailViewController.h"
#import "LHKNotificationCell.h"
#import "NSString+LHKExtension.h"
#import "RealNameVc.h"


@interface NotificationMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NotificationMessageCell *messageCell;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@end

@implementation NotificationMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
        self.page = @"1";
        self.isremo = YES;
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
    [USERDEFALUTS setInteger:0 forKey:@"pushMessageCount"];
    [USERDEFALUTS synchronize];

    [self setupNav];
    [self setupTableView];
    [self setupRefresh];
    [self dataArrayFromNetwork];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.frame = self.view.bounds;
}

#pragma mark 请求网络数据
- (void)dataArrayFromNetwork {
    
//    [self showHudInView:self.view hint:@"加载中..."];
    __weak NotificationMessageViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = _page;
    params[@"pagesize"] = @"15";
    params[@"uid"] = model.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.msgList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            
          
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    NotificationMessageModel *model = [[NotificationMessageModel alloc] init];
                    model.title = [NSString stringWithFormat:@"%@", subDic[@"title"]];
                    model.time = [NSString stringWithFormat:@"%@", subDic[@"addtime"]];
                    model.messageId = [NSString stringWithFormat:@"%@", subDic[@"mid"]];
                    model.describe = [NSString stringWithFormat:@"%@", subDic[@"content"]];
                    model.type = [NSString stringWithFormat:@"%@", subDic[@"type"]];
                    model.isread = [NSString stringWithFormat:@"%@", subDic[@"isread"]];
                    model.dataId = [NSString stringWithFormat:@"%@", subDic[@"params"]];
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
//        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
        if (![_page isEqualToString:@"1"]) {
            int i = [_page intValue];
            self.page = [NSString stringWithFormat:@"%d", i - 1];
        }
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
        _thereLabel.text = @"没有更多内容";
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
    self.title = @"通知中心";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 50;
    
    [_tableView registerNib:[UINib nibWithNibName:@"LHKNotificationCell" bundle:nil] forCellReuseIdentifier:@"LHKNotificationCell"];
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
    [self.dataArray removeAllObjects];
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HRadio(10);
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (_dataArray.count - 1 == section) {
//        return 10;
//    }
//    return 0.00001;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return _messageCell.height;
//    return HRadio(100);
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NotificationMessageCell* cell = [NotificationMessageCell cellWithTableView:tableView];
//    _messageCell = cell;
//    NotificationMessageModel *model = _dataArray[indexPath.section];
//    cell.messageModel = model;
    
//   

////    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    LHKNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHKNotificationCell"];
      NotificationMessageModel *model = self.dataArray[indexPath.section];
    
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");

    cell.shenTitle.text =model.title;
    cell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model.time];
    cell.contenetLabel.text = model.describe;
    cell.iconView.image = [UIImage imageNamed:[NSString noticeNameWithType:[model.type integerValue]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotificationMessageModel *model = _dataArray[indexPath.section];
    [self readMsg:model.messageId];
    NSInteger key = [model.type integerValue];
    if (key == 1) {//提现驳回  橙色
        FXMyWalletController *walletVc = [[FXMyWalletController alloc] initWithWhere:1];
        walletVc.hidesBottomBarWhenPushed = YES;
        pushToControllerWithAnimated(walletVc)
    } else if (key == 3) {//需求 绿色
        FXNeedsListController *needVc = [[FXNeedsListController alloc] initWithWhere:1];
        needVc.hidesBottomBarWhenPushed = YES;
        pushToControllerWithAnimated(needVc)
    } else if (key == 4) {//任务 栏色
        self.tabBarController.selectedIndex = 1;
    } else if (key == 5) {//节点  橘红色
        TaskDetailViewController *taskVC = [[TaskDetailViewController alloc] initWithDataId:model.dataId WithType:@"1" WithWhere:1];
        taskVC.hidesBottomBarWhenPushed = YES;
        pushToControllerWithAnimated(taskVC)
    } else if (key == 6) {//保险 默认logo
//        FXInsureTaskListController *vc = [[FXInsureTaskListController alloc] initWith:1];
//        vc.hidesBottomBarWhenPushed = YES;
//        pushToControllerWithAnimated(vc)
    } else if (key == 7) {//商品 绿色
        GoodsListViewController *vc = [[GoodsListViewController alloc] initWith:1];
        pushToControllerWithAnimated(vc)
    } else if (key == 8) {//资讯
        InformationListViewController *vc = [[InformationListViewController alloc] initWith:1];
        pushToControllerWithAnimated(vc)
    } else if (key == 9) {//项目详情 实名认证
        RealNameVc *relVc = [[RealNameVc alloc]init];
relVc.navigationItem.title = @"实名认证";
        relVc.hidesBottomBarWhenPushed = YES;
        pushToControllerWithAnimated(relVc)
    }
}

- (void)readMsg:(NSString *)mid
{
    __weak NotificationMessageViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mid"] = mid;
    params[@"uid"] = model.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.readMsg"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
    }];
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
