//
//  FXNeedsListController.m
//  yituiyun
//
//  Created by fx on 16/11/1.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "FXNeedsListController.h"
#import "FXNeedsModel.h"
#import "FXNeedsCell.h"
#import "FXNeedsDetailController.h"
#import "FXNeedsPublishController.h"
//#import "FXPersonInfoController.h"
#import "JXPersonInfoViewController.h"
#import "FXCompanyInfoController.h"
#import "FXUploadPhotoController.h"
#import "CompayNeedsCoverView.h"
#import "CompanyNeedscontainer.h"
#import "CompanyNeedListModel.h"
#import "OrderPayVc.h"
#import "CompanyNeedListOneCell.h"
#import "CompanyNeedListTwoCell.h"
#import "NSString+LHKExtension.h"
#import "CompanyNeedDesc.h"
#import "NSString+LHKExtension.h"
#import "ZQ_CommonTool.h"
#import "JianZhiContainerVC.h"
#import "TaskHallPersonHeadSelectView.h"


@interface FXNeedsListController ()<UITableViewDelegate,UITableViewDataSource,FXNeedsPublishControllerDelegate,FXNeedsDetailControllerDelegate,FXUploadPhotoControllerDelegate,CompayNeedsCoverViewDelegate,TaskHallPersonHeadSelectViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *jianzhidataArray;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic, strong) UILabel *thereLabel1;
@property (nonatomic, copy) NSString *newpage;
@property (nonatomic, assign) BOOL isremo;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, strong) UIButton *rightButton;
@property(nonatomic,assign)NSInteger  page;

@property(nonatomic,strong) CompayNeedsCoverView * coverView;
@property(nonatomic,strong) CompanyNeedscontainer * containerVC;

@property(nonatomic,strong) TaskHallPersonHeadSelectView * selectHeadView;
@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,strong) UIImageView * nodataImageView;

@end

@implementation FXNeedsListController


-(UIImageView *)nodataImageView{
    if (_nodataImageView == nil) {
        _nodataImageView = [[UIImageView alloc]init];
        _nodataImageView.image = [UIImage imageNamed:@"NodataTishi"];
    }
    return _nodataImageView;
}



-(TaskHallPersonHeadSelectView *)selectHeadView{
    if (_selectHeadView == nil) {
        _selectHeadView = [TaskHallPersonHeadSelectView headSelectView];
        _selectHeadView.frame = CGRectMake(0, 0, ScreenWidth, 44);
        _selectHeadView.delegate = self;
        [_selectHeadView.taskBtn setTitle:@"任务" forState:UIControlStateNormal];
        _selectHeadView.taskBtn.selected = YES;
        [_selectHeadView.historyTaskbtn setTitle:@"招聘" forState:UIControlStateNormal];
        
    }
    return _selectHeadView;
}
-(void)mytaskBtnToClick:(UIButton *)btn{
    
    self.selectType = 1;
    [self.tableView reloadData];
  
    [self.tableView.mj_header beginRefreshing];
}
-(void)myhistorytaskBtnToClick:(UIButton *)btn{
   
    self.selectType = 2;
   [self.tableView reloadData];
 
    
     [self.tableView.mj_header beginRefreshing];
}
-(CompanyNeedscontainer *)containerVC{
    if (_containerVC == nil) {
        _containerVC = [[CompanyNeedscontainer alloc]init];
    }
    return _containerVC;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView !=nil) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(CompayNeedsCoverView *)coverView{
    if (_coverView ==nil) {
        _coverView = [CompayNeedsCoverView coverView];
        _coverView.frame = self.view.bounds;
        _coverView.delegate = self;
    }
    return _coverView;
}
- (instancetype)initWithWhere:(NSInteger)where
{
    self = [super init];
    if (self) {
        self.where = where;
    }
    return self;
}

#pragma mark -  CompayNeedsCoverViewDelegate

-(void)compayNeedsCoverViewBtnClick:(CompayNeedsCoverView *)compayCoverView{
   
    [MobClick event:@"qiyexuqiufaburenwu"];
    [self.navigationController pushViewController:[CompanyNeedscontainer new] animated:YES];
    
    

    
    [self.coverView removeFromSuperview];
    self.coverView = nil;

    

    
}

-(void)compayNeedsCoverViewJianZhiBtnClick:(CompayNeedsCoverView *)compayCoverView{
    
    JianZhiContainerVC *containerVC = [[JianZhiContainerVC alloc]init];

    [self.navigationController pushViewController:containerVC animated:YES];
    
    [self.coverView removeFromSuperview];
    self.coverView = nil;


    
}

-(NSMutableArray *)jianzhidataArray{
    if (_jianzhidataArray == nil) {
        _jianzhidataArray = [[NSMutableArray alloc]init];
    }
    return _jianzhidataArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.selectType = 1;
    self.isremo = YES;
    self.newpage = @"1";
    self.title = @"企业需求";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WRadio(25), HRadio(25))];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(leftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"system_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"qiyexuqiu" selectedImage:@"qiyexuqiu" target:self action:@selector(publishNeedsClick)];
    
   
    
    self.nodataImageView.hidden = YES;
    
    [self.view addSubview:self.selectHeadView];
  
    [self.view addSubview:self.tableView];
   
    [self.tableView.mj_header beginRefreshing];
    
    [MobClick event:@"qiyexuqiu"];
    
     [self.view addSubview:self.nodataImageView];
    [self.nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(WRadio(55)));
        make.height.mas_equalTo(@(HRadio(65)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(HRadio(80));
    }];
    
    

}

- (void)leftBarButtonItem{
    if (_where == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_where == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//发布新需求
- (void)publishNeedsClick{
    
    [self getCompanyInfo];
    

}

- (UITableView*)tableView{
    if (!_tableView) {
        MJWeakSelf
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 64-44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView registerNib:[UINib nibWithNibName:@"CompanyNeedListOneCell" bundle:nil] forCellReuseIdentifier:@"CompanyNeedListOneCell"];
         [_tableView registerNib:[UINib nibWithNibName:@"CompanyNeedListTwoCell" bundle:nil] forCellReuseIdentifier:@"CompanyNeedListTwoCell"];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page =1;
            
            
            if (weakSelf.selectType == 1) {
                    [weakSelf getNeedsData];
            }else{
                [weakSelf getZhaoPinListData];
            }
            
        
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            weakSelf.page++;
            if (weakSelf.selectType == 1) {
                [weakSelf getNeedsData];
            }else{
                [weakSelf getZhaoPinListData];
            }
        }];

    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.selectType == 1) {
        return self.dataArray.count;
    }
    return self.jianzhidataArray.count;
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
    
    if (self.selectType == 1) {
        CompanyNeedListModel  *model = self.dataArray[indexPath.section];
        
        if ([model.status isEqualToString:@"3"] || [model.status isEqualToString:@"1"] || [model.status isEqualToString:@"4"]) {
            return 100;
            
        }
    }
    
    if (self.selectType == 2) {
        
        CompanyJianZhiModel  *model1 = self.jianzhidataArray[indexPath.section];
        
        if ([model1.status isEqualToString:@"3"]) {
        
            return 100;
        }
    }
    
    
    return 65;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //第二个
    if (self.selectType == 2) {
        
    
        CompanyJianZhiModel  *model1 = self.jianzhidataArray[indexPath.section];
        
        if ([model1.status isEqualToString:@"3"]) {
            //待支付
            
            
            CompanyNeedListOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyNeedListOneCell"];
            
            ;
            oneCell.projectNameLabel.text = model1.title;
            oneCell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model1.inputtime];
            
            oneCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
           
                
                oneCell.statusLabel.hidden = YES;
            
                oneCell.fistLabel.hidden = NO;
                oneCell.secondLabel.hidden = NO;
                oneCell.againPulishOrPay.hidden = NO;
                oneCell.cancelBtn.hidden = YES;
                oneCell.deleteBtn.hidden = YES;
            
                oneCell.fistLabel.text = [self statusWith:[model1.status integerValue]];
                oneCell.secondLabel.text = [NSString stringWithFormat:@"需支付保证金:%@元",model1.margin_amount];
         
            
            
            
            MJWeakSelf
            //等待支付的过程
            oneCell.agin_payBlock = ^{
                
                OrderPayVc *orderVC = [[OrderPayVc alloc]init];
                orderVC.demanID= model1.jobid;
                orderVC.isZhaoPin = YES;
                orderVC.navigationItem.title = @"支付保证金";
                
                [weakSelf.navigationController pushViewController:orderVC animated:YES];
            };
            
            return oneCell;

            
        }else{
            CompanyNeedListTwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyNeedListTwoCell"];
            twoCell.fistLabel.hidden = NO;
            twoCell.secondLabel.hidden = NO;
            twoCell.statusLabel.hidden = YES;
            twoCell.projectNameLabel.text = model1.title;
            twoCell.fistLabel.text = [NSString JianZhiStatusWithType:[model1.status integerValue]];
            twoCell.secondLabel.text = [NSString stringWithFormat:@"已支付保证金:%@元",model1.margin_amount];
            
            
            twoCell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model1.inputtime];
            
            if ([model1.status isEqualToString:@"1"]) {
                twoCell.secondLabel.hidden = YES;
            }else{
                twoCell.secondLabel.hidden = NO;
            }
            

            return twoCell;
        }
       
        
    }
    
    
    
    
      CompanyNeedListModel  *model = self.dataArray[indexPath.section];
    
    
    if ([model.status isEqualToString:@"3"] || [model.status isEqualToString:@"1"] || [model.status isEqualToString:@"4"]) {
        //第一个
        CompanyNeedListOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyNeedListOneCell"];
        
        oneCell.model = model;
        oneCell.projectNameLabel.text = model.projectName;
        oneCell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model.inputtime];
        
        oneCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if ([model.status isEqualToString:@"3"]) {
            
            oneCell.statusLabel.hidden = YES;
            oneCell.fistLabel.hidden = NO;
            oneCell.secondLabel.hidden = NO;
            
            oneCell.fistLabel.text = [self statusWith:[model.status integerValue]];
            oneCell.secondLabel.text = [NSString stringWithFormat:@"需支付保证金:%@元",model.margin_amount];
            
            
        }else{
            
            
            oneCell.statusLabel.hidden = NO;
            oneCell.statusLabel.text = [self statusWith:[model.status integerValue]];
            oneCell.fistLabel.hidden = YES;
            oneCell.secondLabel.hidden = YES;

            
        }
        
        
        
        MJWeakSelf
        //等待支付的过程
        oneCell.agin_payBlock = ^{
            [MobClick event:@"qiyexuqiuquzhifu"];
            OrderPayVc *orderVC = [[OrderPayVc alloc]init];
             orderVC.demanID= model.demandid;
            orderVC.navigationItem.title = @"支付保证金";

            [weakSelf.navigationController pushViewController:orderVC animated:YES];
         };
        
        //取消任务
        oneCell.cancelBlock = ^{
            [MobClick event:@"qiyexuqiuquxiaorenwu"];
            LHKAlterView *alterView = [LHKAlterView alterViewWithTitle:@"取消任务" andDesc:@"是否取消任务" WithCancelBlock:^(LHKAlterView *alterView) {
                [alterView removeFromSuperview];
                
            } WithMakeSure:^(LHKAlterView *alterView) {

                [alterView removeFromSuperview];
                [weakSelf cancelTaskWithID:model.demandid];

            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alterView];
            
          
            
        };
        //删除
        oneCell.onedeleteblock = ^{
          
            
            LHKAlterView *alterView = [LHKAlterView alterViewWithTitle:@"删除任务" andDesc:@"是否删除任务" WithCancelBlock:^(LHKAlterView *alterView) {
                [alterView removeFromSuperview];
                
            } WithMakeSure:^(LHKAlterView *alterView) {
                
                [alterView removeFromSuperview];
                [weakSelf deleteTaskWithID:model.demandid];
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alterView];
            
        };
        

        return oneCell;
        
        
    }else{
        
        MJWeakSelf
        CompanyNeedListTwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"CompanyNeedListTwoCell"];
        twoCell.model = model;
        


        twoCell.projectNameLabel.text = model.projectName;
    twoCell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model.inputtime];
        
        twoCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if ([model.status isEqualToString:@"0"] || [model.status isEqualToString:@"6"]) {
            
            twoCell.fistLabel.hidden = NO;
            twoCell.secondLabel.hidden = NO;
            twoCell.statusLabel.hidden = YES;
            twoCell.fistLabel.text = [self statusWith:[model.status integerValue]];;
            twoCell.secondLabel.text = [NSString stringWithFormat:@"已支付保证金:%@元",model.margin_amount];
        }else{
            twoCell.fistLabel.hidden = YES;
            twoCell.secondLabel.hidden = YES;
            twoCell.statusLabel.hidden = NO;
            twoCell.statusLabel.text = [self statusWith:[model.status integerValue]];
        }
        

        return twoCell;
    }
    return nil;


}

-(void)deleteTaskWithID:(NSString *)memrID{
    
    
    
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"正在删除.."];
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"demandid"] = memrID;
    parm[@"memberid"] = user.userID;
    
    [XKNetworkManager POSTToUrlString:CompanyDeleteNeedTask parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *result = JSonDictionary;
        NSString *parm = [NSString stringWithFormat:@"%@",result[@"errno"]];
        
        if ([parm isEqualToString:@"0"]) {
            [weakSelf showHint:@"删除成功"];
            [weakSelf getNeedsData];

        }else{
            [weakSelf showHint:@"删除失败"];
        }

        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf showHint:error.localizedDescription];
    }];

    
}
-(void)cancelTaskWithID:(NSString *)memrID{
    
    MJWeakSelf
    
    UserInfoModel *user = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"demandid"] = memrID;
    parm[@"memberid"] = user.userID;
    
    [XKNetworkManager POSTToUrlString:CompanyNeedsCancelTask parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        
        
        NSDictionary *resultDict = JSonDictionary;
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            [weakSelf showHint:@"取消成功"];
            [weakSelf getNeedsData];
        }else{
            [weakSelf showHint:@"取消失败"];
        }
        
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark - 根据int类型 返回字符串类型
-(NSString *)statusWith:(NSInteger)type{
    if (type == 0) {
       return @"需求待审核";
    }else if (type == 1){
         return @"需求未通过";
    }else if (type == 2){
         return @"需求通过";
    }else if (type == 3){
         return @"待付款";
    }else if (type == 6){
         return @"任务开始";
    }else if (type == 7){
         return @"任务停止";
    }else if (type == 8){
         return @"任务完成";
    }else if (type ==4){
        return @"任务已取消";
    }

  return @"任务错误";

}

#pragma mark -- 重新设置数据

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      MJWeakSelf
    
    //招聘的详情
    if (self.selectType == 2) {
           CompanyJianZhiModel  *newmodel = self.jianzhidataArray[indexPath.section];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        UserInfoModel *userinfo = [ZQ_AppCache userInfoVo];
      
        
       
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        parm[@"memberid"] = userinfo.userID;
        parm[@"jobid"] = newmodel.jobid;
        [XKNetworkManager POSTToUrlString:JianZhiCompanyListDetail parameters:parm progress:^(CGFloat progress) {
            
        } success:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            NSDictionary *resut = JSonDictionary;
            NSString *code = [NSString stringWithFormat:@"%@",resut[@"errno"]];
            
            if ([code isEqualToString:@"0"]) {
                JianZhiModelDetail *model = [JianZhiModelDetail objectWithKeyValues:resut[@"rst"]];
                
                
                JianZhiContainerVC *containerVC = [[JianZhiContainerVC alloc]init];
                containerVC.detailModel = model;
                
                if ([newmodel.status isEqualToString:@"3"] || [newmodel.status isEqualToString:@"1"]) {
                    containerVC.ismodfiy = YES;
                    
                   
                    
                    [weakSelf setupModifyData:model];
                }
                
                [weakSelf.navigationController pushViewController:containerVC animated:YES];
                
                
            }else{
                [weakSelf showHint:@"返回数据错误"];
            }
            
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf showHint:error.localizedDescription];
            
        }];
    }else{
    
    
    
    
    
    
    
  
    CompanyNeedListModel  *bigmodel = self.dataArray[indexPath.section];
        
        

    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"demandid"] = bigmodel.demandid;
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [XKNetworkManager POSTToUrlString:CompayNeedListDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
       
        
        
        NSDictionary *resultDict = JSonDictionary;
        
        
       
        
        CompanyNeedDesc *model = [[CompanyNeedDesc alloc]init];
        
        
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            /***************/
            //第一部分
           
            
        
            
            //项目名称
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"projectName"]]) {
                model.projectName = @"" ;
            }else{
                model.projectName = resultDict[@"rst"][@"projectName"] ;
            }
            //项目类型
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"typeStr"]]) {
                model.typeStr = @"" ;
            }else{
               model.typeStr = resultDict[@"rst"][@"typeStr"] ;    }
            
            model.typeID =  resultDict[@"rst"][@"type"];

           //数量
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"total_single"]]) {
                model.total_single = @"" ;
            }else{
                model.total_single = resultDict[@"rst"][@"total_single"] ;}

            //单价
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"price"]]) {
               model.price = @"";
            }else{
               model.price = resultDict[@"rst"][@"price"];}

            //截止时间
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"endDate"]]) {
              model.endDate = @"";
            }else{
               model.endDate = resultDict[@"rst"][@"endDate"]  ;}
            
            //企业logo、
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"thumb"]]) {
                model.logoImageUrl = @"";
            }else{
                model.logoImageUrl = [NSString imagePathAddPrefix:resultDict[@"rst"][@"thumb"]]  ;}
            

            //城市数组
            if ([ZQ_CommonTool isEmptyArray:resultDict[@"rst"][@"citysArr"]]) {
                model.citysArr = [NSMutableArray array];

            }else{
                model.citysArr = resultDict[@"rst"][@"citysArr"];
//                NSLog(@"------chengshi--");

            }
            
            //城市数组cityid
            model.citys = resultDict[@"rst"][@"citys"];
            
            
            
            //第二部分
            
            if ([ZQ_CommonTool isEmpty:resultDict[@"rst"][@"desc"]]) {
                model.desc = @"";
            }else{
                model.desc = resultDict[@"rst"][@"desc"] ;}
            
            //步骤
            if ([ZQ_CommonTool isEmptyArray:resultDict[@"rst"][@"execute_step"]]) {
                model.execute_step = nil;

                
            }else{
                model.execute_step = resultDict[@"rst"][@"execute_step"];
//                NSLog(@"---buzhu---");
                
            }

            
            
            //第三部分
            
            
            if ([ZQ_CommonTool isEmptyArray:resultDict[@"rst"][@"setting"]]) {
               model.setting = nil;
            }else{
               model.setting = resultDict[@"rst"][@"setting"];
                
            }

            
            CompanyNeedscontainer *contvc = [CompanyNeedscontainer new];
            contvc.model = model;
            
            if ([bigmodel.status isEqualToString:@"3"] || [bigmodel.status isEqualToString:@"1"]) {
                contvc.isCanEditing = YES;
                
                [NeedDataModel shareInstance].demandID = bigmodel.demandid;
                
                
            }else{
                contvc.isCanEditing = NO;
                
            }
           
            


            
            
            [self.navigationController pushViewController:contvc animated:YES];

            
            /***************/
            
        }
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
        
        
    }
    
}


#pragma mark FXNeedsPublishControllerDelegate 发布需求成功刷新列表
- (void)publishSuccessReloadList{
    [self getNeedsData];
}
//上传截图后刷新
- (void)uploadSuccess{
    [self getNeedsData];
}
//详情页状态改变，列表刷新
- (void)detailChangeStatus{
    [self getNeedsData];
}

//判断企业资料完善状态
- (void)getCompanyInfo{
    
  
    _rightButton.userInteractionEnabled = NO;
    __block typeof(self) weakSelf = self;
    NSString *requestURL = [kHost stringByAppendingString:@"api.php?m=user.infoStatus"];
    UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = userModel.userID;
    dic[@"uModelid"] = userModel.identity;
    [weakSelf showHudInView:weakSelf.view hint:@"加载中"];
    [HFRequest requestWithUrl:requestURL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        _rightButton.userInteractionEnabled = YES;

        if ([responseObject[@"errno"] intValue] == 0) {
            NSDictionary *dic = responseObject[@"rst"];
            if ([dic[@"isperfected"] intValue] == 0) {
                [WCAlertView showAlertWithTitle:@"提示"
                                        message:@"您的企业信息尚有多项未填写,还不能发布需求,完善企业信息后即可体验更多功能"
                             customizationBlock:^(WCAlertView *alertView) {
                                 
                             } completionBlock:
                 ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 0) {
                         if ([userModel.identity integerValue] == 6) {
//                             FXPersonInfoController *personVc = [[FXPersonInfoController alloc]init];
                             JXPersonInfoViewController *personVc = [[JXPersonInfoViewController alloc]init];
                             personVc.hidesBottomBarWhenPushed = YES;
                             [self.navigationController pushViewController:personVc animated:YES];
                         } else {
                             FXCompanyInfoController *infoVc = [[FXCompanyInfoController alloc]init];
                             infoVc.hidesBottomBarWhenPushed = YES;
                             [self.navigationController pushViewController:infoVc animated:YES];
                         }
                     }
                 } cancelButtonTitle:@"去完善" otherButtonTitles:nil, nil];
            } else {
//
                [weakSelf.view addSubview:self.coverView];
            
            }
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:error.localizedDescription];
        _rightButton.userInteractionEnabled = YES;

    }];
}


#pragma mark - 企业端招聘列表
-(void)getZhaoPinListData{
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    UserInfoModel *modeUser = [ZQ_AppCache userInfoVo];
    parmDict[@"memberid"] = modeUser.userID;
    parmDict[@"page"] = @(self.page);
    parmDict[@"pagesize"] = @(10);
    [XKNetworkManager POSTToUrlString:JianZhiCompanyList parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = JSonDictionary;
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            
            
            /**********/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [weakSelf.jianzhidataArray removeAllObjects];
                    weakSelf.jianzhidataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                    if (tempdownArray.count == 0) {
                        weakSelf.nodataImageView.hidden = NO;
                    }else{
                              weakSelf.nodataImageView.hidden = YES;
                    }
                    
                }else{
                    [self.jianzhidataArray removeAllObjects];
                    weakSelf.jianzhidataArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [CompanyJianZhiModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.jianzhidataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            
            /***********/
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.tableView reloadData];
            [weakSelf showHint:@"服务器返回错误"];
        }
        

     
        
        
        
        
        
    } failure:^(NSError *error) {
        [weakSelf showHint:error.localizedDescription];
        
    }];
  
    
}
#pragma mark - 企业端发布需求列表

- (void)getNeedsData{
    MJWeakSelf
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    UserInfoModel *modeUser = [ZQ_AppCache userInfoVo];
    parmDict[@"uid"] = modeUser.userID;
    parmDict[@"page"] = @(self.page);
    parmDict[@"pagesize"] = @(10);
    [XKNetworkManager POSTToUrlString:CompanyPulishNeedList parameters:parmDict progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];

        NSDictionary *resultDict = JSonDictionary;
        
                
        if ([resultDict[@"errno"] isEqualToString:@"0"]) {
            
            
            /**********/
            
            if (self.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [CompanyNeedListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempdownArray.count<10) {
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyNeedListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];

                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                    if (tempdownArray.count == 0) {
                        weakSelf.nodataImageView.hidden = NO;
                    }else{
                        weakSelf.nodataImageView.hidden = YES;
                    }
                    
                }else{
                    [self.dataArray removeAllObjects];
                    weakSelf.dataArray = [CompanyNeedListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];

                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [CompanyNeedListModel objectArrayWithKeyValuesArray:resultDict[@"rst"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.dataArray addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            
            /***********/
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.tableView reloadData];
            [weakSelf showHint:@"服务器返回错误"];
        }
        
        

        
        
        
    } failure:^(NSError *error) {
        self.page --;
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];

        
    }];
    
    
}

- (void)configuration:(NSArray *)array
{
    if (_isremo == YES) {
        if ([self.dataArray count] != 0) {
            [self.dataArray removeAllObjects];
        }
    }
    if (![ZQ_CommonTool isEmptyArray:array]) {
        [self.dataArray addObjectsFromArray:array];
    }
    if (self.dataArray.count == 0) {
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
        _thereLabel.text = @"您还没有发布任何需求";
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

-(void)dealloc{
    NSLog(@"-----企业需求控制器---");
}
@end
