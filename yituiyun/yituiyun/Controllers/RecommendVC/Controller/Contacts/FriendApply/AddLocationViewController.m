//
//  AddLocationViewController.m
//  yituiyun
//
//  Created by 张强 on 2017/1/13.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "AddLocationViewController.h"
#import "AddLocationFriendCell.h"
#import "FXPersonDetailController.h"
#import "FXCompanyDetailController.h"
#import "CCLocationManager.h"
#import "AddFriendModel.h"

@interface AddLocationViewController ()<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
{
    CLLocationManager *_manager;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@property (nonatomic, assign) NSInteger where;

@property (nonatomic, assign) CGFloat myLon;
@property (nonatomic, assign) CGFloat myLat;

@property (nonatomic, assign) NSInteger select;

/** 不限按钮 */
@property (nonatomic,strong) UIButton* noLimitBtn;
/** 男按钮 */
@property (nonatomic,strong) UIButton* maleBtn;
/** 女按钮 */
@property (nonatomic,strong) UIButton* femaleBtn;
/** 按钮下滑动的线  */
@property (nonatomic,strong) UIView* BtnlineView;
@end

@implementation AddLocationViewController
- (instancetype)initWithBDOrEnterprise:(NSInteger)where
{
    if (self = [super init]) {
        self.dataSource = [NSMutableArray array];
        self.page = @"1";
        self.isremo = YES;
        self.select = 0;
        self.where = where;
    }
    return self;
}

#pragma mark - 定位
- (void)setupLocation
{
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 100;
#ifdef __IPHONE_8_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_manager requestWhenInUseAuthorization];
        }
#endif
        if ([CLLocationManager locationServicesEnabled]) {
            [_manager startUpdatingLocation];
        } else{
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    } else {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    __weak AddLocationViewController *weakSelf = self;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=1&to=5&ak=pn8B4yEuClbl9Gy84rGSd3oK", newLocation.coordinate.longitude, newLocation.coordinate.latitude];
    [mgr GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"result"];
        NSDictionary *dic = array.firstObject;
        self.myLat = [dic[@"y"] floatValue];
        self.myLon = [dic[@"x"] floatValue];
        [weakSelf getGoodsData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showHint:@"定位失败"];
    }];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
}

-(void)stopLocation
{
    _manager = nil;
}

- (void)getGoodsData
{
    __weak AddLocationViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"pagesize"] = @"10";
//    params[@"page"] = _page;
    params[@"uid"] = model.userID;
    params[@"lat"] = @(self.myLat);
    params[@"lng"] = @(self.myLon);
    if (_select == 0) {
    } else if (_select == 1) {
        params[@"sex"] = @"1";
    } else if (_select == 2) {
        params[@"sex"] = @"2";
    }
    NSString *URL;
    if (_where == 1) {
        URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.nearPerson"];
    } else if (_where == 2) {
        URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.nearCompany"];
    }
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
                    model.desc = [NSString stringWithFormat:@"%@", subDic[@"desired"]];
                    model.industry = [NSString stringWithFormat:@"%@", subDic[@"industry"]];
                    model.distance = [NSString stringWithFormat:@"%@", subDic[@"distance"]];
                    model.uid = [NSString stringWithFormat:@"%@", subDic[@"uid"]];
                    model.sex = [NSString stringWithFormat:@"%@", subDic[@"sex"]];
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
    [self setupLocation];
}

#pragma mark - setupNav
- (void)setupNav{
    if (_where == 1) {
        self.title = @"附近的人";
    } else if (_where == 2) {
        self.title = @"附近的企业";
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBarButtonItem)];
}

- (void)leftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView
{
    if (_where == 1) {
        [self.view addSubview:self.noLimitBtn];
        [self.view addSubview:self.maleBtn];
        [self.view addSubview:self.femaleBtn];
        [self.view addSubview:self.BtnlineView];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height - 64 - 46) style:UITableViewStyleGrouped];
    } else if (_where == 2) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    }
    [_tableView setDelegate:(id<UITableViewDelegate>) self];
    [_tableView setDataSource:(id<UITableViewDataSource>) self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

-(UIView*)BtnlineView{
    if (!_BtnlineView) {
        _BtnlineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.noLimitBtn.frame), CGRectGetMaxY(self.noLimitBtn.frame), self.noLimitBtn.width, 2)];
        _BtnlineView.backgroundColor = kUIColorFromRGB(0xf16156);
    }
    return _BtnlineView;
}

/** 不限  */
- (UIButton*)noLimitBtn{
    if (!_noLimitBtn) {
        _noLimitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noLimitBtn.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, 44);
        _noLimitBtn.backgroundColor = [UIColor whiteColor];
        [_noLimitBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_noLimitBtn setTitle:[NSString stringWithFormat:@"不限"] forState:UIControlStateNormal];
        if (_select == 0) {
            [_noLimitBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_noLimitBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _noLimitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_noLimitBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _noLimitBtn;
}

/** 男  */
-(UIButton*)maleBtn{
    if (!_maleBtn) {
        _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleBtn.frame = CGRectMake(CGRectGetMaxX(self.noLimitBtn.frame), 0, self.view.frame.size.width / 3, 44);
        _maleBtn.backgroundColor = [UIColor whiteColor];
        [_maleBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_maleBtn setTitle:[NSString stringWithFormat:@"男"] forState:UIControlStateNormal];
        if (_select == 1) {
            [_maleBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_maleBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _maleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_maleBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _maleBtn;
}

/** 女  */
-(UIButton*)femaleBtn{
    if (!_femaleBtn) {
        _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleBtn.frame = CGRectMake(CGRectGetMaxX(self.maleBtn.frame), 0, self.view.frame.size.width / 3, 44);
        _femaleBtn.backgroundColor = [UIColor whiteColor];
        [_femaleBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_femaleBtn setTitle:[NSString stringWithFormat:@"女"] forState:UIControlStateNormal];
        if (_select == 2) {
            [_femaleBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(_femaleBtn.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
        }
        _femaleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_femaleBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _femaleBtn;
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

-(void)titleButtonClick:(UIButton*)button{
    self.isremo = YES;
    self.page = @"1";
    
    [UIView animateWithDuration:0.3 animations:^{
        self.BtnlineView.frame = CGRectMake(CGRectGetMaxX(button.frame) - self.BtnlineView.frame.size.width, self.BtnlineView.frame.origin.y, self.BtnlineView.frame.size.width, self.BtnlineView.frame.size.height);
    }];
    [self.noLimitBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [self.maleBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    [self.femaleBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
    
    [button setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    
    if (button == self.noLimitBtn) {
        _select = 0;
    }else if (button == self.maleBtn){
        _select = 1;
    }else if (button == self.femaleBtn){
        _select = 2;
    }
    [self getGoodsData];
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
