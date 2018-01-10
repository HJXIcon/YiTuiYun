//
//  JXPunchClockViewController.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPunchClockViewController.h"
#import "CancelTaskCell.h"
#import "JXLocationTool.h"
#import "JXPunchClockAddressCell.h"
#import "TaskHallEnterpriseDetailJianZhiVC.h"
#import "JXPunchClockListModel.h"
#import "JXPunchClockHeaderView.h"
#import "YYModel.h"
#import "JXRepeatButton.h"

/// 打卡状态
typedef enum : NSUInteger {
    JXPunchClockStatusNotClock,//未打卡
    JXPunchClockStatusClockIn,// 已上班打卡
    JXPunchClockStatusClockOut,//已下班打卡
    JXPunchClockStatusGetPaid,// 已获取工资
} JXPunchClockStatus;

@interface JXPunchClockViewController ()<UITableViewDataSource,UITableViewDelegate>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 地址名称*/
@property (nonatomic, strong) NSString *address;
/** 当前经纬度 */
@property (nonatomic, assign)  CLLocationCoordinate2D location;
/** 打卡按钮*/
@property (nonatomic, strong) JXRepeatButton *punchClockBtn;
/// 打卡状态
@property (nonatomic, assign) JXPunchClockStatus *punchClockStatus;

/** 打卡详情model*/
@property (nonatomic, strong) JXPunchClockDetailModel *clockDetailModel;

/** headerView*/
@property (nonatomic, strong) JXPunchClockHeaderView *clockHeaderView;
@end

@implementation JXPunchClockViewController
#pragma mark - lazy load
- (JXPunchClockHeaderView *)clockHeaderView{
    if (_clockHeaderView == nil) {
        _clockHeaderView = [[JXPunchClockHeaderView alloc]initWithFrame:CGRectMake(0, 0, ZQ_Device_Width, 135)];
    }
    return _clockHeaderView;
}

-(JXRepeatButton *)punchClockBtn{
    if (_punchClockBtn == nil) {
        _punchClockBtn = [[JXRepeatButton alloc]init];
        _punchClockBtn.time = 1.0;
        [_punchClockBtn setTitle:@"上班打卡" forState:UIControlStateNormal];
        _punchClockBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _punchClockBtn.backgroundColor = UIColorFromRGBString(@"f16156");
        [_punchClockBtn addTarget:self action:@selector(punchClockAction) forControlEvents:UIControlEventTouchUpInside];
        _punchClockBtn.frame = CGRectMake(WRadio(10), ScreenHeight - HRadio(54) - 64, ScreenWidth - WRadio(10) * 2, HRadio(44));
        _punchClockBtn.layer.cornerRadius = 3;
        _punchClockBtn.layer.masksToBounds = YES;
        _punchClockBtn.hidden = YES;
    }
    return _punchClockBtn;
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 135, ZQ_Device_Width, ZQ_Device_Height - 64 - 135) style:UITableViewStylePlain];
        [_tableView setDelegate:(id<UITableViewDelegate>) self];
        [_tableView setDataSource:(id<UITableViewDataSource>) self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 50;
        
    }
    return _tableView;
}




#pragma mark - cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.headView];
    [self.view addSubview:self.clockHeaderView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.punchClockBtn];
    
    [self getCurrentAddressName];
    
    /// 上班打卡
    if ([self.node_status isEqualToString:@"-1"]) {
        self.navigationItem.title = @"上班打卡";
        [self changeNodeStatus:JXPunchClockStatusNotClock];
        [self.punchClockBtn setTitle:@"上班打卡" forState:UIControlStateNormal];
        self.punchClockBtn.hidden = NO;
        
    /// 下班打卡
    }else if ([self.node_status isEqualToString:@"0"]){
        self.navigationItem.title = @"下班打卡";
        [self changeNodeStatus:JXPunchClockStatusClockIn];
        [self.punchClockBtn setTitle:@"下班打卡" forState:UIControlStateNormal];
        self.punchClockBtn.hidden = NO;
    }
    
    
    /// 有节点id的时候才请求
    if (![NSString stringIsEmpty:self.node_id]) {
        [self loadNodeDetailData];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Private Method
/// ClockHeaderView赋值时间
- (void)setTimeTextForClockHeaderView{
    
    if (![ZQ_CommonTool isEmpty:self.clockDetailModel.inputtime] && [self.clockDetailModel.inputtime intValue] != 0) {
        self.clockHeaderView.checkInTime = [NSString timeHasMinuteTimeIntervalString:self.clockDetailModel.inputtime];
    }
    
    if (![ZQ_CommonTool isEmpty:self.clockDetailModel.update_time] && [self.clockDetailModel.update_time intValue] != 0) {
        self.clockHeaderView.checkOutTime = [NSString timeHasMinuteTimeIntervalString:self.clockDetailModel.update_time];
    }
    
    if (![ZQ_CommonTool isEmpty:self.clockDetailModel.last_time] && [self.clockDetailModel.last_time intValue] != 0 && [self.clockDetailModel.status intValue] != 4) {
        self.clockHeaderView.getPaidTime = [NSString timeHasMinuteTimeIntervalString:self.clockDetailModel.last_time];
    }
    
}

/// 修改打卡状态
- (void)changeNodeStatus:(JXPunchClockStatus)status{
    self.punchClockStatus = status;
    
    switch (status) {
        case JXPunchClockStatusNotClock:
        {
            
            self.clockHeaderView.step = JXPunchClockHeaderViewStepNotCheck;
            self.navigationItem.title = @"上班打卡";
        }
            break;
            
        case JXPunchClockStatusClockIn:
        {
            
            self.clockHeaderView.step = JXPunchClockHeaderViewStepCheckIn;
            self.navigationItem.title = @"下班打卡";
        }
            break;
            
            
        case JXPunchClockStatusClockOut:
        {
            
            self.clockHeaderView.step = JXPunchClockHeaderViewStepCheckOut;
            self.navigationItem.title = @"打卡详情";
        }
            break;
            
        case JXPunchClockStatusGetPaid:
        {
            
            self.clockHeaderView.step = JXPunchClockHeaderViewStepGetPaid;
            self.navigationItem.title = @"打卡详情";
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark load Data
/// 打卡详情
- (void)loadNodeDetailData{
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"member_id"] = userModel.userID;
    params[@"node_id"] = self.node_id;
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHost,API_NodeDetail];
    MJWeakSelf;
    [XKNetworkManager POSTToUrlString:URLString parameters:params progress:nil success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *resultDict = JSonDictionary;
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *rdict = resultDict[@"rst"];
            
//            weakSelf.clockDetailModel = [JXPunchClockDetailModel objectWithKeyValues:rdict];
            weakSelf.clockDetailModel = [JXPunchClockDetailModel yy_modelWithJSON:rdict];
            
            /// 赋值时间
            [weakSelf setTimeTextForClockHeaderView];
            
            [weakSelf.tableView reloadData];
            
            // 0:待打下班卡,3:审核中，2:已失效，4:审核失败，1:审核完成
            if ([weakSelf.clockDetailModel.status intValue] == 0) {
                [weakSelf changeNodeStatus:JXPunchClockStatusClockIn];
                weakSelf.punchClockBtn.hidden = NO;
                
            }else if ([weakSelf.clockDetailModel.status intValue] == 3) {
                [weakSelf changeNodeStatus:JXPunchClockStatusClockOut];
                weakSelf.punchClockBtn.hidden = YES;
                
            }else if([weakSelf.clockDetailModel.status intValue] == 2) {
                weakSelf.punchClockBtn.hidden = YES;
                
                if (![ZQ_CommonTool isEmpty:weakSelf.clockDetailModel.address]) {
                    [weakSelf changeNodeStatus:JXPunchClockStatusClockIn];
                    
                }else if(![ZQ_CommonTool isEmpty:weakSelf.clockDetailModel.end_address]){
                    [weakSelf changeNodeStatus:JXPunchClockStatusClockOut];
                }else{
                     [weakSelf changeNodeStatus:JXPunchClockStatusNotClock];
                }
                weakSelf.clockHeaderView.desLabel.text = @"已失效！";
                
                
            }else if([weakSelf.clockDetailModel.status intValue] == 1) {
                [weakSelf changeNodeStatus:JXPunchClockStatusGetPaid];
                weakSelf.punchClockBtn.hidden = YES;
                
                
            }else if([weakSelf.clockDetailModel.status intValue] == 4) {
                [weakSelf changeNodeStatus:JXPunchClockStatusClockOut];
                weakSelf.punchClockBtn.hidden = YES;
                weakSelf.clockHeaderView.desLabel.text = @"审核不通过！";
            }
            
        }else{
            //失败
            [weakSelf showHint:resultDict[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
    
}
/// 获取当前地址名称
- (void)getCurrentAddressName{
    MJWeakSelf
    [[JXLocationTool shareInstance] getCurrentAddress:^(NSString *address,CLLocationCoordinate2D location) {
        weakSelf.address = address;
        weakSelf.location = location;
        [weakSelf.tableView reloadData];
        
    } error:^(BMKSearchErrorCode error) {
        
        weakSelf.address = @"定位失败，请重试";
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Actions
- (void)punchClockAction{
    
    if (self.punchClockStatus == JXPunchClockStatusNotClock) {
        [self clickIn];
    }else if(self.punchClockStatus == JXPunchClockStatusClockIn){
        [self clickOut];
    }
    
    
}

/// 下班打卡
- (void)clickOut{
    
    if ([ZQ_CommonTool isEmpty:self.address] || self.location.longitude == 0 || self.location.latitude == 0) {
        [self showHint:@"点击重新定位按钮"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"member_id"] = model.userID;
    parm[@"node_id"] = self.node_id;
    parm[@"address"] = self.address;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, API_EndWork];
    [XKNetworkManager POSTToUrlString:URL parameters:parm progress:^(CGFloat progress) {
        
        
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dict[@"errno"] integerValue] ==0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHint:@"打卡成功"];
                [weakSelf changeNodeStatus:JXPunchClockStatusClockOut];
                if (weakSelf.punchClockSuccessBlock) {
                    weakSelf.punchClockSuccessBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
            
            
        }else{
            
            //失败
            [weakSelf showHint:dict[@"errmsg"]];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
    
}

/// 上班打卡
- (void)clickIn{
    if ([ZQ_CommonTool isEmpty:self.address] || self.location.longitude == 0 || self.location.latitude == 0) {
        [self showHint:@"点击重新定位按钮"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    MJWeakSelf
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    parm[@"uid"] = model.userID;
    parm[@"job_id"] = self.job_id;
    parm[@"type"] = @1;// 0:任务，1:兼职
    parm[@"address"] = self.address;
    parm[@"lat"] = @(self.location.latitude);
    parm[@"lng"] = @(self.location.longitude);
    
    
    [XKNetworkManager POSTToUrlString:TaskQianDao parameters:parm progress:^(CGFloat progress) {
        
        
        
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dict[@"errno"] integerValue] ==0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHint:@"打卡成功"];
                [weakSelf changeNodeStatus:JXPunchClockStatusClockIn];
                if (weakSelf.punchClockSuccessBlock) {
                    weakSelf.punchClockSuccessBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
            //失败
            [weakSelf showHint:dict[@"errmsg"]];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([NSString stringIsEmpty:self.clockDetailModel.address]) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf
    
     JXPunchClockAddressCell *cell = [JXPunchClockAddressCell cellForTableView:tableView];
    //reloadAddress回调
    cell.reloadAddressBlock = ^() {
        [weakSelf getCurrentAddressName];
    } ;
    
    if ([NSString stringIsEmpty:self.clockDetailModel.address]) {
        
        cell.nameLabel.text = @"上班地点:";
        cell.addressLabel.text = self.address;
        cell.refreshButton.hidden = NO;
        cell.addressLabel.hidden = NO;
        
    }else{
        
        // 待打下班卡
        if ([self.clockDetailModel.status intValue] == 0) {
            if (indexPath.row == 0) {
                cell.nameLabel.text = @"上班地点:";
                cell.addressLabel.text = self.clockDetailModel.address;
                cell.refreshButton.hidden = YES;
                cell.addressLabel.hidden = NO;
                
            }else if(indexPath.row == 1){
                cell.nameLabel.text = @"下班地点:";
                cell.addressLabel.text = self.address;
                cell.refreshButton.hidden = [self.clockDetailModel.status intValue] == 0 ? NO : YES;
                cell.addressLabel.hidden = NO;
            }
            
        }else{// 待审核，失效，审核中
            
            if (indexPath.row == 0) {
                cell.nameLabel.text = @"上班地点:";
                cell.addressNotRefrshLabel.text = self.clockDetailModel.address;
                cell.addressLabel.hidden = YES;
                cell.refreshButton.hidden = YES;
                
            }else if(indexPath.row == 1){
                cell.nameLabel.text = @"下班地点:";
                cell.addressNotRefrshLabel.text = self.clockDetailModel.end_address;
                cell.addressLabel.hidden = YES;
                cell.refreshButton.hidden = YES;
            }
        }
        
        
        
        
        
    }
    
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


@end
