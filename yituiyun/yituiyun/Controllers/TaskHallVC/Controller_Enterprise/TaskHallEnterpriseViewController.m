//
//  TaskHallEnterpriseViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/10.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "TaskHallEnterpriseViewController.h"
#import "TaskEnterpriseDetailViewController.h"
#import "ProjectModel.h"
#import "TaskHallEnterpriseCell.h"
#import "FXNeedsListController.h"
#import "TaskHallCompanyHeadView.h"
#import "TaskHallModel.h"
#import "LHKTaskHallCell.h"
#import "ProjectDetailViewController.h"
#import "AddOrderVc.h"
#import "OrderPayVc.h"
#import "JianZhiFistListView.h"
#import "CompanyNeedDesc.h"
#import "TaskHallEnterpriseDetailJianZhiVC.h"
#import "LHKLeftButoon.h"
#import "JianZhiContainerVC.h"

@interface TaskHallEnterpriseViewController ()<TaskHallEnterpriseCellDelegate,TaskHallCompanyHeadViewDelegate,UITableViewDelegate,UITableViewDataSource>
/** 按钮下滑动的线  */
@property (nonatomic,strong) UIView* BtnlineView;

/** 数据源  */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 主视图 */
@property (nonatomic,strong) UITableView* tableView;

/** 未执行按钮 */
@property (nonatomic,strong) UIButton* releaseBtn;
/** 执行中按钮 */
@property (nonatomic,strong) UIButton* implementBtn;
/** 已停止按钮 */
@property (nonatomic,strong) UIButton* stopBtn;
/** 已完成按钮 */
@property (nonatomic,strong) UIButton* completeBtn;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isremo;

@property (nonatomic, assign) NSInteger select;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@property(nonatomic,strong) TaskHallCompanyHeadView * headView;
@property(nonatomic,strong) JianZhiFistListView * listView;
@property(nonatomic,assign)NSInteger  rightType;

@property(nonatomic,strong) UIButton * rightChangeBtn;
@end

@implementation TaskHallEnterpriseViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}

-(TaskHallCompanyHeadView *)headView{
    if (_headView == nil) {
        _headView = [TaskHallCompanyHeadView headSelectView];
                _headView.frame = CGRectMake(0, 0, ScreenWidth, WRadio(44));
        _headView.delegate = self;
    }
    return _headView;
}

-(void)setUpTableView{
    //初始化 tableview
    MJWeakSelf
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WRadio(44), self.view.frame.size.width, self.view.frame.size.height - 64 - WRadio(44) - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"LHKTaskHallCell" bundle:nil] forCellReuseIdentifier:@"TaskHallCell"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page =1;
        
        if (weakSelf.rightType == 0) {
            
            [weakSelf getMyTaskHall];
        }else{
            [weakSelf getJianZhiData];
        }
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        if (weakSelf.rightType == 0) {
            [weakSelf getMyTaskHall];
        }else{
            [weakSelf getJianZhiData];
        }
    }];
    
    [self.view addSubview:_tableView];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//          NSLog(@"=======%@",[ZQ_AppCache userInfoVo].userID);
    [self setupNav];
    self.rightType = 0;//我的需求
    
    
    [MobClick event:@"clickTaskNums"];
    
    //右上角的button
    
    LHKLeftButoon *btn = [[LHKLeftButoon alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
//    btn.backgroundColor = [UIColor whiteColor];
//    btn.layer.cornerRadius = 5;
    [btn setTitle:@"我的需求" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"jianzhi_jiantao"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.clipsToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(publishNeeds:) forControlEvents:UIControlEventTouchUpInside];
    self.rightChangeBtn = btn;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    
   
    UIBarButtonItem *rigtBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    negativeSpacer.width = -20;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rigtBtn,nil];
    [self.view addSubview:self.headView];
    
    
    
    self.select = 6;
    
    [self setUpTableView];
    
    
    [self.tableView.mj_header beginRefreshing];

    self.tableView.hidden = YES;
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark -- 切换右上角的按钮

-(JianZhiFistListView *)listView{
    MJWeakSelf
    if (_listView == nil) {
        CGRect rect = [self.rightChangeBtn.superview convertRect:self.rightChangeBtn.frame toView:[UIApplication sharedApplication].keyWindow];
        
        NSArray *datas = @[@"我的需求",@"我的招聘"];
        
        _listView = [[JianZhiFistListView alloc]initWithRect:rect andDatas:datas];
        
        
        _listView.listreturnblock = ^(NSString *str,NSInteger index) {
            [weakSelf.rightChangeBtn setTitle:str forState:UIControlStateNormal];
            
            if (weakSelf.rightType == index) {
                
               
                
            }else{
                //执行操作
                
                if (index == 0) {
                weakSelf.navigationItem.title = @"我的需求";
                }else{
                    weakSelf.navigationItem.title = @"我的招聘";
                }
                
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView reloadData];
                weakSelf.rightType = index;
                
                [weakSelf.tableView.mj_header beginRefreshing];
                
            }
            
        };
    }
    return _listView;
}

-(void)publishNeeds:(LHKLeftButoon *)btn{
   
   

    [[UIApplication sharedApplication].keyWindow addSubview:self.listView];
    
    

}

-(void)taskHallCompanyHeadViewBtnClick:(UIButton *)btn{
    //301 -302 - 303
        
    if (btn.tag == 301) {
        self.select = 6;
        [self.tableView.mj_header beginRefreshing];
    }else if (btn.tag == 302){
        self.select = 7;
         [self.tableView.mj_header beginRefreshing];
    }else if (btn.tag == 303){
        self.select = 8;
         [self.tableView.mj_header beginRefreshing];
    }
}
#pragma mark - setupNav
- (void)setupNav{
    self.title = @"我的需求";
}


-(void)getJianZhiData{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中..."];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    parm[@"memberid"] = userinfo.userID;
    parm[@"status"] = @(self.select);
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @10;
    
    [XKNetworkManager POSTToUrlString:JianZhiCompanyList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *result = JSonDictionary;
        
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        
        if ([code isEqualToString:@"0"] ) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
            /**********/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:result[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            
            /***********/
            [weakSelf.tableView reloadData];

            
           
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showHint:@"服务器数据出错"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];
}

- (void)getMyTaskHall
{
    
    MJWeakSelf
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"memberid"] = model.userID;
    params[@"status"] = @(_select);
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @"10";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=get.taskList"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        /******************/
        
        
    
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
        if ([responseObject[@"errno"] integerValue] == 0) {
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [TaskHallModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [TaskHallModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [TaskHallModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [TaskHallModel objectArrayWithKeyValuesArray:responseObject[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            [weakSelf.tableView reloadData]; 
        }
        

        /*****************/
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
        weakSelf.page--;
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];

    }];
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
    MJWeakSelf
    static NSString *ID = @"TaskHallCell";
    LHKTaskHallCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   
    cell.subImageView.hidden = NO;
    
    if (self.select == 6) {
        
        if (self.rightType == 0) {//我的需求
           /***********/
            TaskHallModel *model = self.dataArray[indexPath.section];
            cell.model = model;

            cell.timeImageView.image = [UIImage imageNamed:@"homecell_time"];
            cell.twoImageView.image = [UIImage imageNamed:@"homecell_shengyudanliang"];

            
            cell.twoBtnPanView.hidden = NO;
            cell.shengyubaozhengjinLabel.hidden = NO;
            
            if ([model.applyStop isEqualToString:@"1"]) {
                cell.tingzhiBtn.hidden = YES;
                cell.addBtn.userInteractionEnabled = NO;
                [cell.addBtn setTitle:@"申请停止中" forState:UIControlStateNormal];
                [cell.addBtn setTitleColor:UIColorFromRGBString(@"0x868686") forState:UIControlStateNormal];
                [cell.addBtn setBackgroundColor:[UIColor whiteColor]];
            }else{
                cell.tingzhiBtn.hidden = NO;
                cell.addBtn.userInteractionEnabled = YES;
                [cell.addBtn setTitle:@"添加单量" forState:UIControlStateNormal];
                [cell.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.addBtn setBackgroundColor:UIColorFromRGBString(@"0xf16156")];
            }
            cell.shengyubaozhengjinLabel.text = [NSString stringWithFormat:@"剩余保证金:%@元",model.surplus_margin];
            
            cell.tingzhiblock = ^{
                
                LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"申请停止任务" andDesc:@"确定申请停止任务" WithCancelBlock:^(LHKAlterView *alterView) {
                    [alterView removeFromSuperview];
                    
                    
                } WithMakeSure:^(LHKAlterView *alterView) {
                    [weakSelf stopNeeds:model.demandid];
                    [alterView removeFromSuperview];
                }];
                
                [[UIApplication sharedApplication].keyWindow addSubview:alt];
                
            };
            
            cell.addblock = ^{
                OrderPayVc *addvc = [[OrderPayVc alloc]init];
                addvc.addprice = model.price;
                addvc.addProjectName = model.projectName;
                addvc.demanID = model.demandid;
                addvc.isAddOrder = YES;
                addvc.isModifyPrice = NO;
                addvc.navigationItem.title = @"添加单量";
                [weakSelf.navigationController pushViewController:addvc animated:YES];
            };
            /**********/
        }else{ //我的招聘
            //
            
            
            
            cell.twoBtnPanView.hidden = NO;
            cell.shengyubaozhengjinLabel.hidden = NO;
            

            CompanyJianZhiModel *model = self.dataArray[indexPath.section];
            
            cell.listmodel = model;
            cell.shengyubaozhengjinLabel.text =[NSString stringWithFormat:@"招聘人数:%@人/天",model.person_number];
            
            if ([model.applyStop isEqualToString:@"1"]) {
                cell.tingzhiBtn.hidden = YES;
                cell.addBtn.userInteractionEnabled = NO;
                [cell.addBtn setTitle:@"申请停止中" forState:UIControlStateNormal];
                cell.timeImageView.image = [UIImage imageNamed:@"tubiao_1"];
                cell.twoImageView.image = [UIImage imageNamed:@"tubiao_2"];
                cell.subImageView.hidden = YES;
                [cell.addBtn setTitleColor:UIColorFromRGBString(@"0x868686") forState:UIControlStateNormal];
                [cell.addBtn setBackgroundColor:[UIColor clearColor]];

                
            }else{
                cell.tingzhiBtn.hidden = YES;
                cell.addBtn.hidden = NO;
                cell.tingzhiBtn.userInteractionEnabled = YES;
                
                cell.addBtn.userInteractionEnabled = YES;
                [cell.addBtn setTitle:@"停止任务" forState:UIControlStateNormal];
                [cell.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.timeImageView.image = [UIImage imageNamed:@"tubiao_1"];
                cell.twoImageView.image = [UIImage imageNamed:@"tubiao_2"];
                cell.subImageView.hidden = YES;
                [cell.addBtn setBackgroundColor:UIColorFromRGBString(@"0xf16156")];

            }
            

           
            //停止
            cell.addblock = ^{
                LHKAlterView *alt = [LHKAlterView alterViewWithTitle:@"提示" andDesc:@"是否停止该招聘" WithCancelBlock:^(LHKAlterView *alterView) {
                    
                    [alterView removeFromSuperview];
                } WithMakeSure:^(LHKAlterView *alterView) {
                    
                    /*****************/
                    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
                    [self stopZhaoPinWithJobId:model.jobid andMemberID:usermodel.userID];
                    
                    /**************/
                    
                    [alterView removeFromSuperview];
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:alt];
            };

        }
        
        
       
    }else{
        
        //需要改的
        if (self.rightType == 0) {
              cell.twoBtnPanView.hidden = NO;
             cell.shengyubaozhengjinLabel.hidden = YES;
            
            TaskHallModel *model = self.dataArray[indexPath.section];
            cell.model = model;
            cell.timeImageView.image = [UIImage imageNamed:@"homecell_time"];
            cell.twoImageView.image = [UIImage imageNamed:@"homecell_shengyudanliang"];
           
            
            //重新开始
            
            
            cell.tingzhiBtn.hidden = YES;
            cell.addBtn.userInteractionEnabled = YES;
            [cell.addBtn setTitle:@"重新开始" forState:UIControlStateNormal];
            [cell.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [cell.addBtn setBackgroundColor:UIColorFromRGBString(@"0xf16156")];
            
            cell.addblock = ^{
               
                OrderPayVc *addvc = [[OrderPayVc alloc]init];
                addvc.addprice = model.price;
                addvc.addProjectName = model.projectName;
                addvc.demanID = model.demandid;
                addvc.isAddOrder = YES;
                addvc.isModifyPrice = YES;
                addvc.navigationItem.title = @"添加单量";
                [weakSelf.navigationController pushViewController:addvc animated:YES];
            
            };
            


        }else{
            
            CompanyJianZhiModel *model = self.dataArray[indexPath.section];
            cell.listmodel = model;

              cell.twoBtnPanView.hidden = NO;
            cell.shengyubaozhengjinLabel.hidden = NO;
            cell.shengyubaozhengjinLabel.text =[NSString stringWithFormat:@"招聘人数:%@人/天",model.person_number];
            cell.timeImageView.image = [UIImage imageNamed:@"tubiao_1"];
            cell.twoImageView.image = [UIImage imageNamed:@"tubiao_2"];
            cell.subImageView.hidden = YES;
            
            
            cell.tingzhiBtn.hidden = YES;
            cell.addBtn.userInteractionEnabled = NO;
            [cell.addBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.addBtn setBackgroundColor:[UIColor whiteColor]];
            cell.addblock = ^{
               
                [weakSelf getZhaoPinInfoMation:model.jobid];
            };

        }
     
    }

    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGBString(@"0xefefef");
    
    return cell;
    
}


#pragma mark -- 获取招聘的信息

-(void)getZhaoPinInfoMation:(NSString *)jobid{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userinfo.userID;
    parm[@"jobid"] = jobid;
    [XKNetworkManager POSTToUrlString:JianZhiCompanyListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resut = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resut[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            JianZhiModelDetail *model = [JianZhiModelDetail objectWithKeyValues:resut[@"rst"]];
            
            
            JianZhiContainerVC *containerVC = [[JianZhiContainerVC alloc]init];
            containerVC.detailModel = model;
            
           
                containerVC.ismodfiy = YES;
                
                
                
                [weakSelf setupModifyData:model];
            
            [weakSelf.navigationController pushViewController:containerVC animated:YES];
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];

}
-(void)setupModifyData:(JianZhiModelDetail *)model{
    
    [JianZhiModel shareInstance].title = model.title;
    [JianZhiModel shareInstance].salary = model.salary;
    [JianZhiModel shareInstance].unit = model.unit;
    [JianZhiModel shareInstance].settlement = model.settlement;
    [JianZhiModel shareInstance].person_number  = model.person_number;
    [JianZhiModel shareInstance].start_date = model.start_date;
    [JianZhiModel shareInstance].end_date = model.end_date;
    [JianZhiModel shareInstance].contact = model.contact;
    [JianZhiModel shareInstance].phone = model.phone;
    [JianZhiModel shareInstance].email = model.email;
    [JianZhiModel shareInstance].province = model.province;
    [JianZhiModel shareInstance].city = model.city;
    [JianZhiModel shareInstance].area = model.area;
    [JianZhiModel shareInstance].address = model.address;
    [JianZhiModel shareInstance].describe = model.describe;
    [JianZhiModel shareInstance].ageMin = model.ageMin;
    [JianZhiModel shareInstance].ageMax = model.ageMax;
    [JianZhiModel shareInstance].heightMin = model.heightMin;
    [JianZhiModel shareInstance].heightMax = model.heightMax;
    [JianZhiModel shareInstance].sex = model.sex;
    [JianZhiModel shareInstance].jobType = model.jobType;
    
    
    
    
}

-(void)stopZhaoPinWithJobId:(NSString *)jobID andMemberID:(NSString *)memberid{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"jobid"] = jobID;
    parm[@"memberid"] = memberid;
    
    [XKNetworkManager POSTToUrlString:JianZhiStopHandle parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *result = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",result[@"errno"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf showHint:@"成功停止"];
             [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            [weakSelf showHint:@"停止失败"];
           
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)restartProgrma:(NSString *)dataId{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"demandid"] = dataId;
    dict[@"applyQuest"] = @"1";
    [XKNetworkManager POSTToUrlString:CompanyNeedStop parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        
        if([code isEqualToString:@"0"]) {
            [self showHint:@"操作成功"];
            [self.tableView.mj_header beginRefreshing];
        }else{
            [self showHint:@"操作失败"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showHint:error.localizedDescription];
    }];
    
 
    
}
-(void)stopNeeds:(NSString *)dataId{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"demandid"] = dataId;
    dict[@"applyStop"] = @"1";
    [XKNetworkManager POSTToUrlString:CompanyNeedStop parameters:dict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = JSonDictionary;
        
        
        NSString *code = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
        
        if([code isEqualToString:@"0"]) {
            [self showHint:@"取消成功"];
            [self.tableView.mj_header beginRefreshing];
        }else{
            [self showHint:@"取消失败失败"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showHint:error.localizedDescription];
    }];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (self.select == 6) {
//        return 10;
//    }
//    return 0.00001;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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
    
   //需求
    
//    if (self.rightType == 0) {
        if (ScreenWidth<375) {
               return HRadio(140);
        }
        return 135;
   
//    }
    
    
//    if (self.select == 6) {
//        if (ScreenWidth<375) {
//            return HRadio(140);
//        }
//        return 135;
//    }
//    
//    if (ScreenWidth<375) {
//         return HRadio(90);
//    }
//    return 90;
////招聘
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    
    if (self.rightType == 0) {
        TaskHallModel *model = self.dataArray[indexPath.section];
        
        
        
        ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] initWithDataId:model.demandid WithType:@"11" WithWhere:1];
        pushToControllerWithAnimated(vc)
    }else{
        
        CompanyJianZhiModel *model = self.dataArray[indexPath.section];
        [self zhaoPinSelect:model.jobid];
        
    }
    
    
    

}

-(void)zhaoPinSelect:(NSString*)jobID{
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
   
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = userinfo.userID;
    parm[@"jobid"] = jobID;
    [XKNetworkManager POSTToUrlString:JianZhiCompanyListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *resut = JSonDictionary;
        NSString *code = [NSString stringWithFormat:@"%@",resut[@"errno"]];
        
        if ([code isEqualToString:@"0"]) {
            JianZhiModelDetail *model = [JianZhiModelDetail objectWithKeyValues:resut[@"rst"]];
            
            TaskHallEnterpriseDetailJianZhiVC *VC = [[TaskHallEnterpriseDetailJianZhiVC alloc]init];
            VC.title =model.title;
            VC.detailModel = model;
            [self.navigationController pushViewController:VC animated:YES];
            
            
            
        }else{
            [weakSelf showHint:@"返回数据错误"];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
        
    }];

}


@end
