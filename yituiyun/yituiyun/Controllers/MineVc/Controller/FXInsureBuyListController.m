//
//  FXInsureBuyListController.m
//  yituiyun
//
//  Created by fx on 16/12/2.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXInsureBuyListController.h"
#import "FXInsureListModel.h"
#import "FXInsureListCell.h"
#import "ShowImageViewController.h"

@interface FXInsureBuyListController ()<UITableViewDelegate,UITableViewDataSource,FXInsureListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;


@end

@implementation FXInsureBuyListController

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
    self.title = @"已购保险明细";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];

    [self.view addSubview:self.tableView];
    [self setupRefresh];
    [self getListData];

}
- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXInsureListModel *model = _dataArray[indexPath.section];
    if (model.imgUrlArray.count > 0) {
        return 295;
    }else{
        return 235;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXInsureListCell *cell = [FXInsureListCell cellWithTableView:tableView];
    FXInsureListModel *listModel = _dataArray[indexPath.section];
    cell.indexPath = indexPath;
    cell.insureModel = listModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)imageClickWithIndex:(NSInteger)tag WithIndexPath:(NSIndexPath *)indexPath{
    FXInsureListModel *listModel = _dataArray[indexPath.section];
    NSMutableArray *imgArray = [NSMutableArray new];
    for (NSDictionary *dic in listModel.imgUrlArray) {
        [imgArray addObject:dic[@"url"]];
    }
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:imgArray];
    vc.delegate = self;
    vc.indexPath = indexPath;
    [vc seleImageLocation:tag];
    pushToControllerWithAnimated(vc)
}
- (void)getListData{
    
    __block typeof(self) weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=get.getInsurance"];
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
                    FXInsureListModel *model = [[FXInsureListModel alloc]init];
                    model.startTime = temDic[@"startDate"];
                    model.endTime = temDic[@"endDate"];
                    model.buyTime = [NSString getDateFromTimeStamp:temDic[@"payTime"]];
                    model.imgUrlArray = temDic[@"payImg"];
                    model.insureType = temDic[@"type"];
                    model.taskName = temDic[@"projectName"];
                    model.price = temDic[@"price"];
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
        _thereLabel.text = @"暂无更多明细记录";
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
