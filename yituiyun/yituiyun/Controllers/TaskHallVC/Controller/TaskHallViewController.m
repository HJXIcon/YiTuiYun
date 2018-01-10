//
//  TaskHallViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/10.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "TaskHallViewController.h"
#import "TaskDetailViewController.h"
#import "ProjectModel.h"
#import "TaskHallCell.h"
#import "CancelTaskViewController.h"
#import "TaskHallPersonHeadSelectView.h"
#import "LHKTaskHallCell.h"
#import "TaskHallModel.h"
#import "PersonAllJianZhiVC.h"

@interface TaskHallViewController ()<TaskHallCellDelegate,TaskHallPersonHeadSelectViewDelegate,UITableViewDelegate,UITableViewDataSource>
/** 按钮下滑动的线  */
@property (nonatomic,strong) UIView* BtnlineView;

/**选择头部空间 */
@property(nonatomic,strong) TaskHallPersonHeadSelectView * selectHeadView;

/** 数据源  */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 主视图 */
@property (nonatomic,strong) UITableView* tableView;

/** 未执行按钮 */
@property (nonatomic,strong) UIButton* receiveBtn;
/** 执行中按钮 */
@property (nonatomic,strong) UIButton* implementBtn;
/** 已完成按钮 */
@property (nonatomic,strong) UIButton* completeBtn;
/** 已取消按钮 */
@property (nonatomic,strong) UIButton* cancelBtn;

@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, assign) NSInteger select;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
/**type */
@property(nonatomic,assign) NSInteger  type;
/**page */
@property(nonatomic,assign) NSInteger  page;
@property(nonatomic,strong) UIImageView * nodataImageView;
@end

@implementation TaskHallViewController

-(UIImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        _nodataImageView = [[UIImageView alloc]init];
        _nodataImageView.image = [UIImage imageNamed:@"NodataTishi"];
    }
    return _nodataImageView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.isremo = YES;
    self.page = @"1";
    
    if (self.tableView !=nil) {
        [self.tableView.mj_header beginRefreshing];
    }
 
}



-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.nodataImageView];
    
    //添加站位图片
    
    [self.nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(WRadio(55)));
        make.height.mas_equalTo(@(HRadio(65)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(HRadio(90));

    }];

    self.view.backgroundColor = UIColorFromRGB(0xededed);
    
    [self setupNav];

    [self.view addSubview:self.selectHeadView];
    
    
    [self setUpTableView];
    [MobClick event:@"clickTaskNums"];
    
    self.type =1;
    //进入开始刷新
    [self.tableView.mj_header beginRefreshing];
    
    
    //右上角的我的全职
    NSString *title = @"我的全职";
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:FontRadio(15)] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [btn setTitle:@"我的全职" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FontRadio(15)];
    [btn addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

-(void)rightbtnClick{
    PersonAllJianZhiVC *vc = [[PersonAllJianZhiVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - setupNav
- (void)setupNav{
    self.title = @"任务大厅";
}

#pragma mark-- TaskHallPersonHeadSelectView 懒加载和代理

-(TaskHallPersonHeadSelectView *)selectHeadView{
    if (_selectHeadView == nil) {
        _selectHeadView = [TaskHallPersonHeadSelectView headSelectView];
        _selectHeadView.frame = CGRectMake(0, 0, ScreenWidth, WRadio(44));
        _selectHeadView.delegate = self;
        _selectHeadView.taskBtn.selected = YES;
    
    }
    return _selectHeadView;
}

-(void)mytaskBtnToClick:(UIButton *)btn{
    self.type = 1;
    self.page =1;
   
    [self.tableView.mj_header beginRefreshing];
}

-(void)myhistorytaskBtnToClick:(UIButton *)btn{
    
    self.type = 0;
    self.page = 1;
    
    [self.tableView.mj_header beginRefreshing];

}


- (void)getMyTaskHall
{
    MJWeakSelf
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(10);
    params[@"type"]=@(self.type);
    
    [XKNetworkManager GETDataFromUrlString:TaskHallGetTasks parameters:params progress:^(CGFloat progress) {
        
    
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView.mj_header endRefreshing];
        
        if ([resultDict[@"errno"] integerValue] == 0) {
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [TaskHallModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [TaskHallModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
 
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [TaskHallModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];

                    [weakSelf.tableView.mj_footer resetNoMoreData];
 
                }

            }else{
                //上拉的时候
                
                NSArray *tempArray = [TaskHallModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
               
                 [weakSelf.dataArray addObjectsFromArray:tempArray];

                    
                 }
                
                
            }
                               [weakSelf.tableView reloadData]; 
        }

        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

        self.page --;
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskHallModel *model = self.dataArray[indexPath.section];
    TaskDetailViewController *detailVc = [[TaskDetailViewController alloc]initWithDataId:model.demandid WithType:model.status WithWhere:1];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.demand_status = model.demand_status;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(void)setUpTableView{
    //初始化 tableview
    MJWeakSelf
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HRadio(44), self.view.frame.size.width, self.view.frame.size.height - 64 - HRadio(44) - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"LHKTaskHallCell" bundle:nil] forCellReuseIdentifier:@"TaskHallCell"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page =1;
        [weakSelf getMyTaskHall];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [weakSelf getMyTaskHall];
    }];
    
    [self.view addSubview:_tableView];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    
    if (self.dataArray.count == 0) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"TaskHallCell";
    LHKTaskHallCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.dataArray[indexPath.section];
//    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.twoBtnPanView.hidden = YES;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (ScreenWidth<375) {
            return HRadio(10);
        }
        return 10;
    }
    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (ScreenWidth<375) {
        return HRadio(90);
    }
    return 90;
}


- (void)startButtonClickWithIndex:(NSIndexPath *)indexPath WithState:(NSString *)state
{
    ProjectModel *model = _dataArray[indexPath.section];
    if ([model.taskType integerValue] == 2) {
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"亲爱的，您需要到任务详情中签到后才能开始愉快的工作！"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [self startWithIndex:indexPath WithState:state];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    } else {
        if ([model.doingDemandid integerValue] > 0) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"同一时段仅可执行一项任务，您需要取消正在执行的任务。若取消正在执行的任务，想要再次领取任务需要等待24小时，确认开始新任务？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     CancelTaskViewController *vc = [[CancelTaskViewController alloc] initWithDataId:model.doingDemandid WithTaskName:model.doingName With:1];
                     pushToControllerWithAnimated(vc)
                 }
             } cancelButtonTitle:@"继续任务" otherButtonTitles:@"新任务", nil];
        } else {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"亲爱的，您需要到任务详情中签到后才能开始愉快的工作！"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [self startWithIndex:indexPath WithState:state];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
    }
}

- (void)startWithIndex:(NSIndexPath *)indexPath WithState:(NSString *)state
{
    ProjectModel *model = _dataArray[indexPath.section];
    __weak TaskHallViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"加载中..."];
    UserInfoModel *infoModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demandid"] = model.projectId;
    params[@"memberid"] = infoModel.userID;
    params[@"status"] = @"1";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.taskStatus"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] intValue] == 0) {
            [MobClick event:@"startTaskNums"];

            weakSelf.isremo = YES;
            weakSelf.page = @"1";
            weakSelf.select = 1;
            
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.BtnlineView.frame = CGRectMake(CGRectGetMaxX(weakSelf.implementBtn.frame) - weakSelf.BtnlineView.frame.size.width, weakSelf.BtnlineView.frame.origin.y, weakSelf.BtnlineView.frame.size.width, weakSelf.BtnlineView.frame.size.height);
            }];
            [weakSelf.receiveBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
            [weakSelf.implementBtn setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
            [weakSelf.completeBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
            [weakSelf.cancelBtn setTitleColor:kUIColorFromRGB(0x808080) forState:UIControlStateNormal];
            
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"加载失败，请检查网络"];
    }];
}

- (void)cancelButtonClickWithIndex:(NSIndexPath *)indexPath
{
    [WCAlertView showAlertWithTitle:@"提示"
                            message:@"若取消此任务，想要再次领取此任务需要等待24小时，确认取消任务？"
                 customizationBlock:^(WCAlertView *alertView) {
                     
                 } completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             ProjectModel *model = _dataArray[indexPath.section];
             CancelTaskViewController *vc = [[CancelTaskViewController alloc] initWithDataId:model.projectId WithTaskName:model.projectName With:1];
             pushToControllerWithAnimated(vc)
         }
     } cancelButtonTitle:@"继续任务" otherButtonTitles:@"取消任务", nil];
}

-(void)restartTaskWith:(NSString *)pid wihtT_demanType:(NSString *)t{
    
    MJWeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"t"] = @"1";
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    dict[@"memberid"] = model.userID;
    dict[@"demandid"] = pid;
    dict[@"demandType"] = t;
    
    [SVProgressHUD showWithStatus:@"正在重新开始任务"];
    [XKNetworkManager POSTToUrlString:ProjectRestartTaskURL parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        [SVProgressHUD dismiss];

        [weakSelf.dataArray removeAllObjects];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];

    }];
    
}
@end
