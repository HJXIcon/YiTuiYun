//
//  TaskHallEnterpriseDetailJianZhiVC.m
//  yituiyun
//
//  Created by yituiyun on 2017/8/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "TaskHallEnterpriseDetailJianZhiVC.h"
#import "JianZhiDetailFirstCell.h"
#import "JianZhiDetailSecondCell.h"
#import "JianZhiDetailThreeCell.h"
#import "JianZhiDetailFourCell.h"
#import "TaskHallEnterpriseDetailFootView.h"
#import "TaskDetailNavView.h"
#import "JXPunchClockViewController.h"
#import "JXPunchClockListViewController.h"

@interface TaskHallEnterpriseDetailJianZhiVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
/**navTitleView */
@property(nonatomic,strong) TaskDetailNavView * navView;
@property(nonatomic,strong) TaskHallEnterpriseDetailFootView * panView;
@property(nonatomic,strong) JianZhiDetailThreeCell * tempCell;
/** 打卡列表*/
@property (nonatomic, strong) JXPunchClockListViewController *listViewController;
@end

@implementation TaskHallEnterpriseDetailJianZhiVC

#pragma mark - lazy load
- (JXPunchClockListViewController *)listViewController{
    if (_listViewController == nil) {
        
        _listViewController = [[JXPunchClockListViewController alloc]init];
        _listViewController.view.frame = self.view.bounds;
        _listViewController.job_id = self.detailModel.jobid;
    }
    return _listViewController;
}
-(TaskDetailNavView *)navView{
    if (_navView == nil) {
        MJWeakSelf
        _navView = [TaskDetailNavView navView];
        _navView.frame = CGRectMake(0, 0, 189, 44);
        [_navView.oneBtn setTitle:@"招聘详情" forState:UIControlStateNormal];
        [_navView.twoBtn setTitle:@"打卡列表" forState:UIControlStateNormal];
        [_navView.oneBtn setTitle:@"招聘详情" forState:UIControlStateSelected];
        [_navView.twoBtn setTitle:@"打卡列表" forState:UIControlStateSelected];
        
        _navView.nav_block = ^(NSInteger index) {
            
            /***************处理segemetn选项卡*/
            if (index == 0) { // 招聘详情
                [weakSelf.listViewController removeFromParentViewController];
                [weakSelf.listViewController.view removeFromSuperview];
//                weakSelf.listViewController.view.hidden = YES;
                [weakSelf loadJobDetail];
                
                
            }else{// 打卡列表
//                weakSelf.listViewController.view.hidden = NO;
                [weakSelf addChildViewController:weakSelf.listViewController
                 ];
                [weakSelf.view addSubview:weakSelf.listViewController.view];
                [weakSelf.listViewController reloadNodeListDataArray];
                
            }
            /*******************************/
            
        };
    }
    return _navView;
}

-(TaskHallEnterpriseDetailFootView *)panView{
    MJWeakSelf
    if (_panView == nil) {
        _panView = [TaskHallEnterpriseDetailFootView footView];
        _panView.frame = CGRectMake(0, ScreenHeight-64-44, ScreenWidth, 44);
        _panView.shoucangblock = ^(UIButton *btn) {
            if ([btn.titleLabel.text isEqualToString:@"收藏"]) {
                
                //
                
                [weakSelf shoucangWithJobID:weakSelf.detailModel.jobid andStatus:1];
            }else{
                
                //
                [weakSelf shoucangWithJobID:weakSelf.detailModel.jobid andStatus:0];
            }
        
        };
        
        //报名
        _panView.baomingblock = ^(UIButton *btn) {
            
            /// 打卡
            if([self.detailModel.apply_status isEqualToString:@"3"]){
                
                JXPunchClockViewController *vc = [[JXPunchClockViewController alloc]init];
                vc.node_status = weakSelf.detailModel.node_status;
                vc.node_id = weakSelf.detailModel.node_id;
                vc.job_id = weakSelf.detailModel.jobid;
                vc.punchClockSuccessBlock = ^{
                    
                    /// 刷新数据
                    [weakSelf loadJobDetail];
           
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                
                LHKAlterView  *alter  = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"正规的兼职不会收取费用,如需收费,请提高警惕" WithCancelBlock:^(LHKAlterView *alterView) {
                    
                    [alterView removeFromSuperview];
                    
                } WithMakeSure:^(LHKAlterView *alterView) {
                    [weakSelf baomingWithJobID:weakSelf.detailModel.jobid];
                    [alterView removeFromSuperview];
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:alter];
            }
            
           
          
        };
    }
    return _panView;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        
        UserInfoModel *model = [ZQ_AppCache userInfoVo];
        
        if ([model.identity isEqualToString:@"5"]) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108) style:UITableViewStylePlain];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiDetailFirstCell" bundle:nil] forCellReuseIdentifier:@"JianZhiDetailFirstCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiDetailSecondCell" bundle:nil] forCellReuseIdentifier:@"JianZhiDetailSecondCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiDetailThreeCell" bundle:nil] forCellReuseIdentifier:@"JianZhiDetailThreeCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JianZhiDetailFourCell" bundle:nil] forCellReuseIdentifier:@"JianZhiDetailFourCell"];
        _tableView.estimatedRowHeight = 50;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColorFromRGBString(@"0xededed");
    }
    return _tableView;
}

#pragma mark - cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.detailModel.apply_status isEqualToString:@"3"]) {
        self.navigationItem.titleView = self.navView;
    }else{
        self.navigationItem.title = @"招聘详情";
    }
    
    
    self.view.backgroundColor = UIColorFromRGBString(@"0xededed");
    
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    if ([model.identity isEqualToString:@"6"]) {
        [self.view addSubview:self.panView];
        /// 处理底部button
        [self dealFooterButton];
    }
    
    
    [self.view addSubview:self.tableView];
    
//    [self addChildViewController:self.listViewController];
//    [self.view addSubview:self.listViewController.view];
//    self.listViewController.view.hidden = YES;
    
}


#pragma mark - Private Method
#pragma mark <处理底部button>
- (void)dealFooterButton{
    /// 未报名
    if ([self.detailModel.apply_status isEqualToString:@"0"]) {
        
        /// 被录取 -->> 打卡
    }else if([self.detailModel.apply_status isEqualToString:@"3"]){
        
        NSString *title = [self.detailModel.node_status isEqualToString:@"-1"] ? @"上班打卡" : @"下班打卡";
        
        [self.panView.baomingBtn setTitle:title forState:UIControlStateNormal];
        
    }else{
        
        self.panView.baomingBtn.userInteractionEnabled = NO;
        [self.panView.baomingBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.panView.baomingBtn setTitle:[NSString baomingStausWith:[self.detailModel.apply_status integerValue]] forState:UIControlStateNormal];
        
    }
    
    //收藏
    if ([self.detailModel.isCollect isEqualToString:@"1"]) {
        [self.panView.shoucangBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.panView.shoucangBtn setImage:[UIImage imageNamed:@"collectionYes"] forState:UIControlStateNormal];
    }else{
        [self.panView.shoucangBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.panView.shoucangBtn setImage:[UIImage imageNamed:@"collectionNo"] forState:UIControlStateNormal];
    }
}
#pragma mark <加载招聘详情>
- (void)loadJobDetail{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userinfo.userID;
    parm[@"jobid"] = self.detailModel.jobid;
    [XKNetworkManager POSTToUrlString:JianZhiCompanyListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resut = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resut[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            JianZhiModelDetail *model = [JianZhiModelDetail objectWithKeyValues:resut[@"rst"]];
            weakSelf.detailModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf dealFooterButton];
            });
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];
    
}


-(void)shoucangWithJobID:(NSString *)jobid andStatus:(NSInteger)status{
  MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    parm[@"uid"] = usermodel.userID;
    parm[@"status"] = @(status);
    parm[@"type"] = @(4);
    parm[@"did"] = jobid;
    
    [XKNetworkManager POSTToUrlString:JianZhiCollection parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            
            //
            
            if (status == 0) {
                [self.panView.shoucangBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [self.panView.shoucangBtn setImage:[UIImage imageNamed:@"collectionNo"] forState:UIControlStateNormal];
                 }else{
                     [self.panView.shoucangBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                     [self.panView.shoucangBtn setImage:[UIImage imageNamed:@"collectionYes"] forState:UIControlStateNormal];
                 }
                 
                 
                 
                 
            
                 }else{
                     [weakSelf showHint:@"收藏失败"];
                 }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)baomingWithJobID:(NSString *)jobid{
    MJWeakSelf
    
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"jobid"] = jobid;
    parm[@"memberid"] =  usermodel.userID;
    parm[@"t"] = @(1);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [XKNetworkManager POSTToUrlString:JianZhiBaoMing parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf showHint:@"报名成功"];
            
          
            weakSelf.panView.baomingBtn.userInteractionEnabled = NO;
            [weakSelf.panView.baomingBtn setBackgroundColor:[UIColor lightGrayColor]];
            [self.panView.baomingBtn setTitle:@"已报名" forState:UIControlStateNormal];
            
        }else{
             [weakSelf showHint:result[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HRadio(185);
    }else if (indexPath.section == 1){
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 2){
        return self.tempCell.cellheight;
    }else{
        return 125;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JianZhiDetailFirstCell *fistCell = [tableView dequeueReusableCellWithIdentifier:@"JianZhiDetailFirstCell"];
        fistCell.nameLabel.text = self.detailModel.title;
        NSString *salary = self.detailModel.salary;
        NSString *unit = [NSString unitJianZhiWithType:[self.detailModel.unit integerValue]];
        fistCell.priceLabel.text = self.detailModel.wn;
        
//        [NSString stringWithFormat:@"%@/%@",salary,unit];
        fistCell.areaLabel.text = self.detailModel.work_area;
        
        fistCell.jiesuanLabel.text = [NSString settmenJianZhiWithType:[self.detailModel.settlement integerValue]];
        
        fistCell.numberLabel.text = [NSString stringWithFormat:@"招聘人数: %@人/天",self.detailModel.person_number];
        fistCell.endDateLabel.text =[NSString stringWithFormat:@"工作开始: %@",self.detailModel.start_date];
        
        
        fistCell.workLabel.text = [NSString stringWithFormat:@"工作地点: %@ %@",self.detailModel.detail_area,self.detailModel.address];
        
        fistCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return fistCell;
    }else if (indexPath.section == 1){
        JianZhiDetailSecondCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"JianZhiDetailSecondCell"];
        twoCell.descLabel.text = self.detailModel.describe;
         twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return twoCell;
    }else if (indexPath.section == 2){
        JianZhiDetailThreeCell *threeCell = [tableView dequeueReusableCellWithIdentifier:@"JianZhiDetailThreeCell"];
        NSString *jobType = [NSString jobTypeWithType:[self.detailModel.jobType integerValue]];
        NSString *heigth = [NSString stringWithFormat:@"身高:%@-%@",self.detailModel.heightMin,self.detailModel.heightMax];
        NSString *sex = [NSString sexWithSheHe:[self.detailModel.sex integerValue]];
        NSString *age = [NSString stringWithFormat:@"年龄:%@-%@",self.detailModel.ageMin,self.detailModel.ageMax];
        
        NSArray *arry = @[jobType,heigth,sex,age];
        threeCell.datas = arry;
        
        [threeCell setUItags];
        
        self.tempCell = threeCell;
         threeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return threeCell;
    }else{
        JianZhiDetailFourCell *fourCell = [tableView dequeueReusableCellWithIdentifier:@"JianZhiDetailFourCell"];
        fourCell.contactNameLabel.text = [NSString stringWithFormat:@"姓名: %@",self.detailModel.contact];
        
        fourCell.phoneLable.text = @"电话号码:";
        
        [fourCell.telBtn setTitle:self.detailModel.phone forState:UIControlStateNormal];
        
         [fourCell.telBtn setTitleColor:UIColorFromRGBString(@"0xf16156") forState:UIControlStateNormal];
        
        fourCell.telblock = ^(UIButton *btn) {
            
            NSString *str = [NSString stringWithFormat:@"telprompt://%@",self.detailModel.phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        };
        fourCell.emailLabel.text = [NSString stringWithFormat:@"邮箱: %@",self.detailModel.email];
        fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return fourCell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headView.backgroundColor = UIColorFromRGBString(@"0xededed");
    return headView;
}
@end
