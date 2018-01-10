//
//  MoneyDetailVc.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/21.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "MoneyDetailVc.h"
#import "MoneyDetailCell.h"
#import "MoneyDetailModel.h"
#import "NSString+LHKExtension.h"
#import "MoneyDetailContentVc.h"

@interface MoneyDetailVc ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *total_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *service_taxLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *middlePanView;

@property(nonatomic,strong) NSMutableArray * datas;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIView *fenjiexian;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fenjiexianConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middlePanViewConstant;
@property(nonatomic,strong) NSMutableArray * tixianDatas;

@property(nonatomic,assign)NSInteger  page;

@property(nonatomic,assign)NSInteger  type;
@end

@implementation MoneyDetailVc

-(NSMutableArray *)datas{
    if (_datas ==nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(NSMutableArray *)tixianDatas{
    if (_tixianDatas == nil) {
        _tixianDatas = [NSMutableArray array];
    }
    return _tixianDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.oneBtn.selected  = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyDetailCell" bundle:nil] forCellReuseIdentifier:@"MoneyDetailCell"];
    self.type = 1;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    if ([usermodel.identity isEqualToString:@"5"]) {
        [self.oneBtn setTitle:@"交易明细" forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        [self.twoBtn setTitle:@"退款记录" forState:UIControlStateNormal];
        [self.twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [self.twoBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.middlePanView.hidden = YES;
        
        self.middlePanViewConstant.constant = 0.001;
    
    }
    self.page = 1;

    
    //刷新空间
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page =1;
        
        if (weakSelf.type == 1) {
            [weakSelf getjiaoYiData];
        }else{
               [weakSelf getTiXianData];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        if (weakSelf.type == 1) {
            [weakSelf getjiaoYiData];
        }else{
            [weakSelf getTiXianData];
        }
     
    }];
    
    [self.tableView.mj_header beginRefreshing];

}

- (IBAction)oneBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return ;
        
    }
        [self updatContstant];
    self.twoBtn.selected = NO;
    self.fenjiexianConstant.constant = 0;
    self.rightContstant.constant = 0;
    sender.selected = !sender.selected;
    
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    if ([usermodel.identity isEqualToString:@"5"]) {
        self.middlePanView.hidden = YES;
        self.middlePanViewConstant.constant = 0.001;
    }else{
        self.middlePanViewConstant.constant = 90;
        self.middlePanView.hidden = NO;

    }
    
    self.type = 1;
    self.page = 1;
    [self getjiaoYiData];

}
- (IBAction)twoBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return ;
    }

    self.oneBtn.selected = NO;
    self.fenjiexianConstant.constant = ScreenWidth *0.5;
    self.rightContstant.constant= ScreenWidth *0.5;
    self.middlePanViewConstant.constant = 0.001;
    self.middlePanView.hidden = YES;
    
    [self updatContstant];
    sender.selected = !sender.selected;
    self.type = 2;
    self.page = 1;
    [self getTiXianData];

}


-(void)updatContstant{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)getjiaoYiData{  //交易明细  --- 充值记录
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中.."];
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"uid"] = usermodel.userID;
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @(10);
    [XKNetworkManager POSTToUrlString:MyMoneyDetail parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
    
        NSDictionary *resutDic =JSonDictionary;
        
        
        
        NSString *myerror = [NSString stringWithFormat:@"%@",resutDic[@"errno"]];
        
        /***************/
        
//        NSLog(@"%@",resutDic);

        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
//        NSLog(@"%@",resutDic);
        if ([myerror isEqualToString:@"0"]) {
            
            if ([usermodel.identity isEqualToString:@"6"]) {
                weakSelf.total_moneyLabel.text = [NSString stringWithFormat:@"%@",resutDic[@"rst"][@"total_money"]];
                weakSelf.service_taxLabel.text = [NSString stringWithFormat:@"%@",resutDic[@"rst"][@"service_tax"]];
            }
            
            
            if (weakSelf.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [MoneyDetailModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                
                if (tempdownArray.count<10) {
                    [weakSelf.datas removeAllObjects];
                    weakSelf.datas = [MoneyDetailModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.datas removeAllObjects];
                    weakSelf.datas = [MoneyDetailModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [MoneyDetailModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.datas addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
            [weakSelf.tableView reloadData]; 
        }

        /**************/
        
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        weakSelf.page --;
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];

    }];
}

-(void)getTiXianData{  //提现-----退款记录
    
    MJWeakSelf
    [SVProgressHUD showWithStatus:@"加载中.."];
    UserInfoModel *usermodel = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"memberid"] = usermodel.userID;
    parm[@"page"] = @(self.page);
    parm[@"pagesize"] = @(10);
    [XKNetworkManager POSTToUrlString:TiXianRecordList parameters:parm progress:^(CGFloat progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resutDic =JSonDictionary;
//        NSLog(@"----%@tixian",resutDic);
        NSString *myerror = [NSString stringWithFormat:@"%@",resutDic[@"errno"]];
        
        /***************/
        
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        
        if ([myerror isEqualToString:@"0"]) {
            if (weakSelf.page == 1) {
                //下拉的时候
                NSArray *tempdownArray = [TixianListModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                
//                NSLog(@"%@",tempdownArray);
                
                if (tempdownArray.count<10) {
                    [weakSelf.tixianDatas removeAllObjects];
                    weakSelf.tixianDatas = [TixianListModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    [self.tixianDatas removeAllObjects];
                    weakSelf.tixianDatas = [TixianListModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                    
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    
                }
                
            }else{
                //上拉的时候
                
                NSArray *tempArray = [TixianListModel objectArrayWithKeyValuesArray:resutDic[@"rst"][@"list"]];
                
                if (tempArray.count==0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    
                    [weakSelf.tixianDatas addObjectsFromArray:tempArray];
                    
                    
                }
                
                
            }
          
        }
          [weakSelf.tableView reloadData];
        /**************/
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        weakSelf.page --;
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HRadio(65);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (self.type == 1) {
        return self.datas.count;
    }
    return self.tixianDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyDetailCell"];
 
  
    
    if (self.type == 1) {
          MoneyDetailModel *model = self.datas[indexPath.row];
        cell.nameLabel.text = model.intro;
        cell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:model.add_time];

         cell.moneyLabel.text = model.money;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tixianMoneyLabel.hidden = YES;
        cell.tixianStatusLabel.hidden = YES;
        cell.moneyLabel.hidden = NO;
    }else{
        TixianListModel *model = self.tixianDatas[indexPath.row];
        
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
       
        if ([userModel.identity isEqualToString:@"5"]) {
            cell.nameLabel.text = @"退款";
        }else{
            cell.nameLabel.text = @"提现";
        }
        
        NSString *timeStr =[NSString stringWithFormat:@"%@",model.inputtime];
        cell.timeLabel.text = [NSString timeHasSecondTimeIntervalString:timeStr];
        cell.moneyLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tixianMoneyLabel.text = model.money;
        cell.tixianStatusLabel.text = model.status_str;
        cell.tixianMoneyLabel.hidden = NO;
        cell.tixianStatusLabel.hidden = NO;
     }
 
    

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type == 1) {
        MoneyDetailModel *model = self.datas[indexPath.row];
        MoneyDetailContentVc *contentVc = [[MoneyDetailContentVc alloc]init];
        contentVc.type = 1;
        contentVc.model = model;
        contentVc.navigationItem.title = @"明细详情";
        [self.navigationController pushViewController:contentVc animated:YES];
    }else{
        TixianListModel *model = self.tixianDatas[indexPath.row];
        MoneyDetailContentVc *contentVc = [[MoneyDetailContentVc alloc]init];
        contentVc.type = 2;
        contentVc.tixianModel = model;
        UserInfoModel *userModel = [ZQ_AppCache userInfoVo];
        if ([userModel.identity isEqualToString:@"5"]) {
            
            contentVc.navigationItem.title = @"退款详情";
        }else{
            contentVc.navigationItem.title = @"提现详情";
        }

        [self.navigationController pushViewController:contentVc animated:YES];

    }
    

}

@end
