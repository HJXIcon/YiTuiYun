//
//  MyLogViewController.m
//  yituiyun
//
//  Created by 张强 on 2016/12/3.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "MyLogViewController.h"
#import "InformationModel.h"
#import "MyLogCell.h"
#import "TodaySummaryViewController.h"
#import "HFPickerView.h"

@interface MyLogViewController ()<UITableViewDataSource,UITableViewDelegate,HFPickerViewDelegate,MyLogCellDelegate,UIActionSheetDelegate,TodaySummaryViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MyLogCell *logCell;

@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;

@property (nonatomic, strong) UIImageView *screenView;
@property (nonatomic, strong) UIButton *starttimeBut;
@property (nonatomic, strong) UIButton *endtimeBut;

@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;

@property (nonatomic, strong) HFPickerView *timePickView;
@property (nonatomic, strong) NSIndexPath *currentLongPressIndex;
@property (nonatomic, assign) NSInteger where;
@end

@implementation MyLogViewController

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
    [self setupScreenView];
    [self dataArrayFromNetworkWithStarttime:_starttime WithEndtime:_endtime];
}

#pragma mark 请求网络数据
- (void)dataArrayFromNetworkWithStarttime:(NSString *)starttime WithEndtime:(NSString *)endtime {
    [self showHudInView:self.view hint:@"加载中..."];
    __weak MyLogViewController *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @"10";
    params[@"page"] = _page;
    params[@"uid"] = model.userID;
    if (![ZQ_CommonTool isEmpty:starttime]) {
        params[@"starttime"] = starttime;
    }
    if (![ZQ_CommonTool isEmpty:endtime]) {
        params[@"endtime"] = endtime;
    }
    if (_where == 1) {
        params[@"type"] = @"1";
    } else if (_where == 2) {
        params[@"type"] = @"2";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.summarize"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            NSArray *listData = [responseObject objectForKey:@"rst"];
            NSMutableArray *listDataArray = [NSMutableArray array];
            if (![ZQ_CommonTool isEmptyArray:listData]) {
                for (NSDictionary *subDic in listData) {
                    InformationModel *model = [[InformationModel alloc] init];
                   
                    model.icon = [NSString stringWithFormat:@"%@%@", kHost, subDic[@"thumb"]];
                    model.title = [NSString stringWithFormat:@"%@", [subDic[@"title"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    model.desc = [NSString stringWithFormat:@"%@", subDic[@"content"]];
                    model.time = [NSString stringWithFormat:@"%@", subDic[@"inputtime"]];
                    model.InfoId = [NSString stringWithFormat:@"%@", subDic[@"summarizeid"]];
                    model.field = [NSString stringWithFormat:@"%@", subDic[@"turnup"]];
//                    model.field = @"1";
                    model.jobDuration = [NSString stringWithFormat:@"%@", subDic[@"jobDuration"]];
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
        _thereLabel.text = @"没有更多日志";
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
    if (_where == 1) {
        self.title = @"我的日志";
    } else if (_where == 2) {
        self.title = @"职工打卡";
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"timeScreen" selectedImage:@"timeScreen" target:self action:@selector(rightBarButtonItemClick)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClick
{
    if (_screenView.hidden == YES) {
        _screenView.hidden = NO;
    } else {
        _screenView.hidden = YES;
    }
}

- (void)setupScreenView
{
    self.screenView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, ZQ_Device_Height)];
    _screenView.image = [UIImage imageNamed:@"translucentTranslucent"];
    _screenView.hidden = YES;
    _screenView.userInteractionEnabled = YES;
    [self.view addSubview:_screenView];
    
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 0, ZQ_Device_Width, 150)];
    view.backgroundColor = [UIColor whiteColor];
    [_screenView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ZQ_Device_Width - 24, 30)];
    label.text = @"时间筛选";
    label.textColor = kUIColorFromRGB(0x404040);
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    self.starttimeBut = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label.frame) + 10, ZQ_Device_Width/2 - 80, 40)];
    _starttimeBut.backgroundColor = kUIColorFromRGB(0xffffff);
    _starttimeBut.layer.cornerRadius = 3;
    _starttimeBut.layer.borderWidth = 1;
    _starttimeBut.tag = 10001;
    [_starttimeBut setTitle:locationString forState:UIControlStateNormal];
    _starttimeBut.layer.borderColor = kUIColorFromRGB(0xcccccc).CGColor;
    _starttimeBut.titleLabel.font = [UIFont systemFontOfSize:16];
    [_starttimeBut addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_starttimeBut setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    [view addSubview:_starttimeBut];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/2 - 16, CGRectGetMidY(_starttimeBut.frame), 32, 1)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [view addSubview:lineView1];
    
    self.endtimeBut = [[UIButton alloc] initWithFrame:CGRectMake(ZQ_Device_Width/2 + 40, CGRectGetMaxY(label.frame) + 10, ZQ_Device_Width/2 - 80, 40)];
    _endtimeBut.backgroundColor = kUIColorFromRGB(0xffffff);
    _endtimeBut.layer.cornerRadius = 3;
    _endtimeBut.layer.borderWidth = 1;
    _endtimeBut.tag = 10002;
    [_endtimeBut setTitle:locationString forState:UIControlStateNormal];
    _endtimeBut.layer.borderColor = kUIColorFromRGB(0xcccccc).CGColor;
    _endtimeBut.titleLabel.font = [UIFont systemFontOfSize:16];
    [_endtimeBut addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_endtimeBut setTitleColor:kUIColorFromRGB(0x404040) forState:UIControlStateNormal];
    [view addSubview:_endtimeBut];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, CGRectGetMaxY(_starttimeBut.frame) + 15, ZQ_Device_Width, 1)];
    lineView2.backgroundColor = kUIColorFromRGB(0xcccccc);
    [view addSubview:lineView2];
    
    UIButton *screenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    screenButton.frame = CGRectMake(ZQ_Device_Width - 80, CGRectGetMaxY(lineView2.frame) + 10, 70, 35);
    screenButton.tag = 10003;
    [screenButton setTitle:@"筛选" forState:UIControlStateNormal];
    [screenButton setTintColor:kUIColorFromRGB(0xffffff)];
    screenButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [[screenButton layer] setCornerRadius:4];
    [[screenButton layer] setMasksToBounds:YES];
    screenButton.backgroundColor = kUIColorFromRGB(0xf16156);
    [screenButton addTarget:self action:@selector(screenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:screenButton];
    
//    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    resetButton.frame = CGRectMake(ZQ_Device_Width - 160, CGRectGetMaxY(lineView2.frame) + 10, 70, 35);
//    resetButton.tag = 10004;
//    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
//    [resetButton setTintColor:kUIColorFromRGB(0xffffff)];
//    resetButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    [[resetButton layer] setCornerRadius:4];
//    [[resetButton layer] setMasksToBounds:YES];
//    resetButton.backgroundColor = kUIColorFromRGB(0xf16156);
//    [resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:resetButton];
    
    self.timePickView = [[HFPickerView alloc] initWithPickerMode:UIDatePickerModeDate];
    _timePickView.delegate = self;
    
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
    Button.frame = CGRectMake(ZQ_Device_Width - 90, ZQ_Device_Height - 180, 60, 60);
    [Button setBackgroundImage:[UIImage imageNamed:@"writeLog"] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(writeLogButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [Button setTitleColor:kUIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.view addSubview:Button];
}

- (void)buttonClick:(UIButton *)button{

    _timePickView.tag = button.tag + 10000;
    [_timePickView showSelf];
}

#pragma mark 生日时间选择后对时间格式处理
-(void)finishSelectWithPickerView:(HFPickerView*)pickerView withDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    if (pickerView.tag == 10000 + 10001) {
        [self.starttimeBut setTitle:confromTimespStr forState:UIControlStateNormal];
    } else if (pickerView.tag == 10000 + 10002) {
        [self.endtimeBut setTitle:confromTimespStr forState:UIControlStateNormal];
    }
}

- (void)screenButtonClick
{
    self.starttime = self.starttimeBut.titleLabel.text;
    self.endtime = self.endtimeBut.titleLabel.text;
    self.isremo = YES;
    self.page = @"1";
    [self dataArrayFromNetworkWithStarttime:_starttime WithEndtime:_endtime];
    _screenView.hidden = YES;
}

- (void)resetButtonClick
{
    [self.starttimeBut setTitle:@"" forState:UIControlStateNormal];
    self.starttimeBut.titleLabel.text = nil;
    [self.endtimeBut setTitle:@"" forState:UIControlStateNormal];
    self.endtimeBut.titleLabel.text = nil;
}

- (void)writeLogButtonClick
{
    TodaySummaryViewController *vc = nil;
    if (_where == 1) {
        vc = [[TodaySummaryViewController alloc] initWithInformationModel:nil WithWhere:1];
    } else if (_where == 2) {
        vc = [[TodaySummaryViewController alloc] initWithInformationModel:nil WithWhere:3];
    }
    vc.delegate = self;
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
    [self dataArrayFromNetworkWithStarttime:_starttime WithEndtime:_endtime];
}

#pragma mark 上拉加载
- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [_tableView endRefreshing];
    [self dataArrayFromNetworkWithStarttime:_starttime WithEndtime:_endtime];
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
    return _logCell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyLogCell *cell = [MyLogCell cellWithTableView:tableView];
    _logCell = cell;
    cell.delegate = self;
    cell.indexPath = indexPath;
    InformationModel *model = _dataArray[indexPath.section];
    cell.infoModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InformationModel *model = _dataArray[indexPath.section];
    TodaySummaryViewController *vc;
    if (_where == 1) {
        vc = [[TodaySummaryViewController alloc] initWithInformationModel:model WithWhere:2];
    } else if (_where == 2) {
        vc = [[TodaySummaryViewController alloc] initWithInformationModel:model WithWhere:4];
    }
    pushToControllerWithAnimated(vc)
}

- (void)longPressCellWithIndexPath:(NSIndexPath *)indexPath
{
    _currentLongPressIndex = indexPath;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex || _currentLongPressIndex == nil) {
        return;
    }
    
    NSIndexPath *indexPath = _currentLongPressIndex;
    InformationModel *model = _dataArray[indexPath.section];
    _currentLongPressIndex = nil;
    
    [self showHudInView:self.view hint:@"加载中..."];
    __weak MyLogViewController *weakSelf = self;
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"summarizeid"] = model.InfoId;
    params[@"uid"] = userModel.userID;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.delSummarize"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [_tableView beginUpdates];
            [_dataArray removeObject:model];
            [_tableView  deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)refreshData
{
    self.isremo = YES;
    self.page = @"1";
    [self dataArrayFromNetworkWithStarttime:_starttime WithEndtime:_endtime];
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
