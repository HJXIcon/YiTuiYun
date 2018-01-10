//
//  FXMoneyListController.m
//  yituiyun
//
//  Created by fx on 16/10/18.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXMoneyListController.h"
#import "FXMoneyListModel.h"
#import "FXMoneyListCell.h"
#import "MoneyDetailsViewController.h"

@interface FXMoneyListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@end

@implementation FXMoneyListController

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray new];
        self.isremo = YES;
        self.page = @"1";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"明细";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    [self setUpTableView];
    [self setupRefresh];
    [self getListData];
}

- (void)leftBarButtonItem{
    
    [MobClick event:@"qiyexuqiufanhui"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self getListData];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    [self getListData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXMoneyListCell *cell = [FXMoneyListCell moneyListCellWithTableView:tableView];
    FXMoneyListModel *listModel = _dataArray[indexPath.section];
    cell.listModel = listModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FXMoneyListModel *listModel = _dataArray[indexPath.section];
    MoneyDetailsViewController *vc = [[MoneyDetailsViewController alloc] initWithDataId:listModel.itemId];
    pushToControllerWithAnimated(vc)
}

- (void)getListData{
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=my.getAmountDetail"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = userModel.userID;
    dic[@"page"] = _page;
    dic[@"pagesize"] = @"15";
    [weakSelf showHudInView:weakSelf.view hint:@"加载中..."];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"]isEqualToString:@"0"]) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *temDic in listData) {
                    FXMoneyListModel *model = [[FXMoneyListModel alloc]init];
                    model.itemTitle = temDic[@"intro"];
                    model.time = [NSString getDateFromTimeStamp:temDic[@"inputtime"]];
                    model.num = temDic[@"num"];
                    model.type = [NSString stringWithFormat:@"%@", temDic[@"type"]];
                    model.itemId = [NSString stringWithFormat:@"%@", temDic[@"adid"]];
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
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
        _thereLabel.text = @"暂无更多明细";
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
